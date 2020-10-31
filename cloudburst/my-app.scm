;;
;; TODO: move all of the framework logic below into a library,
;;       figure out what actually needs to be in the main program

(import (scheme base)
        (scheme char)
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
        (prefix (lib request) req:)
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
                      (let* ((export-parts 
                               (string-split 
                                 (string-downcase 
                                   (symbol->string export))
                                 #\:))
                             (rest-indicator
                              (cond
                                ((<= (length export-parts) 1)
                                 #f)
                                ((member (car export-parts) '("get" "post" "put" "delete"))
                                 (car export-parts))
                                (else #f)))
                             (sym (string->symbol 
                                   (string-append 
                                     (symbol->string ctrl-name) ":" (symbol->string export)))))
;;TODO: also append REST request type, if a rest function
                        `(list (quote ,sym) ,sym ,rest-indicator)))
                    lib-exports)))
                ))))
          ctrl-files))
      (eval `(import (lib dirent)))
      (list 'define '*ctrl-action-table*
        (cons 'list
              (load-controllers
                (eval '(find-files "app/controllers/" ".sld"))))))))
(gen-ctrl-table)

;; ctrl/action->function :: string -> string -> string -> Maybe pair boolean
;; Lookup function for given controller / action pair
(define (ctrl/action->function ctrl action req-method)
  (and-let* (((not (rest-method? action)))
             (action-str action)
             (action-sym 
               (string->symbol
                 (string-append ctrl ":" action-str)))
             (rest-action-str
              (if (> (string-length req-method) 0)
                  (string-append req-method ":" action)
                  action))
             (rest-action-sym 
               (string->symbol
                 (string-append ctrl ":" rest-action-str)))
             (ctrl-sym (string->symbol ctrl))
             (ctrl-alis (assoc ctrl-sym *ctrl-action-table*)))
    (let ((action-alis (assoc action-sym (cdr ctrl-alis)))
          (rest-action-alis (assoc rest-action-sym (cdr ctrl-alis))))
      (cond
        (rest-action-alis (cons 'rest (cadr rest-action-alis)))
        (action-alis (cons 'html (cadr action-alis)))
        (else #f)))))

(define (path-parts->action parts)
  (string->symbol (cadr parts))) ;; TODO: if none, then index

(define (rest-method? action)
  (let ((parts (string-split (string-downcase action) #\:)))
    (and
      (> (length parts) 1)
      (member (car parts) '("get" "post" "put" "delete")))))

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
(define (route-to-controller url req-method)
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
      ;(let ((fnc (string->symbol
      ;             (string-append ctrl-part ":" (cadr path-parts)))))
      ; (log-notice (list "running: " fnc))
       (let ((type/fnc 
               (ctrl/action->function 
                 ctrl-part ;(string->symbol ctrl-part)
                 (cadr path-parts) ;(string->symbol (string-append ctrl-part ":" (cadr path-parts)))
                 (if (string? req-method)
                     (string-downcase req-method)
                     ""))))
         (log-notice `(DEBUG ,ctrl-part ,path-parts ,req-method ,type/fnc))
         (cond
          (type/fnc
           (display (http:make-header 
                      (if (equal? (car type/fnc) 'rest)
                          "application/json" 
                          "text/html")
                      200))
           (apply (cdr type/fnc) id-parts))
          (else
           (send-404-response)))))))

;; TODO: command-line interface to allow testing (maybe -t?) or just run as an
;;       FCGI service (default behavior)

;; TESTING
#;(begin
;  ;; No controller, do we provide a default one?
;  (route-to-controller "http://10.0.0.4/" "GET") (newline)
;  ;; No action, should have a means of default
;  (route-to-controller "http://10.0.0.4/demo" "GET") (newline)
;  (route-to-controller "http://10.0.0.4/demo/" "GET") (newline)
;  ;; ID arguments, should provide them. also should error if mismatched (too many/few for controller's action
  (route-to-controller "http://10.0.0.4/demo/test/1/2/3" "GET") (newline)
  (route-to-controller "http://10.0.0.4/demo/test2/arg1/arg2" "GET") (newline)
  (route-to-controller "http://10.0.0.4/demo/status" "GET") (newline)
  (route-to-controller "http://10.0.0.4/demo2/test" "GET") (newline)
  (route-to-controller "http://10.0.0.4/controller/action/id" "GET") (newline)
  (route-to-controller "http://localhost/demo.cgi" "GET") (newline)

  (exit 0)
) ;; END


(fcgx:init)
;; TODO: initiate minor GC to ensure no thread-local data??
;; TODO: make this multithreaded based on the threaded.c example
;; TODO: make sure to include error handling via with-handler 

(define (main-handler)
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
          (let ((uri (fcgx:get-param req "REQUEST_URI" ""))
                (req-method (fcgx:get-param req "REQUEST_METHOD" "GET")))
            (route-to-controller uri req-method))
          (fcgx:print-request req (get-output-string (current-output-port))))))))

;          (display (http:make-header "text/html" 200))
;;          ;(display "Hello, world:")
;;          (display `(DEBUG1 ,(Cyc-opaque? req) ,req))
;;          (display `(DEBUG2 ,(Cyc-opaque? (thread-specific (current-thread))) ,(thread-specific (current-thread))))
;
;;;TODO: create a new (lib fcgi ???) to make it easier to get params, etc
;;;write such that the API expects to be user-facing
;
;          (display (req:method)) ;(fcgx:get-param req "REQUEST_METHOD" "GET"))
;          (display (req:body))
;          (display (req:content-type))
;          ; TODO: example of getting POST (put, delete??) params, will need later
;          ;(let* ((len-str (fcgx:get-param req "CONTENT_LENGTH" "0"))
;          ;       (len (string->number len-str))
;          ;       (len-num (if len len 0)))
;          ;  (display "<p>") ;; TODO: function like "(htm:p)" to make this easier???
;          ;  (display (fcgx:get-string req len-num))
;          ;  (display "<p>"))
;          (fcgx:print-request req (get-output-string (current-output-port))))))))

;; TODO: make number of thread configurable?
(let loop ((i 20))
  (thread-start! (make-thread main-handler))
  (if (> i 1)
      (loop (- i 1))))
(main-handler)
