
#ifndef SO_REUSEPORT 
#define SO_REUSEPORT SO_REUSEADDR
#endif

#define HTTPSERVER_IMPL
#include "httpserver.h"
#include <signal.h>
#include "cyclone/types.h"

#define RESPONSE "Hello, World!"

object _shared_cv;
object _shared_lock;
object _shared_req;
object _shared_resp;

int request_target_is(struct http_request_s* request, char const * target) {
  http_string_t url = http_request_target(request);
  int len = strlen(target);
  return len == url.len && memcmp(url.buf, target, url.len) == 0;
}

void handle_request(struct http_request_s* request) {
//  chunk_count = 0;
  http_request_connection(request, HTTP_AUTOMATIC);
  struct http_response_s* response = http_response_init();

  pthread_cond_t *cond = &(((cond_var)_shared_cv)->cond);
  pthread_mutex_t *lock = &(((mutex)_shared_lock)->lock);

  // set request/response aside (or send) such that SCM thread can receive them
  opaque_ptr(_shared_req) = request;
  opaque_ptr(_shared_resp) = response;

  // Wake up SCM thread
  pthread_cond_broadcast(cond);

  // Lock our mutex now and wait on CV. when scheme is done, it needs to do its own broadcast
  // to wake us back up
  pthread_mutex_lock(lock); // TODO: error check each of these
  pthread_cond_wait(cond, lock);
  pthread_mutex_unlock(lock);

  http_respond(request, response);
}

struct http_server_s* server;

void handle_sigterm(int signum) {
  (void)signum;
  free(server);
  exit(0);
}

void *start_server(object v) {
  object port = ((vector) v)->elements[0];
  _shared_lock = ((vector) v)->elements[1];
  _shared_cv = ((vector) v)->elements[2];
  _shared_req = ((vector) v)->elements[3];
  _shared_resp = ((vector) v)->elements[4];
  signal(SIGTERM, handle_sigterm);
  server = http_server_init(obj_obj2int(port), handle_request);
  http_server_listen(server);
  return NULL;
}

void start_thread(object vec) {
  pthread_t thread;                                                                                  
  pthread_attr_t attr;                                                                               
  pthread_attr_init(&attr);                                                                          
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
  if (pthread_create(&thread, &attr, start_server, vec)) {                          
    fprintf(stderr, "Error creating a new thread\n");                                                
    exit(1);                                                                                         
  }                                                                                                  
  pthread_attr_destroy(&attr); 

  //pthread_join(thread, NULL);
}


