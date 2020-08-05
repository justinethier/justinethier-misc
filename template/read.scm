(import (scheme base)
        (scheme read)
        (scheme write)
        (scheme eval)
        )

(define-record-type <parser
  (%make-parser fp buf i exprs)
  parser?
  (fp p:fp)
  (buf p:buf p:set-buf!)
  (i p:i p:set-i!)
  (exprs p:exprs p:set-exprs)
 )

(define (make-parser fp)
  (%make-parser fp "" 0 '()))

;; Read more data from stream
(define (p:read! p)
  (let ((buf (read-string 2 (p:fp p))))
    (p:set-buf! p buf)
    (p:set-i! p 0)))
 
;; Get next char from stream
(define (p:getc p)
  (cond
   ((eof-object? (p:buf p)) p)
   ((= (p:i p) (string-length (p:buf p)))
    (p:read! p)
    (p:getc p)) ;; Try again
   (else
     (p:set-i! (+ 1 (p:i p)))
     (string-ref (p:buf p) (- (p:i) 1))
   )))

;; Add given expression
(define (p:add-expr! p expr)
  (p:set-exprs! p (cons expr (p:exprs))))

;; Scan string for an SCM open tag
;; Return: index of tag or #f if none
(define (scan-for-scm-tag str)
  (let loop ((i 0))
    (cond
     ((equal? i (string-length str)) #f)
     ((equal? #\{ (string-ref str i)) i)
     (else
       (loop (+ i 1))))))

(define (read-tag fp str idx)
 (cond
  ((= idx (string-length str))
   (set! str (read-string 2 fp)) ;; TODO: what if eof?
   (set! idx 0))
  (else
   (set! idx (+ idx 1))))
 ;; TODO: read contents of tag {X X}
 (cons '()
       (substring str idx (string-length str)))) ;; TODO: return portion of string after the scm tag

; regular text - accumulate
; { - special char next
(define (read-template p) 
  (let loop ((fp (p:fp p))
             (str (read-string 2 (p:fp p)))
             (acc '())
            )
    (cond
      ((eof-object? str)
       (map (lambda (str)
              ;`(display ,str))
              (eval `(display ,str)))
            (reverse acc)))
      ((scan-for-scm-tag str)
       (let* ((idx (scan-for-scm-tag str))
              (pre-scm (substring str 0 (if (> idx 0) (- idx 1) 0)))
              (scm/str (read-tag fp str idx))
             )
         (loop fp (cdr scm/str) (cons pre-scm
                                      (cons (car scm/str) acc)))))
      (else
       (loop fp (read-string 2 fp) (cons str acc))))))
; (let ((c (p:getc p)))
;   (cond
;     ((eof-object? c)
;      (p:set-exprs! p acc)
;      (p:exprs p))
;     (else

  (read-template 
    (make-parser (open-input-file "view-1.html")))


;; TODO: write out algorithm
;ideally we want to read strings and then fly down them, 
;only stopping if we encounter a char that prevents us
;from using the whole string
