(import (scheme base) 
        (parser)
        (template)
        (cyclone test))

(test-group "General"
  (test "Example" #t #t)
)

(define view-1
"<html>
<head><title>Test View></title></head>
<body>

{% (for-each (lambda (row) %}
  <p>
    <a href=\"{{ (link row) }}\">
      {{ (desc row) }}
    </a>
  </p>
{% ) rows) %}

</body>
</html>")

(define view-2
"<html>
<head><title>Test View></title></head>
<body>

some body text here...

</body>
</html>

")

(define view-3
"
<html>
<head><title>Test of a template comment></title></head>
<body>

01234


more text



</body>
</html>
")

(define view-4
"
<html>
<head><title>Test View></title></head>
<body>

  <p>
    <a href=\"view-2.html\">
      View 2
    </a>
  </p>

</body>
</html>
")

(define-syntax test-group/output
  (syntax-rules ()
      ((_ desc expected body ...)
       (test-group
         desc
         (test/output
           expected
           (lambda ()
             body ...))))))

(define (test/output expected thunk)
  (call-with-port 
    (open-output-string) 
    (lambda (p)
      (parameterize ((current-output-port p))
        (thunk)
        (test 
          expected
          (get-output-string p))))))

;; TODO: view 1

(test-group/output
  "Basic views with no embedded Scheme"
  view-2
  (render "view-2.html" '()))

(test-group/output "Basic view with comments"
  view-3
  (render "view-3.html" '()))

(test-group/output "Basic inline comment"
  " test "
  (render (open-input-string " test ") '()))

(test-group/output
  "Basic view with expressions"
  view-4
  (render
    "view-4.html" 
    '((row . '("view-2.html" . "View 2"))
      (link . car)
      (desc . cdr))))

(test-exit)
