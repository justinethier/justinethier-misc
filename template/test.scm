(import (scheme base) 
        (parser)
        (template)
        (cyclone test))

(test-group "General"
  (test "Example" #t #t)
)

(define view-2
"<html>
<head><title>Test View></title></head>
<body>

some body text here...

</body>
</html>

")

(test-group "Basic views with no embedded Scheme"
  (call-with-port 
    (open-output-string) 
    (lambda (p)
      (parameterize ((current-output-port p))
        (test 
          view-2
          (begin 
           (render "view-2.html" '())
           (get-output-string p)))))))

(test-exit)
