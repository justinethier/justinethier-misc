(define-library (http-server)
  (import 
    (scheme base)
    (scheme write)
    (cyclone foreign)
    (srfi 18)
  )
  (include-c-header "start-server.h")
  (export
    make-http-server
    http-request?
    http-request-body
    http-request-header
    http-request-headers
    http-response-body
    http-response-header
    http-response-status
  )
  (begin

(define-c server-init
  "(void *data, int argc, closure _, object k, object port)"
  " Cyc_check_fixnum(data, port);
    start_thread(port);
    return_closcall1(data, k, boolean_t);
  ")

(c-define %http-request? int "request_target_is" opaque string)
(define (http-request? request target)
  (not (zero? (%http-request? request target))))

(c-define http-response-status c-void "http_response_status" opaque int)
(c-define http-response-header c-void "http_response_header" opaque string string)

(define-c http-response-body
  "(void *data, int argc, closure _, object k, object opq, object body)"
  " Cyc_check_opaque(data, opq);

    if (Cyc_is_string(body) == boolean_t) {
      http_response_body(opaque_ptr(opq), string_str(body), string_num_cp(body));
    } else if (Cyc_is_bytevector(body) == boolean_t) {
      bytevector_type *bv = body;
      http_response_body(opaque_ptr(opq), bv->data, bv->len);
    } else {
      Cyc_invalid_type_error(data, string_tag, body);
    }
    return_closcall1(data, k, boolean_t);
  ")

(define-c http-request-body
  "(void *data, int argc, closure _, object k, object opq)"
  " Cyc_check_opaque(data, opq);
    struct http_request_s *request = opaque_ptr(opq);
    http_string_t body = http_request_body(request);
    make_empty_bytevector(bv);
    bv.data = (char *)body.buf;
    bv.len = body.len;
    return_closcall1(data, k, &bv);
  ")

(define-c http-request-header
  "(void *data, int argc, closure _, object k, object opq, object key)"
  " Cyc_check_opaque(data, opq);
    Cyc_check_str(data, key);
    struct http_request_s *request = opaque_ptr(opq);
    http_string_t header = http_request_header(request, string_str(key));
    make_empty_bytevector(bv);
    bv.data = (char *)header.buf;
    bv.len = header.len;
    return_closcall1(data, k, &bv);
  ")

(define-c http-request-headers
  "(void *data, int argc, closure _, object k, object opq)"
  " Cyc_check_opaque(data, opq);
    struct http_request_s *request = opaque_ptr(opq);

    int iter = 0, i = 0;
    http_string_t key, val;
    char buf[1024];
    while (http_request_iterate_headers(request, &key, &val, &iter)) {
      i += snprintf(buf + i, 1024 - i, \"%.*s: %.*s\\n\", key.len, key.buf, val.len, val.buf);
    }

    make_utf8_string(data, str, buf);
    return_closcall1(data, k, &str);
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
  )
)
