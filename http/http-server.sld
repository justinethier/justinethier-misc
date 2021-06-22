(define-library (http-server)
  (import 
    (scheme base)
    ;(scheme write)
    ;(cyclone foreign)
  )
  (include-c-header "config.h")
  (include-c-header "httpserver.h")
  (export
    http-server-listen
  )
  (begin
    (define (http-server-listen)
      'todo)
  )
)
