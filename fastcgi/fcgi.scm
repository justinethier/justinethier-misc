(import (scheme base)
        (srfi 18)
        (http))

;; FUTURE FCGI library
(include-c-header "fcgi_config.h")
(include-c-header "fcgiapp.h")

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

(fcgx:init)
(define (fcgi:loop callback-body)
  (let loop ((req (make-request)))
    (accept-request req)
    (callback-body req)
    (finish-request req)
    (loop req)))
;;;; END FCGI library

(fcgi:loop 
  (lambda (req)
    (print-request req (http:make-header "text/html" 200))
    (print-request req "Hello, world:")
    (print-request req (fcgx:get-param req "REQUEST_URI" ""))
    (let* ((len-str (fcgx:get-param req "CONTENT_LENGTH" "0"))
           (len (string->number len-str))
           (len-num (if len len 0)))
      (print-request req "<p>")
      (print-request req (fcgx:get-string req len-num))
      (print-request req "<p>")
      )))
