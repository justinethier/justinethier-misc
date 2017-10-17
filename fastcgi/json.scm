;; A temporary test file, move this to a library with a corresponding unit test program
;; Compare with spec from json.org
(import (scheme base) (scheme write))

(define (->json expr)
  (cond
    ((eq? expr #t) (display "true"))
    ((eq? expr #f) (display "false"))
    ((eq? expr '()) (display "null"))
    ((number? expr) (display expr)) ;; TODO: not good enough??
    ((string? expr) (write expr)) ;; TODO: not good enough
    ((list? expr)
     ;; TODO: treat alists differently??
     'TODO
    )
    ((vector? expr)
     (display "[ ")
     (let loop ((i 0)
                (count (vector-length expr)))
      (when (> count i)
        (->json (vector-ref expr i))
        (display " ")
        (loop (+ i 1) count)))
     (display "]"))
    ((bytevector? expr)
     (display "[ ")
     (let loop ((i 0)
                (count (bytevector-length expr)))
      (when (> count i)
        (->json (bytevector-u8-ref expr i))
        (display " ")
        (loop (+ i 1) count)))
     (display "]"))
    ;; TODO: hash table?
    (else (error "Unknown expression" expr)) ;; TODO: or  just a string representation?
))


(->json 1)
(->json "test")
(->json #t)
(->json '())
(->json #(1 2 3 4))
(->json #u8(1 2 3 444))
