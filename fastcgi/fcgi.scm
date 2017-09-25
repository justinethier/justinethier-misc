(import (scheme base)
        (srfi 18)
        )
(include-c-header "fcgi_config.h")
(include-c-header "fcgiapp.h")

(define-c fcgx-init
  "(void *data, int argc, closure _, object k)"
  " FCGX_Init();
    return_closcall1(data, k, boolean_t);")

(define-c make-request
  "(void *data, int argc, closure _, object k)"
  " FCGX_Request *req = malloc(sizeof(FCGX_Request));
    make_c_opaque(opq, req);
    FCGX_InitRequest(req, 0, 0);
    return_closcall1(data, k, &opq);")
    
(define-c accept-request
  "(void *data, int argc, closure _, object k, object opq)"
  " FCGX_Request *req = opaque_ptr(opq);
    int rc = FCGX_Accept_r(req);
    if (rc < 0) {
      fprintf(stderr, \"Error accepting request\\n\");
      exit(1);
    }
    return_closcall1(data, k, boolean_t);")

(define-c print-request
  "(void *data, int argc, closure _, object k, object opq, object str)"
  " FCGX_Request *req = opaque_ptr(opq);
    FCGX_FPrintF(req->out, string_str(str));
    return_closcall1(data, k, boolean_t);")

(define-c finish-request
  "(void *data, int argc, closure _, object k, object opq)"
  " FCGX_Request *req = opaque_ptr(opq);
    FCGX_Finish_r(req);
    return_closcall1(data, k, boolean_t);")

(fcgx-init);
(define (fcgi-loop)
  (let loop ((req (make-request)))
    (accept-request req)
    (print-request req
      "Content-type: text/html\r\nStatus: 200 OK\r\n\r\nHello, world")
    (finish-request req)
    (loop req)))

(fcgi-loop)
