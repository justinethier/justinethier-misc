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
(define fp (open-input-file "view-4.html"))
(define inp (read-string *read-size* fp))
(define exprs '())

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

;; Return next char from input, starting at position `pos`.
;; Will read more from input stream if necessary
(define (next-char str pos)
  (cond
    ((< (+ 1 pos) (string-length str))
     (string-ref str (+ pos 1)))
    (else
     (set! str (string-append str (read-string *read-size* fp)))
     (next-char str 0)
     )))

;; Parse out data for a scheme template comment
;; Basically reads and discards the whole comment.
(define (parse-string-comment! str start)
  (let loop ((s str)
             (pos start))
    (let ((i (string-pos s #\# pos)))
(write `(loop ,i ,s))(newline)
      (cond
        (i
         (let ((c (next-char s i)))
(write `(DEBUG c ,c ,s ,pos))
           (cond
            ((eq? c #\})
             ;; Start buffer from end of comment
             (substring s (+ i 2) (string-length s)))
            (else
              (loop (read-string *read-size* fp) 0)) )))
        (else
         (loop (read-string *read-size* fp)
               0))))))

(define (parse-expr! str start)
  (define expr "")
  (define (add! str)
    (set! expr (string-append expr str)))

  (let loop ((s str)
             (pos start))
    (let ((i (string-pos s #\} pos)))
(write `(loop ,i ,s))(newline)
      (cond
        (i
         (let ((c (next-char s i)))
(write `(DEBUG c ,c ,s ,pos))
           (cond
            ((eq? c #\})
             ;; Return expression and remaining buffer
             (if (> (- i 2) pos)
                 (add! (substring s pos (string-length s))))
             ;(values
             ;  expr ;; Scheme expression (as string)
               (substring s (+ i 2) (string-length s))) ;; Remaining buffer
             ;)
            (else
              (add! (substring s pos (string-length s)))
              (loop (read-string *read-size* fp) 0)) )))
        (else
         (add! (substring s pos (string-length s)))
         (loop (read-string *read-size* fp)
               0))))))

;; Top-level parser
(define (parse)
  (cond
    ;; EOF?
    ((eof-object? inp)
     ;(terminate!)
     (for-each display (reverse exprs))
     (newline)
     (write 'DONE))
    (else

      ;; Does the string begin a scheme expression?
      ;; Will eventually need more sophisticated parsing but this works for now
      (let ((spos (string-pos inp #\{ 0)))
        (cond
          (spos
            ;; Include any chars already read, and clear from inp buffer
            (set! exprs (cons (substring inp 0 spos) exprs))
            (set! inp (substring inp spos (string-length inp)))

            ;; TODO: check next char (may require another read)
            (let ((c (next-char inp 0)))
              (cond
                ((eq? c #\#)
                 (set! inp (parse-string-comment! inp 1))
                 (parse))
                ((eq? c #\{)
                 (set! inp (parse-expr! inp 1))
                 (parse))
                (else
                  (write "TODO: parse scheme expression")
                  (newline)
                  (exit 1)))))  ;; TODO: (parse)
          (else
            (set! exprs (cons inp exprs))
            (set! inp (read-string *read-size* fp))
            (parse)))))))

(parse)
