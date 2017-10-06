(import (scheme base) (scheme write))
(import (scheme base) (scheme write))
(import (prefix (lib http) http:))
(define-syntax dyn-import
  (er-macro-transformer
    (lambda (expr rename compare)
      `(import (app controllers demo)))))
(dyn-import)

;(write status-ok)
(write http:status-ok)
(write (test))
