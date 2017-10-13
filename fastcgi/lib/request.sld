(define-library (lib request)
  (import 
    (scheme base)
    (scheme cyclone util)
    (srfi 18)
    (lib fcgi)
  )
  (export
    method
    params
  )
  (begin
    (define (req-obj)
      (thread-specific (current-thread)))

    ;; method :: string
    ;; Get the HTTP request method for the current request
    (define (method)
      (let ((req (req-obj)))
        (fcgx:get-param req "REQUEST_METHOD" "GET")))

    ;; params :: [string]
    ;; Get parameters for the current request
    (define (params)
      'TODO)
  ))
