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
    (http-response-status resp 200)
    (cond
      ((http-request? req "/echo")
       (let ((body (http-request-body req)))
         (http-response-header resp "Content-Type" "text/plain")
         (http-response-body resp body)))
      ((http-request? req "/host")
       (let ((body (http-request-header req "Host")))
         (http-response-header resp "Content-Type" "text/plain")
         (http-response-body resp body)))
      ((http-request? req "/empty")
       ;; No Body
      )
;;  } else if (request_target_is(request, "/chunked")) {
;;    http_response_header(response, "Content-Type", "text/plain");
;;    http_response_body(response, RESPONSE, sizeof(RESPONSE) - 1);
;;    http_respond_chunk(request, response, chunk_cb);
;;    return;
;;  } else if (request_target_is(request, "/chunked-req")) {
;;    chunk_buf_t* chunk_buffer = (chunk_buf_t*)calloc(1, sizeof(chunk_buf_t));
;;    chunk_buffer->buf = (char*)malloc(512 * 1024);
;;    chunk_buffer->response = response;
;;    http_request_set_userdata(request, chunk_buffer);
;;    http_request_read_chunk(request, chunk_req_cb);
;;    return;
;;  } else if (request_target_is(request, "/large")) {
;;    chunk_buf_t* chunk_buffer = (chunk_buf_t*)calloc(1, sizeof(chunk_buf_t));
;;    chunk_buffer->buf = (char*)malloc(25165824);
;;    chunk_buffer->response = response;
;;    http_request_set_userdata(request, chunk_buffer);
;;    http_request_read_chunk(request, chunk_req_cb);
;;    return;
;;  } else if (request_target_is(request, "/headers")) {
;;    int iter = 0, i = 0;
;;    http_string_t key, val;
;;    char buf[512];
;;    while (http_request_iterate_headers(request, &key, &val, &iter)) {
;;      i += snprintf(buf + i, 512 - i, "%.*s: %.*s\n", key.len, key.buf, val.len, val.buf);
;;    }
;;    http_response_header(response, "Content-Type", "text/plain");
;;    http_response_body(response, buf, i);
;;    return http_respond(request, response);
      (else
        (http-response-header resp "Content-Type" "text/plain")
        (http-response-body resp "Hello World from SCM")))))

