
#ifndef SO_REUSEPORT 
#define SO_REUSEPORT SO_REUSEADDR
#endif

#define HTTPSERVER_IMPL
#include "httpserver.h"
#include <signal.h>
#include "cyclone/types.h"

#define RESPONSE "Hello, World!"

extern object __glo_cv;
extern object __glo_lock;
extern object __glo_req;
extern object __glo_resp;

void handle_request(struct http_request_s* request) {
//  chunk_count = 0;
  http_request_connection(request, HTTP_AUTOMATIC);
  struct http_response_s* response = http_response_init();

  pthread_cond_t *cond = &(((cond_var)__glo_cv)->cond);
  pthread_mutex_t *lock = &(((mutex)__glo_lock)->lock);

  // set request/response aside (or send) such that SCM thread can receive them
  opaque_ptr(__glo_req) = request;
  opaque_ptr(__glo_resp) = response;

  // Wake up SCM thread
  pthread_cond_broadcast(cond);

  // Lock our mutex now and wait on CV. when scheme is done, it needs to do its own broadcast
  // to wake us back up
  pthread_mutex_lock(lock); // TODO: error check each of these
  pthread_cond_wait(cond, lock);
  pthread_mutex_unlock(lock);

  //http_response_status(response, 200);
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
    //http_response_header(response, "Content-Type", "text/plain");
    //http_response_body(response, RESPONSE, sizeof(RESPONSE) - 1);
//  }
  http_respond(request, response);
}

struct http_server_s* server;

void handle_sigterm(int signum) {
  (void)signum;
  free(server);
  exit(0);
}

void *start_server(void *arg) {
  signal(SIGTERM, handle_sigterm);
  server = http_server_init(8080, handle_request);
  http_server_listen(server);
  return NULL;
}

void start_thread() {
  pthread_t thread;                                                                                  
  pthread_attr_t attr;                                                                               
  pthread_attr_init(&attr);                                                                          
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
  if (pthread_create(&thread, &attr, start_server, NULL)) {                          
    fprintf(stderr, "Error creating a new thread\n");                                                
    exit(1);                                                                                         
  }                                                                                                  
  pthread_attr_destroy(&attr); 

  //pthread_join(thread, NULL);
}


