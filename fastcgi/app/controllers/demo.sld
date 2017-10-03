(define-library (app controllers demo)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
  )
  (export
    get:status
    get:test
    get:test2
  )
  (begin
    (define (get:status)
      (display (status-ok)))
    (define (get:test)
      (display "demo : test"))
    (define (get:test2 arg1 arg2)
      (display "demo : test")
      (display ": ")
      (display arg1)
      (display ": ")
      (display arg2))
  ))
