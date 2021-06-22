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
  )
)
