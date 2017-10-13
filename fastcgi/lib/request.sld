(define-library (lib request)
  (import 
    (scheme base)
    (scheme cyclone util)
    (srfi 18)
    (lib fcgi)
  )
  (export
    method
    body
    content-type
  )
  (begin
    (define (req-obj)
      (thread-specific (current-thread)))

    ;; method :: string
    ;; Get the HTTP request method for the current request
    (define (method)
      (let ((req (req-obj)))
        (fcgx:get-param req "REQUEST_METHOD" "GET")))

    (define (content-type)
      (let ((req (req-obj)))
        (fcgx:get-param req "CONTENT_TYPE" "GET")))

    ;; params :: [string]
    ;; Get parameters for the current request
    (define (body)
      (let* ((req (req-obj))
             (len-str (fcgx:get-param req "CONTENT_LENGTH" "0"))
             (len (string->number len-str))
             (len-num (if len len 0)))
        (fcgx:get-string req len-num)))
  ))
