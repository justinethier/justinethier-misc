(import (scheme base)
        (scheme read)
        (scheme write)
        (scheme eval)
        (parser)
        )

(define env (create-environment '() '()))
(eval `(define row '("view-1.html" . "View 1")) env)
(eval `(define link car) env)
(eval `(define desc cdr) env)

;(parse "view-2.html")
;(parse "view-3.html")

(eval (cons 'begin (parse "view-4.html")) env)
;(write (cons 'begin (parse "view-4.html")))
