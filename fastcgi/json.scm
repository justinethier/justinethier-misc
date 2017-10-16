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
    ((vector? expr)
     (display "[")
     ;; TODO: display vector contents
     (display "]"))
    (else (error "Unknown expression" expr))
))


(->json 1)
(->json "test")
(->json #t)
(->json '())
(->json #(1 2 3 4))
