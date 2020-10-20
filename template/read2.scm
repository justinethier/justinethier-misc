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

;; TODO: caching ability for views?
;;    would want to record file timestamp and reload if necessary
;; TODO: new module to encapsulate view 
