(import 
    (scheme base)
    (scheme write)
    (cyclone foreign)
    (srfi 18)
)

(include-c-header "start-server.h")

(define-c server-init
  "(void *data, int argc, closure _, object k, object port)"
  " Cyc_check_fixnum(data, port);
    start_thread(port);
    return_closcall1(data, k, boolean_t);
  ")

(c-define http-request? int "request_target_is" opaque string)
(c-define http-response-status c-void "http_response_status" opaque int)
(c-define http-response-header c-void "http_response_header" opaque string string)

(define-c http-response-body
  "(void *data, int argc, closure _, object k, object opq, object body)"
  " Cyc_check_opaque(data, opq);

    if (Cyc_is_string(body)) {
      http_response_body(opaque_ptr(opq), string_str(body), string_num_cp(body));
    } else if (Cyc_is_bytevector(body)) {
      bytevector_type *bv = body;
      http_response_body(opaque_ptr(opq), bv->data, bv->len);
    } else {
      // TODO: raise type error
    }
    return_closcall1(data, k, boolean_t);
  ")

(define-c http-request-body
  "(void *data, int argc, closure _, object k, object opq)"
  " Cyc_check_opaque(data, opq);
    struct http_request_s *request = opaque_ptr(opq);
    http_string_t body = http_request_body(request);
    make_empty_bytevector(bv);
    bv.data = body.buf;
    bv.len = body.len;
    return_closcall1(data, k, &bv);
  ")

(define-c make-c-opaque
  "(void *data, int argc, closure _, object k)"
  " make_c_opaque(opq, NULL);
    return_closcall1(data, k, &opq);
  ")

(define lock (make-mutex))
(define cv (make-condition-variable))

(define req (make-c-opaque))
(define resp (make-c-opaque))

(define (make-http-server port handle-request)
  (server-init port)
  (let loop ()
    ;; let http thread wake us up when it receives a request
    (mutex-lock! lock)
    (mutex-unlock! lock cv)

    (handle-request req resp)

    ;; broadcast back to http thread that response is ready
    (condition-variable-broadcast! cv)
    (write `(iterate loop))
    (newline)
    (loop)))

(make-http-server 
  8080
  (lambda (request response)
    (cond
      ((http-request? "/echo")
       (let ((body (http-request-body req)))
         (http-response-header resp "Content-Type" "text/plain")
         (http-response-body resp body)))
      (else
        (http-response-status resp 200)
        (http-response-header resp "Content-Type" "text/plain")
        (http-response-body resp "Hello World from SCM")))))

