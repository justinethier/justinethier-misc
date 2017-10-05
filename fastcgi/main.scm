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
            (eval `(import ,lib-name))
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

(define (route-to-controller url ctrl-lis) ;; TODO: request type
  (let* ((url-p (url-parse url))
         (path (url/p->path url url-p))
         (path-parts (string-split (string-append path "/") #\/))
         (ctrl-part (car path-parts))
        )

    ctrl-part
    #;(cond
      ((> 4 (string-length ctrl-part))
       (let ((ctrl-part-sym (string->symbol (substring ctrl-part (- (string-length ctrl-part) 4)  (string-length ctrl-part)))))
        ctrl-part-sym)))
;         TODO: remove .cgi
;         (ctrl (assoc ctrl-part ctrl-lis))
;        )
;
;    (list ctrl-part ctrl ctrl-lis) ;; TODO

    ;; TODO: go from "test.cgi" to appropriate controller
    ;; TODO: get the request type, then should a prefix "get:" "post:" (if available) route to by req type
))

(let ((ctrl-lis (load-controllers)))
  (write (route-to-controller "http://localhost/test.cgi" ctrl-lis)))

#;(fcgx:init)
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
