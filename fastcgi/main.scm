(import (scheme base)
        (scheme write)
        (scheme eval)
        (scheme read)
        (scheme file)
        (scheme cyclone libraries)
        (scheme cyclone util)
        (srfi 2)
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

;; Dynamically create an (import) statement for all the controllers
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

;; Generate a lookup table for all controller action functions
(define-syntax gen-ctrl-table
  (er-macro-transformer
    (lambda (expr rename compare)
      (define (import->string import)
        (foldr (lambda (id s)
                 (string-append "_" (mangle id) s))
               ""
               (lib:list->import-set import)))
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
                  (set! ctrls (cons ctrl-name ctrls))
                  (set! ctrl-funcs (cons (cons ctrl-name lib-exports) ctrl-funcs))
                  (cons 'list
                    (cons
                     `(quote ,ctrl-name)
                     (map
                      (lambda (export)
                        ;; TODO: create a table of:
                        ;; - index by lib, list of:
                        ;;   - (symbol . identifier)
                        ;;     EG: ('test . test)
                        (let ((sym (string->symbol (string-append (symbol->string ctrl-name) ":" (symbol->string export)))))
                          `(cons (quote ,sym) ,sym))
                        ;; this works too, but working with C makes this much harder
                        ;(string-append
                        ;  (mangle-global export)
                        ;  (import->string lib-name))
                      )
                      lib-exports)))
                  ))))
            ctrl-files)
          ))
      (eval `(import (lib dirent)))
      (list 'define '*ctrl-action-table*
        (cons 'list
              (load-controllers
                (eval '(find-files "app/controllers/" ".sld")))))
      )))
(gen-ctrl-table)

;; ctrl/action->function :: symbol -> symbol -> Maybe function boolean
;; Lookup function for given controller / action pair
(define (ctrl/action->function ctrl action)
  (and-let* ((ctrl-alis (assoc ctrl *ctrl-action-table*))
             (action-alis (assoc action (cdr ctrl-alis))))
    (cdr action-alis)))

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

(define (view-404)
  (display "404"))

(define (route-to-controller url) ;; TODO: request type
  (let* ((url-p (url-parse url))
         (path (url/p->path url url-p))
         (path-parts (string-split (string-append path "/") #\/))
         (ctrl-part (car path-parts))
         ;;(ctrl (assoc (string->symbol ctrl-part)))
        )
;    (cond
;      ((and ctrl
;            (member (path-parts->action path-parts) (cdr ctrl)))
       ;(display (eval '
       (list `(controller ,ctrl-part) `(action ,(path-parts->action path-parts)))
       (let ((fnc (string->symbol
                    (string-append ctrl-part ":" (cadr path-parts)))))
        (display (list "running: " fnc))
        (newline)
      ;; TODO: doesn't work because renamed identifier is only available at compile time
      ;; and not in the global environment.
      ;; needs to be fixed in cyclone itself
        ;(display (eval `(,fnc))) ;; TODO: "id" args if present
        (let ((fnc (ctrl/action->function 
                     (string->symbol ctrl-part)
                     (string->symbol (string-append ctrl-part ":" (cadr path-parts))))))
          (display `(DEBUG ,ctrl-part ,path-parts ,fnc))
          (if fnc
            (fnc) ;; TODO: id args
            (view-404)))
        (newline)
      ))
;      (else
;        (view-404))) ;; TODO: redirect somehow
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
)

;(let ((ctrl-lis (load-controllers)))
  (route-to-controller "http://10.0.0.4/demo/test" #;ctrl-lis)
  (newline)
  (route-to-controller "http://10.0.0.4/demo/get:test" #;ctrl-lis)
  (newline)
  (route-to-controller "http://10.0.0.4/controller/action/id" #;ctrl-lis)
  (newline)
  (route-to-controller "http://localhost/demo.cgi" #;ctrl-lis)
  (newline)
;)

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
