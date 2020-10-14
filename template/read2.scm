(import (scheme base)
        (scheme write)
        )

; Algorithm
;
; - read string from input
; - does string contain embedded expr?
;   - yes, split string at that point, put beginning into expr list, parse the rest (possibly more reads req'd)
;   - no, append to string list
;

(define *read-size* 2) ;; TODO: 1024?

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

;;TODO: want next 4 vars to be private, really
;(define fp (open-input-file "view-2.html"))
;(define inp (read-string *read-size* fp))
;(define exprs '())

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
;(define (parse-string-comment! str start)
;  (let loop ((s str) ;; TODO: don't store string locally
;             (pos start))
;    (let ((i (string-pos s #\# pos)))
;(write `(loop ,i ,s))(newline)
;      (cond
;        (i
;         (let ((c (next-char s i)))
;(write `(DEBUG c ,c ,s ,pos)) (newline)
;           (cond
;            ((eq? c #\})
;(write `(DEBUG ,s ,i)) (newline)
;             ;; Start buffer from end of comment
;             (substring s (+ i 2) (string-length s)))
;            (else
;              (loop (read-string *read-size* fp) 0)) )))
;        (else
;         (loop (read-string *read-size* fp)
;               0))))))
;
;(define (parse-expr! str start)
;  (define expr "")
;  (define (add! str)
;    (set! expr (string-append expr str)))
;
;  (let loop ((s str)
;             (pos start))
;    (let ((i (string-pos s #\} pos)))
;(write `(loop ,i ,s))(newline)
;      (cond
;        (i
;         (let ((c (next-char s i)))
;(write `(DEBUG c ,c ,s ,pos)) (newline)
;           (cond
;            ((eq? c #\})
;(write `(DEBUG ,s ,i)) (newline)
;             ;; Return expression and remaining buffer
;             (if (> (- i 2) pos)
;                 (add! (substring s pos (string-length s))))
;             ;(values
;             ;  expr ;; Scheme expression (as string)
;               (substring s (+ i 2) (string-length s))) ;; Remaining buffer
;             ;)
;            (else
;              (add! (substring s pos (string-length s)))
;              (loop (read-string *read-size* fp) 0)) )))
;        (else
;         (add! (substring s pos (string-length s)))
;         (loop (read-string *read-size* fp)
;               0))))))

;; Top-level parser
(define (parse filename)
 (let loop ((buf (make-buf (open-input-file filename))))
  (cond
    ;; EOF?
    ((eof-object? (buf:str buf))
     (close-port (buf:fp buf))
     ;(terminate!)
     (for-each display (reverse (buf:exprs buf)))
     (newline)
     (write 'DONE))
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

            ;; TODO: check next char (may require another read)
            (let ((c (buf:next-char buf 0)))
              (cond
              ;  ((eq? c #\#)
              ;   (set! inp (parse-string-comment! inp 1))
              ;   (loop buf))
              ;  ((eq? c #\{)
              ;   (set! inp (parse-expr! inp 1))
              ;   (loop buf))
                (else
                  (write "TODO: parse scheme expression")
                  (newline)
                  (exit 1)))))  ;; TODO: (loop buf)
          (else
            (buf:set-exprs! buf (cons (buf:str buf) (buf:exprs buf)))
            (buf:read-next-string! buf)
            (loop buf))))))))

(parse "view-2.html")
