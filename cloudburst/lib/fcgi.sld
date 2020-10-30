(define-library (lib fcgi)
  (import 
    (scheme base)
    (scheme cyclone util)
    (srfi 18)
  )
  (include-c-header "fcgi_config.h")
  (include-c-header "fcgiapp.h")
  (export
    fcgx:init
    fcgx:get-string
    fcgx:get-param
    fcgx:make-request
    fcgx:accept-request
    fcgx:print-request
    fcgx:finish-request
    fcgx:loop
  )
  (begin
    (define-c fcgx:init
      "(void *data, int argc, closure _, object k)"
      " FCGX_Init();
        return_closcall1(data, k, boolean_t);")
    
    ;; TODO: fcgx:get-string (wrapper of FCGX_GetStr)
    ;; may want to have a higher-order function that allocates the string
    ;; and a lower one that does the actual reading
    ;; see https://fossies.org/dox/FCGI-0.78/fcgiapp_8c_source.html
    ;; and http://chriswu.me/code/hello_world_fcgi/main_v2.cpp (reading remainder of stdin)
    
    (define (fcgx:get-string req len)
      (let ((result (make-string (+ len 1) #\null)))
        (_fcgx:get-string req len result)
        result))
    
    (define-c _fcgx:get-string
      "(void *data, int argc, closure _, object k, object req, object num, object buf)"
      " Cyc_check_str(data, buf);
        Cyc_check_fixnum(data, num);
        FCGX_Request *request = opaque_ptr(req);
        char *s = string_str(buf);
        int n = obj_obj2int(num);
        int n_read = FCGX_GetStr(s, n, request->in);
        s[n_read] = '\\0';
        string_len(buf) = n_read;
        return_closcall1(data, k, obj_int2obj(n_read)); ")
    
    (define (fcgx:get-param req param default-value)
      (let ((rv (_fcgx:get-param req param)))
        (if rv rv default-value)))
    
    (define-c _fcgx:get-param
      "(void *data, int argc, closure _, object k, object req, object param)"
      " Cyc_check_str(data, param);
        FCGX_Request *request = opaque_ptr(req);
        const char *p = FCGX_GetParam(string_str(param), request->envp);
        if (p) {
          make_string(str, p);
          return_closcall1(data, k, &str);
        } else {
          return_closcall1(data, k, boolean_f);
        } ")
    
    (define-c fcgx:make-request
      "(void *data, int argc, closure _, object k)"
      " FCGX_Request *req = malloc(sizeof(FCGX_Request));
        make_c_opaque(opq, req);
        FCGX_InitRequest(req, 0, 0);
        return_closcall1(data, k, &opq);")
        
    (define-c fcgx:accept-request
      "(void *data, int argc, closure _, object k, object opq)"
      " FCGX_Request *req = opaque_ptr(opq);
        int rc = FCGX_Accept_r(req);
        if (rc < 0) {
          fprintf(stderr, \"Error accepting request\\n\");
          exit(1);
        }
        return_closcall1(data, k, boolean_t);")
    
    (define-c fcgx:print-request
      "(void *data, int argc, closure _, object k, object opq, object str)"
      " FCGX_Request *req = opaque_ptr(opq);
        FCGX_FPrintF(req->out, string_str(str));
        return_closcall1(data, k, boolean_t);")
    
    (define-c fcgx:finish-request
      "(void *data, int argc, closure _, object k, object opq)"
      " FCGX_Request *req = opaque_ptr(opq);
        FCGX_Finish_r(req);
        return_closcall1(data, k, boolean_t);")
    
    (define (fcgx:loop callback-body)
      (let ((req (fcgx:make-request)))
        (thread-specific-set! (current-thread) req) ;; Save for later
        (let loop ()
          (fcgx:accept-request req)
          (callback-body req)
          (fcgx:finish-request req)
          (loop))))
  ))
