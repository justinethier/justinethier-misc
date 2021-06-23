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
    // TODO: pass port

    start_thread();
    return_closcall1(data, k, boolean_t);
  ")

(define-c http-response-status
  "(void *data, int argc, closure _, object k, object opq, object status)"
  " Cyc_check_opaque(data, opq);
    Cyc_check_fixnum(data, status);
    http_response_status(opaque_ptr(opq), obj_obj2int(status));
    return_closcall1(data, k, boolean_t);
  ")

(define-c http-response-header
  "(void *data, int argc, closure _, object k, object opq, object key, object value)"
  " Cyc_check_opaque(data, opq);
    Cyc_check_str(data, key);
    Cyc_check_str(data, value);
    http_response_header(opaque_ptr(opq), string_str(key), string_str(value));
    return_closcall1(data, k, boolean_t);
  ")

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

;; TODO: http req/resp data
;; TODO: (define (handle-request ...))

(server-init 0)
(let loop ()
  ;; let http thread wake us up when it receives a request
  (mutex-lock! lock)
  (mutex-unlock! lock cv)

  ;; TODO: receive request/empty-response
  ;; TODO: formulate response
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

