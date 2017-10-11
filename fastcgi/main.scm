;; TODO: Swirl MVC Framework ??
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

;; Dynamically create an (import) statement for all the controllers
(define-syntax dyn-import
  (er-macro-transformer
    (lambda (expr rename compare)
      (define (load-controllers ctrl-files)
        (map
          (lambda (fname)
            (call-with-input-file (string-append "app/controllers/" fname) (lambda (fp)
              (let* ((lib (read fp))
                     (lib-name (lib:name lib))
                     (ctrl-name (car (reverse lib-name)))
                     (lib-exports (lib:exports lib)))
                ;(display `(Loading ,lib-name))
                ;(newline)
                ;(set! ctrls (cons ctrl-name ctrls))
                ;(set! ctrl-funcs (cons (cons ctrl-name lib-exports) ctrl-funcs))
                `(prefix ,lib-name 
                         ,(string->symbol 
                            (string-append (symbol->string ctrl-name) ":")))
                ))))
          ctrl-files))
      (eval `(import (lib dirent)))
      (cons 'import 
            (load-controllers
              (eval '(find-files "app/controllers/" ".sld")))))))
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
        (map
          (lambda (fname)
            (call-with-input-file (string-append "app/controllers/" fname) (lambda (fp)
              (let* ((lib (read fp))
                     (lib-name (lib:name lib))
                     (ctrl-name (car (reverse lib-name)))
                     (lib-exports (lib:exports lib)))
                (cons 'list
                  (cons
                   `(quote ,ctrl-name)
                   (map
                    (lambda (export)
                      (let ((sym (string->symbol 
                                   (string-append 
                                     (symbol->string ctrl-name) ":" (symbol->string export)))))
                        `(cons (quote ,sym) ,sym)))
                    lib-exports)))
                ))))
          ctrl-files))
      (eval `(import (lib dirent)))
      (list 'define '*ctrl-action-table*
        (cons 'list
              (load-controllers
                (eval '(find-files "app/controllers/" ".sld"))))))))
(gen-ctrl-table)

;; ctrl/action->function :: symbol -> symbol -> Maybe function boolean
;; Lookup function for given controller / action pair
(define (ctrl/action->function ctrl action)
  (and-let* ((ctrl-alis (assoc ctrl *ctrl-action-table*))
             (action-alis (assoc action (cdr ctrl-alis))))
    (cdr action-alis)))

(define (path-parts->action parts)
  (string->symbol (cadr parts))) ;; TODO: if none, then index

(define (log-error msg . err)
  (let ((fp (current-error-port)))
    (display msg fp)
    (newline fp)
    (if (not (null? err))
        (display err fp))
    (newline fp)))

(define log-notice log-error)

(define (send-error-response msg)
  (display (http:make-header "text/html" 500))
  (display msg))

(define (send-404-response)
  (display (http:make-header "text/html" 404))
  (display "Not found."))

;; TODO: parse out id arguments and pass them along, if available
;; TODO: get the request type, then should a prefix "get:" "post:" (if available) route to by req type
(define (route-to-controller url) ;; TODO: request type
  (with-handler
    (lambda (err)
      (log-error (string-append "Error calling route-to-controller for " url ":") err)
      (send-error-response "An error occurred"))
    (let* ((url-p (url-parse url))
           (path (url/p->path url url-p))
           (path-parts (filter 
                         (lambda (str) (> (string-length str) 0))
                         (string-split (string-append path "/") #\/)))
           (ctrl-part (car path-parts))
           (id-parts (if (> (length path-parts) 2)
                         (cddr path-parts)
                         '()))
          )
      (log-notice 
        (list `(controller ,ctrl-part) 
              `(action ,(path-parts->action path-parts))
              `(args ,id-parts)
              `(len args ,(length id-parts))
              ))
      (let ((fnc (string->symbol
                   (string-append ctrl-part ":" (cadr path-parts)))))
       (log-notice (list "running: " fnc))
       (let ((fnc (ctrl/action->function 
                    (string->symbol ctrl-part)
                    (string->symbol (string-append ctrl-part ":" (cadr path-parts))))))
         (log-notice `(DEBUG ,ctrl-part ,path-parts ,fnc))
         (cond
          (fnc
           (display (http:make-header "text/html" 200))
           (apply fnc id-parts))
          (else
           (send-404-response))))))))

;; TODO: command-line interface to allow testing (maybe -t?) or just run as an
;;       FCGI service (default behavior)

;; TESTING
#;(begin
  ;; No controller, do we provide a default one?
  (route-to-controller "http://10.0.0.4/" #;ctrl-lis) (newline)
  ;; No action, should have a means of default
  (route-to-controller "http://10.0.0.4/demo" #;ctrl-lis) (newline)
  (route-to-controller "http://10.0.0.4/demo/" #;ctrl-lis) (newline)
  ;; ID arguments, should provide them. also should error if mismatched (too many/few for controller's action
  (route-to-controller "http://10.0.0.4/demo/test/1/2/3" #;ctrl-lis) (newline)
  (route-to-controller "http://10.0.0.4/demo/get:test2/arg1/arg2" #;ctrl-lis) (newline)
  (route-to-controller "http://10.0.0.4/demo/get:test/arg1/" #;ctrl-lis) (newline)
  (route-to-controller "http://10.0.0.4/demo2/test" #;ctrl-lis) (newline)
  (route-to-controller "http://10.0.0.4/demo2/get:test" #;ctrl-lis) (newline)
  (route-to-controller "http://10.0.0.4/controller/action/id" #;ctrl-lis) (newline)
  (route-to-controller "http://localhost/demo.cgi" #;ctrl-lis) (newline)
) ;; END

(fcgx:init)
;; TODO: initiate minor GC to ensure no thread-local data
;; TODO: make this multithreaded based on the threaded.c example
;; TODO: make sure to include error handling via with-handler 
(fcgx:loop 
  (lambda (req)
    ;; TODO: need to fix dynamic-wind to guarantee after section is called, otherwise
    ;; what happens if error is called by a controller? may be able to get around it
    ;; by having a with-handler though to catch any exceptions
    (parameterize ((current-output-port (open-output-string)))
      (with-handler
        (lambda (err)
          (log-error (string-append "Error in fcgx:loop: ") err)
          (send-error-response "Internal error"))
        (let ((uri (fcgx:get-param req "REQUEST_URI" "")))
          (route-to-controller uri))
        ;(display (http:make-header "text/html" 200))
        ;(display "Hello, world:")
        ;(display (fcgx:get-param req "REQUEST_URI" ""))
        ;; TODO: example of getting POST (put, delete??) params, will need later
        ;(let* ((len-str (fcgx:get-param req "CONTENT_LENGTH" "0"))
        ;       (len (string->number len-str))
        ;       (len-num (if len len 0)))
        ;  (display "<p>") ;; TODO: function like "(htm:p)" to make this easier???
        ;  (display (fcgx:get-string req len-num))
        ;  (display "<p>"))
        (fcgx:print-request req (get-output-string (current-output-port)))))))
