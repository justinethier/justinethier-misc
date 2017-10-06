(import (scheme base)
        (scheme write)
        (scheme eval)
        (scheme read)
        (scheme file)
        (scheme cyclone libraries)
        (scheme cyclone util)
        (srfi 18)
        (lib dirent)
        (lib http)
        (lib fcgi))

;;;;
;;;; TODO: hacky code as we are trying to figure out the best way(s) to 
;;;; load controllers, deconstruct routes, and apply controller functions
;;;; for the given URL routes. Once the underlying problems are solved
;;;; this section should be cleaned up and proper error handling
;;;; should be added
;;;;

;(import (prefix (app controllers demo) demo:))
;(import (prefix (app controllers demo2) demo2:))
(define-syntax dyn-import
  (er-macro-transformer
    (lambda (expr rename compare)
      (define (load-controllers ctrl-files)
        (let ((ctrls '())
              (ctrl-funcs '()))
          (map
            (lambda (fname)
              (call-with-input-file (string-append "app/controllers/" fname) (lambda (fp)
                (let* ((lib (read fp))
                       (lib-name (lib:name lib))
                       (ctrl-name (car (reverse lib-name)))
                       (lib-exports (lib:exports lib)))
                  ;(display `(Loading ,lib-name))
                  ;(newline)
                  ;(eval `(import ,lib-name))
                  (set! ctrls (cons ctrl-name ctrls))
                  (set! ctrl-funcs (cons (cons ctrl-name lib-exports) ctrl-funcs))
                  `(prefix ,lib-name 
                           ,(string->symbol 
                              (string-append (symbol->string ctrl-name) ":")))
                  ))))
            ctrl-files)
          ))
      (eval `(import (lib dirent)))
      (cons 'import 
            (load-controllers
              (eval '(find-files "app/controllers/" ".sld"))))
      ;`(import (app controllers demo))
      )))
(dyn-import)

;; TODO: instead, can we dynamically import these as a program? that way we can prefix them.
;;       I guess could then just eval the functions directly?
(define (load-controllers)
  (let ((ctrl-files (find-files "app/controllers" ".sld"))
        (ctrls '())
        (ctrl-funcs '()))
    (for-each
      (lambda (fname)
        (call-with-input-file (string-append "app/controllers/" fname) (lambda (fp)
          (let* ((lib (read fp))
                 (lib-name (lib:name lib))
                 (ctrl-name (car (reverse lib-name)))
                 (lib-exports (lib:exports lib)))
            (display `(Loading ,lib-name))
            (newline)
            ;(eval `(import ,lib-name))
            (set! ctrls (cons ctrl-name ctrls))
            (set! ctrl-funcs (cons (cons ctrl-name lib-exports) ctrl-funcs))
            ))))
      ctrl-files)
    (display `(Controllers: ,ctrls))
    (newline)
    (display `(Controller functions: ,ctrl-funcs))
    (newline)
    (display (eval '(get:test)))
    (newline)
    ctrl-funcs))

(define (path-parts->action parts)
  (string->symbol (cadr parts))) ;; TODO: if none, then index

(define (route-to-controller url ctrl-lis) ;; TODO: request type
  (let* ((url-p (url-parse url))
         (path (url/p->path url url-p))
         (path-parts (string-split (string-append path "/") #\/))
         (ctrl-part (car path-parts))
         (ctrl (assoc (string->symbol ctrl-part) ctrl-lis))
        )
    (cond
      ((and ctrl
            (member (path-parts->action path-parts) (cdr ctrl)))
       ;(display (eval '
       (list `(controller ,ctrl-part) `(action ,(path-parts->action path-parts)))
       (let ((fnc (string->symbol
                    (string-append ctrl-part ":" (cadr path-parts)))))
        (display (list "running: " fnc))
        (newline)
      ;; TODO: doesn't work because renamed identifier is only available at compile time
      ;; and not in the global environment.
      ;; needs to be fixed in cyclone itself
        (display (eval `(,fnc))) ;; TODO: "id" args if present
        (newline)
      ))
      (else
        '404)) ;; TODO: redirect somehow
    ;(list path path-parts ctrl-part)
;    (cond
;      ((> (string-length ctrl-part) 4)
;       ;; TODO: allow subdirectories with something like (app controllers path1 path2 ctrl-name) ???
;       (let* ((ctrl-part-sym (string->symbol (substring ctrl-part 0 (- (string-length ctrl-part) 4))))
;              (ctrl (assoc ctrl-part-sym ctrl-lis)))
;        
;        )

;    (list ctrl-part ctrl ctrl-lis) ;; TODO

    ;; TODO: go from "test.cgi" to appropriate controller
    ;; TODO: get the request type, then should a prefix "get:" "post:" (if available) route to by req type
))

(let ((ctrl-lis (load-controllers)))
  (write (route-to-controller "http://10.0.0.4/demo/test" ctrl-lis))
  (newline)
  (write (route-to-controller "http://10.0.0.4/controller/action/id" ctrl-lis))
  (newline)
  (write (route-to-controller "http://localhost/demo.cgi" ctrl-lis))
  (newline)
)

(fcgx:init)
;; TODO: make this multithreaded based on the threaded.c example
;; TODO: make sure to include error handling via with-handler 
#;(fcgx:loop 
  (lambda (req)
    (parameterize ((current-output-port (open-output-string)))
      (display (http:make-header "text/html" 200))
      (display "Hello, world:")
      (display (fcgx:get-param req "REQUEST_URI" ""))
      (let* ((len-str (fcgx:get-param req "CONTENT_LENGTH" "0"))
             (len (string->number len-str))
             (len-num (if len len 0)))
        (display "<p>")
        (display (fcgx:get-string req len-num))
        (display "<p>"))
      (fcgx:print-request req (get-output-string (current-output-port))))))
