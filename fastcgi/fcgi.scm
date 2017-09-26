(import (scheme base)
        (srfi 18)
        )

;; FUTURE FCGI library
(include-c-header "fcgi_config.h")
(include-c-header "fcgiapp.h")

(define-c fcgx:init
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

(fcgx:init)
(define (fcgi:loop callback-body)
  (let loop ((req (make-request)))
    (accept-request req)
    (callback-body req)
    (finish-request req)
    (loop req)))
;;;; END FCGI library

;;;; FUTURE HTTP library
;; TODO - see: https://www.w3.org/Protocols/rfc2616/rfc2616.html

(define (status-ok) (status-code->text 200))
(define (status-code->text code)
  (assoc code *status-codes*))

(define *status-codes*
  ;; Informational 1xx
  '((100 . "100 Continue")
    (101 . "101 Switching Protocols")
    ;; Successful 2xx
    (200 . "200 OK")
    (201 . "201 Created")
    (202 . "202 Accepted")
    (203 . "203 Non-Authoritative Information")
    (204 . "204 No Content")
    (205 . "205 Reset Content")
    (206 . "206 Partial Content")
    ;; Redirection 3xx
    (300 . "300 Multiple Choices")
    (301 . "301 Moved Permanently")
    (302 . "302 Found")
    (303 . "303 See Other")
    (304 . "304 Not Modified")
    (305 . "305 Use Proxy")
    (306 . "306 (Unused)")
    (307 . "307 Temporary Redirect")
    ;; Client Error 4xx
    (400 . "400 Bad Request")
    (401 . "401 Unauthorized")
    (402 . "402 Payment Required")
    (403 . "403 Forbidden")
    (404 . "404 Not Found")
    (405 . "405 Method Not Allowed")
    (406 . "406 Not Acceptable")
    (407 . "407 Proxy Authentication Required")
    (408 . "408 Request Timeout")
    (409 . "409 Conflict")
    (410 . "410 Gone")
    (411 . "411 Length Required")
    (412 . "412 Precondition Failed")
    (413 . "413 Request Entity Too Large")
    (414 . "414 Request-URI Too Long")
    (415 . "415 Unsupported Media Type")
    (416 . "416 Requested Range Not Satisfiable")
    (417 . "417 Expectation Failed")
    ;; Server Error 5xx
    (500 . "500 Internal Server Error")
    (501 . "501 Not Implemented")
    (502 . "502 Bad Gateway")
    (503 . "503 Service Unavailable")
    (504 . "504 Gateway Timeout")
    (505 . "505 HTTP Version Not Supported")))

(define (http:make-header content-type status-code)
  (string-append
    "Content-type: " content-type
    "\r\nStatus: 200 OK"
    "\r\n\r\n"))
;;;; END HTTP library

(fcgi:loop 
  (lambda (req)
    (print-request req
      "Content-type: text/html\r\nStatus: 200 OK\r\n\r\nHello, world")))
