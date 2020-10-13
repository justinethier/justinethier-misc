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
(define fp (open-input-file "view-3.html"))
(define inp (read-string *read-size* fp))
(define exprs '())

(define (string-contains? str chr)
  (let loop ((i 0))
    (cond
     ((= i (string-length str))
      #f)
     ((equal? (string-ref str i) chr)
      i)
     (else
       (loop (+ i 1))))))

(define (parse)
  (cond
    ;; EOF?
    ((eof-object? inp)
     ;(terminate!)
     (for-each display (reverse exprs))
     (newline)
     (write 'DONE))

    ;; Does the string begin a scheme expression?
    ;; Will eventually need more sophisticated parsing but this works for now
    ((string-contains? inp #\{)
     (write "TODO: parse scheme expression")
     (newline)
     (exit 1))

    (else
      (set! exprs (cons inp exprs))
      (set! inp (read-string *read-size* fp))
      (parse))
))

(parse)
