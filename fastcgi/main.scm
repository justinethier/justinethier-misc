(import (scheme base)
        (scheme write)
        (srfi 18)
        (lib http)
        (lib fcgi))

;; TODO: how to get list of libraries in a sub-directory??
;; TODO: how to then import those libraries, either at compile time (ideal) or runtime??

(fcgx:init)
;; TODO: make this multithreaded based on the threaded.c example
(fcgx:loop 
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
