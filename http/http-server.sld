(define-library (http-server)
  (import 
    (scheme base)
    ;(scheme write)
    (cyclone foreign)
  )
  (include-c-header "config.h")
  (include-c-header "httpserver.h")
  (include-c-header "handle-request.h")
  (export
    server-init
    server-listen-poll
    server-poll
  )
  (begin
    (define-c server-init
      "(void *data, int argc, closure _, object k, object port)"
      " Cyc_check_fixnum(data, port);
        struct http_server_s* server = http_server_init(obj_obj2int(port), handle_request);
        if (server) {
          make_c_opaque(opq, server);
          return_closcall1(data, k, &opq); 
        } else {
          return_closcall1(data, k, boolean_f); 
        } ")

    (define (server-listen-poll opq . ipaddr)
      (_server-listen-poll
        opq
        (if (pair? ipaddr)
            (car ipaddr)
            ipaddr)))

    (define-c _server-listen-poll
      "(void *data, int argc, closure _, object k, object opq, object ipaddr)"
      " Cyc_check_opaque(data, opq);
        char *addr = NULL;

        if (Cyc_is_string(ipaddr)) {
          addr = string_str(ipaddr);
        }

        struct http_server_s* server = opaque_ptr(opq);
        http_server_listen_addr_poll(server, addr);
        return_closcall1(data, k, boolean_t); 
      ")

    ;; Call this function in your update loop. It will trigger the request handler
    ;; once if there is a request ready. Returns 1 if a request was handled and 0
    ;; if no requests were handled. It should be called in a loop until it returns
    ;; 0.
    (define-c server-poll
      "(void *data, int argc, closure _, object k, object opq)"
      " Cyc_check_opaque(data, opq);
        struct http_server_s* server = opaque_ptr(opq);
        int rv = http_server_poll(server);
        return_closcall1(data, k, obj_int2obj(rv));
      ")
  )
)
