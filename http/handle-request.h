#define RESPONSE "Hello, World!"
void handle_request(struct http_request_s* request) {
//  chunk_count = 0;
  http_request_connection(request, HTTP_AUTOMATIC);
  struct http_response_s* response = http_response_init();
  http_response_status(response, 200);
//  if (request_target_is(request, "/echo")) {
//    http_string_t body = http_request_body(request);
//    http_response_header(response, "Content-Type", "text/plain");
//    http_response_body(response, body.buf, body.len);
//  } else if (request_target_is(request, "/host")) {
//    http_string_t ua = http_request_header(request, "Host");
//    http_response_header(response, "Content-Type", "text/plain");
//    http_response_body(response, ua.buf, ua.len);
//  } else if (request_target_is(request, "/poll")) {
//    while (http_server_poll(poll_server) > 0);
//    http_response_header(response, "Content-Type", "text/plain");
//    http_response_body(response, RESPONSE, sizeof(RESPONSE) - 1);
//  } else if (request_target_is(request, "/empty")) {
//    // No Body
//  } else if (request_target_is(request, "/chunked")) {
//    http_response_header(response, "Content-Type", "text/plain");
//    http_response_body(response, RESPONSE, sizeof(RESPONSE) - 1);
//    http_respond_chunk(request, response, chunk_cb);
//    return;
//  } else if (request_target_is(request, "/chunked-req")) {
//    chunk_buf_t* chunk_buffer = (chunk_buf_t*)calloc(1, sizeof(chunk_buf_t));
//    chunk_buffer->buf = (char*)malloc(512 * 1024);
//    chunk_buffer->response = response;
//    http_request_set_userdata(request, chunk_buffer);
//    http_request_read_chunk(request, chunk_req_cb);
//    return;
//  } else if (request_target_is(request, "/large")) {
//    chunk_buf_t* chunk_buffer = (chunk_buf_t*)calloc(1, sizeof(chunk_buf_t));
//    chunk_buffer->buf = (char*)malloc(25165824);
//    chunk_buffer->response = response;
//    http_request_set_userdata(request, chunk_buffer);
//    http_request_read_chunk(request, chunk_req_cb);
//    return;
//  } else if (request_target_is(request, "/headers")) {
//    int iter = 0, i = 0;
//    http_string_t key, val;
//    char buf[512];
//    while (http_request_iterate_headers(request, &key, &val, &iter)) {
//      i += snprintf(buf + i, 512 - i, "%.*s: %.*s\n", key.len, key.buf, val.len, val.buf);
//    }
//    http_response_header(response, "Content-Type", "text/plain");
//    http_response_body(response, buf, i);
//    return http_respond(request, response);
//  } else {
    http_response_header(response, "Content-Type", "text/plain");
    http_response_body(response, RESPONSE, sizeof(RESPONSE) - 1);
//  }
  http_respond(request, response);
}
