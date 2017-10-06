(define-library (app controllers demo2)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
  )
  (export
    test
    get:status
    get:test
    get:test2
  )
  (begin
    (define (test)
      (display "demo 2 test"))
    (define (get:status)
      (display (status-ok)))
    (define (get:test)
      (display "demo2 : test"))
    (define (get:test2 arg1 arg2)
      (display "demo2 : test")
      (display ": ")
      (display arg1)
      (display ": ")
      (display arg2))
  ))
