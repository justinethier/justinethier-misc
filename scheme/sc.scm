# Examples from http://community.schemewiki.org/?syntactic-closures
(import (chibi) 
        ;(scheme base) 
        ;(scheme write)  
        (scheme cxr))

 (define-syntax swap! 
   (sc-macro-transformer 
    (lambda (form environment) 
      (let ((a (make-syntactic-closure environment '() (cadr form))) 
            (b (make-syntactic-closure environment '() (caddr form)))) 
        `(let ((value ,a)) 
           (set! ,a ,b) 
           (set! ,b value)))))) 

(define x 1) 
(define y 2)
(swap! x y)
(write `(x ,x y ,y))
(newline)
