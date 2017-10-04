(define-library (lib http)
  (import 
    (scheme base)
    (scheme cyclone util)
    ;(srfi 1)
  )
  (include-c-header "http_parser.h")
  (include-c-header "http_parser.c")
  (export
    status-ok
    status-code->text
    *status-codes*
    http:make-header

    url-parse
    url/p->schema
    url/p->host
    url/p->port
    url/p->path
    url/p->query
    url/p->fragment
    url/p->userinfo

    ;; Still here, but probably obsolete
    url->query-string
    url->get-params
  )
  (begin

(define-c url-parse
  "(void *data, int argc, closure _, object k, object url)"
  " Cyc_check_str(data, url);
    struct http_parser_url u;
    int connect, result;

    connect = strcmp(\"connect\", string_str(url)) == 0 ? 1 : 0;

    http_parser_url_init(&u);
    result = http_parser_parse_url(string_str(url), string_len(url), connect, &u);
    if (result != 0) {
      return_closcall1(data, k, boolean_f); // Parse error
    } else {
      make_c_opaque(opq, &u);
      return_closcall1(data, k, &opq);
    }
    ")

;;(define-c urlp->port
;;  "(void *data, int argc, closure _, object k, object opq)"
;;  " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
;;    struct http_parser_url *u = opaque_ptr(opq);
;;    return_closcall1(data, k, obj_int2obj(u->port));
;;  ")

(define-syntax get-urlp-field
  (er-macro-transformer
    (lambda (expr rename compare)
      (let* ((fnc (cadr expr))
             (args
              "(void *data, int argc, closure _, object k, object url, object opq)")
             (field (caddr expr))
             (body
              (string-append
                " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
                  Cyc_check_str(data, url);
                  struct http_parser_url *u = opaque_ptr(opq);
                  if ((u->field_set & (1 << " field ")) == 0){
                    make_string(str, \"\");
                    return_closcall1(data, k, &str);
                  } else {
                    make_string_with_len(str, (string_str(url) + u->field_data[" field "].off), u->field_data[" field "].len);
                    return_closcall1(data, k, &str);
                  }"
              )))
        `(define-c ,fnc ,args ,body)))))

(get-urlp-field url/p->schema "UF_SCHEMA   ")
(get-urlp-field url/p->host "UF_HOST     ")
(get-urlp-field url/p->port "UF_PORT     ")
(get-urlp-field url/p->path "UF_PATH     ")
(get-urlp-field url/p->query "UF_QUERY    ")
(get-urlp-field url/p->fragment "UF_FRAGMENT ")
(get-urlp-field url/p->userinfo "UF_USERINFO ")

;; EG: http://10.0.0.4/test//someUrl.cgi?one=1&two=2
;; https://en.wikipedia.org/wiki/Query_string
;;
(define (url->query-string url)
  (let ((lis (string-split url #\?)))
    (cond
      ((null? lis) "")
      (else (cadr lis)))))

;; url->get-params :: string -> [alist]
(define (url->get-params url)
  (let* ((qs (url->query-string url))
         (field-values (string-split qs #\&)))
    (map
      (lambda (field-value)
        (let ((fv (string-split field-value #\=)))
          (cons (car fv) (cadr fv))))
      field-values)))

;; END (http url)

;; TODO: deconstruct POST params: see example in notes.txt

(define (status-ok) (status-code->text 200))
(define (status-code->text code)
  (let ((lookup (assoc code *status-codes*)))
    (if lookup 
        (cdr lookup)
        (error "Status text not found for code" code))))

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
    "\r\nStatus: " (status-code->text status-code)
    "\r\n\r\n"))
;;;; END HTTP library
  )
)
