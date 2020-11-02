(define-library (app controllers demo2)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
    (cyclone web temple)
  )
  (export
    test
    get:status
    get:test2
  )
  (begin
    (define (view)
      (render
        "views/view-1.html"
        '((rows . '(
                    ("view-1.html" . "View 1")
                    ("view-2.html" . "View 2")
                    ("view-3.html" . "View 3")
                   ))
          (link . car)
          (desc . cdr)))
    )
    (define (test)
      (display "demo 2 test"))
    (define (get:status)
      (display (status-ok)))
    (define (get:test2 arg1 arg2)
      (display "demo2 : test")
      (display ": ")
      (display arg1)
      (display ": ")
      (display arg2))
  ))
