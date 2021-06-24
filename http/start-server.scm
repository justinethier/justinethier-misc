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

(c-define http-response-status c-void "http_response_status" opaque int)
(c-define http-response-header c-void "http_response_header" opaque string string)

(define-c http-response-body
  "(void *data, int argc, closure _, object k, object opq, object body)"
  " Cyc_check_opaque(data, opq);
    Cyc_check_str(data, body);
    http_response_body(opaque_ptr(opq), string_str(body), string_num_cp(body));
    return_closcall1(data, k, boolean_t);
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

(server-init 8081)
(let loop ()
  ;; let http thread wake us up when it receives a request
  (mutex-lock! lock)
  (mutex-unlock! lock cv)

  (write `(TODO: process request/response in scm))
  (newline)
  (http-response-status resp 200)
  (http-response-header resp "Content-Type" "text/plain")
  (http-response-body resp "Hello World from SCM")

  ;; broadcast back to http thread that response is ready
  (condition-variable-broadcast! cv)
  (write `(iterate loop))
  (newline)
  (loop))

