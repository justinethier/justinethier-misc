(import (scheme base)
        (srfi 18)
        (lib http)
        (lib fcgi))

(fcgx:init)
;; TODO: make this multithreaded based on the threaded.c example
(fcgx:loop 
  (lambda (req)
    (fcgx:print-request req (http:make-header "text/html" 200))
    (fcgx:print-request req "Hello, world:")
    (fcgx:print-request req (fcgx:get-param req "REQUEST_URI" ""))
    (let* ((len-str (fcgx:get-param req "CONTENT_LENGTH" "0"))
           (len (string->number len-str))
           (len-num (if len len 0)))
      (fcgx:print-request req "<p>")
      (fcgx:print-request req (fcgx:get-string req len-num))
      (fcgx:print-request req "<p>")
      )))
