(import (scheme base)
        (scheme read)
        (scheme write)
        (scheme eval)
        (parser)
        )

;; TODO:

;; Page record type:
;;  filename
;;  last loaded time (?)
;;  cached expressions

;; Render (filename, args)
;;  load args into new env
;;  find page
;;   not found, load from disk and cache
;;   found, eval cached expressions

;; Use cond-expand to try to keep code standard
;;    track file timestamp and reload if necessary,
;;    but this will be cyclone-only.
;;   Otherwise cache forever, I guess. Or time out if no access in X seconds

;; TODO: new module to encapsulate view 

;; TODO: low-level render ??

;; TODO: (define (add-arg!) ????

(define args '((row . (cons "view-1.html" "View 1"))
               (link . car)
               (desc . cdr)))

(define env (create-environment '() '()))

(for-each
  (lambda (arg)
    (write `(define ,(car arg) ,(cdr arg)))
    (newline)
    (eval `(define ,(car arg) ,(cdr arg)) env)
  )
  args)

;(eval `(define row '("view-1.html" . "View 1")) env)
;(eval `(define link car) env)
;(eval `(define desc cdr) env)

;(parse "view-2.html")
;(parse "view-3.html")


(eval (cons 'begin (parse "view-4.html")) env)
;(write (cons 'begin (parse "view-4.html")))

