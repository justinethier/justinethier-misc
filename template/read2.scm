(import (scheme base)
        (scheme read)
        (scheme repl)
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


(define (render view args)
  (let ((env (cond-expand
               (cyclone (create-environment '() '()))
               (else (interaction-environment))))
        (view-sexpr (parse view)) ;; TODO: read from cache if we can
       )
    (for-each
      (lambda (arg)
        ;(write `(define ,(car arg) ,(cdr arg))) (newline) ;; Debug
        (eval `(define ,(car arg) ,(cdr arg)) env)
      )
      args)

    (eval (cons 'begin view-sexpr) env)))


(define args '((row . (cons "view-1.html" "View 1"))
               (link . car)
               (desc . cdr)))

(render "view-4.html" args)
