(define-library (app models demo)
  (import 
    (scheme base)
    (scheme write)
    (lib http)
  )
  (export
    get-data
  )
  (begin
    (define (get-data)
      '(1 2 3
        a b c
        "x" "y" "z"))
  ))
