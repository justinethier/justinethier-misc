(import (scheme base)
        (parser)
        (template)
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

(render "view-4.html" args)
(render "view-4.html" '((row . '("view-2.html" . "View 2"))
                        (link . car)
                        (desc . cdr)))
