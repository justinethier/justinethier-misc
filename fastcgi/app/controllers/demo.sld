(define-library (app controllers demo)
  (import 
    (scheme base)
  )
  (export
    get:test
    get:test2
  )
  (begin
    (define (get:test)
      (display "demo : test"))
    (define (get:test2 arg1 arg2)
      (display "demo : test")
      (display ": ")
      (display arg1)
      (display ": ")
      (display arg2))
  ))
