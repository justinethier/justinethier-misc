(import
  (http-server)
  (scheme base)
)

(make-http-server 
  8080
  (lambda (req resp)
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
      ((http-request? req "/headers")
       (let ((hdrs (http-request-headers req)))
         (http-response-header resp "Content-Type" "text/plain")
         (http-response-body resp hdrs)))
      (else
        (http-response-header resp "Content-Type" "text/plain")
        (http-response-body resp "Hello World from SCM")))))
