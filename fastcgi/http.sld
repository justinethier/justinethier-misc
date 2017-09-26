(define-library (http)
  (import (scheme base))
  (export
    status-ok
    status-code->text
    *status-codes*
    http:make-header
  )
  (begin
;; TODO - see: https://www.w3.org/Protocols/rfc2616/rfc2616.html

;; TODO: deconstruct GET params:
;; EG: http://10.0.0.4/test//someUrl.cgi?one=1&two=2

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
