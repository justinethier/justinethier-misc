;; A temporary test file, move this to a library with a corresponding unit test program
;; Compare with spec from json.org
(import (scheme base) (scheme write))

(define (json-scalar? expr)
  (or (boolean? expr)
      (null? expr)
      (number? expr)
      (string? expr)
      (symbol? expr)))

(define (->json expr)
  (cond
    ((eq? expr #t) (display "true"))
    ((eq? expr #f) (display "false"))
    ((eq? expr '()) (display "null"))
    ((number? expr) (display expr)) ;; TODO: good enough???
    ((string? expr) (write expr)) ;; TODO: not good enough
    ((symbol? expr) (->json (symbol->string expr)))
    ((list? expr)
     (cond
      ((every
         (lambda (e)
           (and (pair? e)
                (json-scalar? (car e))))
         expr)
       'TODO)
       ;; TODO: create a list where car is key and cdr is value
       ;; TODO: ensure car is wrapped into a string
       ;; TODO: if cdr is a list, make it into an array
      (else
       'TODO)) ;; Just convert as an array
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
(newline)
(->json '(1 2 3 4)) (newline)
(->json '((a . 1) (b . 2) (c . 3) (d . 4))) (newline)
(->json '((a 1) (b 2) (c 3) (d 4))) (newline)
