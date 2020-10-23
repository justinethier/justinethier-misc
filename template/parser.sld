(define-library (parser)
  (export
    parse
  )
  (import
    (scheme base)
    (scheme read)
    (scheme write)
  )
  (begin

; Algorithm
;
; - read string from input
; - does string contain embedded expr?
;   - yes, split string at that point, put beginning into expr list, parse the rest (possibly more reads req'd)
;   - no, append to string list
;

(define *read-size* 1024)

(define-record-type <buf>
  (%make-buf fp buf exprs)
  buf?
  (fp buf:fp)
  (str buf:str buf:set-str!)
  (exprs buf:exprs buf:set-exprs!)
)

(define (make-buf fp)
  (%make-buf
   fp
   (read-string *read-size* fp)
   '()))

(define (buf:read-next-string! buf)
  (buf:set-str! buf (read-string *read-size* (buf:fp buf))))

(define (buf:append-next-string! buf)
  (let ((s (buf:str buf)))
    (buf:read-next-string! buf)
    (buf:set-str! buf (string-append s (buf:str buf)))))

;; Return next char from input, starting at position `pos`.
;; Will read more from input stream if necessary
(define (buf:next-char buf pos)
  (cond
    ((< (+ 1 pos) (string-length (buf:str buf)))
     (string-ref (buf:str buf) (+ pos 1)))
    (else
     (buf:append-next-string! buf)
     (buf:next-char buf 0)
     )))


;; Return position of char `chr` within string `str`, starting from index `start`
(define (string-pos str chr start)
  (let loop ((i start))
    (cond
     ((= i (string-length str))
      #f)
     ((equal? (string-ref str i) chr)
      i)
     (else
       (loop (+ i 1))))))

;;; Parse out data for a scheme template comment
;;; Basically reads and discards the whole comment.
(define (parse-string-comment! buf start)
  (let loop ((pos start))
;(write `(loop ,start ,(buf:str buf)))(newline)
    (let ((i (string-pos (buf:str buf) #\# pos)))
;(write `(loop ,i ,(buf:str buf)))(newline)
      (cond
        (i
         (let ((c (buf:next-char buf i)))
;(write `(DEBUG c ,c ,(buf:str buf) ,pos)) (newline)
           (cond
            ((eq? c #\})
;(write `(DEBUG ,(buf:str buf) ,i)) (newline)
             ;; Start buffer from end of comment
             (buf:set-str! 
               buf
               (substring (buf:str buf) (+ i 2) (string-length (buf:str buf)))))

            ((eof-object? c)
             (error "Unexpected end of file parsing Scheme comment" (buf:str buf)))
            (else
              (buf:read-next-string! buf)
              (loop 0)) )))
        (else
         (buf:read-next-string! buf)
         (loop 0))))))

(define (parse-expr! buf start)
  (define expr "")
  (define (add! str)
    (set! expr (string-append expr str)))

  (let loop ((pos start))
    (let ((i (string-pos (buf:str buf) #\} pos)))
;(write `(loop ,i ,(buf:str buf)))(newline)
      (cond
        (i
         (let ((c (buf:next-char buf i)))
;(write `(DEBUG c ,c ,(buf:str buf) ,pos)) (newline)
           (cond
            ((eq? c #\})
;(write `(DEBUG ,(buf:str buf) ,i)) (newline)
             ;; Add expression, return remaining buffer
             ;(if (> (- i 2) pos)
             (add! (substring (buf:str buf) pos i))

             ;; Parse string buffer into an S-expression
             (let ((fp (open-input-string expr)))
              (buf:set-exprs! 
                buf 
                (cons 
                  `(display ,(read fp)) ;(SCHEME ,expr) 
                  (buf:exprs buf)))
              (close-port fp))

             ;; Return extra buffer chars back to the top-level parser
             (buf:set-str! 
               buf
               (substring (buf:str buf) (+ i 2) (string-length (buf:str buf))))) ;; Remaining buffer

            ((eof-object? c)
             (error "Unexpected error parsing Scheme expression" (buf:str buf)))

            (else
              (add! (substring (buf:str buf) pos (string-length (buf:str buf))))
              (buf:read-next-string! buf)
              (loop 0)) )))
        (else
         (add! (substring (buf:str buf) pos (string-length (buf:str buf))))
         (buf:read-next-string! buf)
         (loop 0))))))

;; Top-level parser
(define (parse filename)
 (write `(DEBUG called parse ,filename)) (newline) ;; DEBUG

 (let loop ((buf (make-buf (open-input-file filename))))
  (cond
    ;; EOF?
    ((eof-object? (buf:str buf))
     (close-port (buf:fp buf))
     (map 
       (lambda (expr)
         (cond
           ((string? expr)
            `(display ,expr))
           (else
             expr)))
       (reverse (buf:exprs buf))) )
    (else
      ;; Does the string begin a scheme expression?
      ;; Will eventually need more sophisticated parsing but this works for now
      (let ((spos (string-pos (buf:str buf) #\{ 0)))
        (cond
          (spos
            ;; Include any chars already read, and clear from inp buffer
            (buf:set-exprs!
              buf
              (cons (substring (buf:str buf) 0 spos) (buf:exprs buf)))
            (buf:set-str! 
              buf 
              (substring (buf:str buf) spos (string-length (buf:str buf))))

            (let ((c (buf:next-char buf 0)))
              (cond
                ((eq? c #\#)
                 (parse-string-comment! buf 2)
                 (loop buf))
                ((eq? c #\{)
                 (parse-expr! buf 2)
                 (loop buf))
                (else
                  (write "TODO: parse scheme expression")
                  (newline)
                  (exit 1)))))  ;; TODO: (loop buf)
          (else
            (buf:set-exprs! buf (cons (buf:str buf) (buf:exprs buf)))
            (buf:read-next-string! buf)
            (loop buf))))))))

  )
)
