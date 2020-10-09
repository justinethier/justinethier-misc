(import (scheme base)
        (scheme write)
        )

(define buf "")
(define fp (open-input-file "view-1.html"))
(define inp (read-string 2 fp))
(define i 0)
(define (check)
  (cond
    ;; EOF?
    ((eof-object? inp)
     (display buf))

    ((= i (string-length buf))
     (set! buf (string-append buf inp))
     (set! inp (read-string 2 fp))
     (set! i 0))

    ;; TODO: check char

))


(check)
