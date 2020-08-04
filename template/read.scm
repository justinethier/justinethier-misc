(import (scheme base)
        (scheme read)
        (scheme write)
        )

;(define (read-until fp 
(let loop ((fp (open-input-file "view-1.html"))
           (buf (read-string 2 fp)) ;; TODO: read more after debugging
           (lines '()))
  (cond
    ((eof-object? buf)
     (reverse lines))
    (else 
     (loop fp (read-string 2 fp) (cons buf lines)))))
