(import (cyclone curl)
        (scheme base))

(define curl (curl-easy-init))
(curl-easy-setopt curl CURLOPT_URL "http://example.com")
(curl-easy-perform curl)
(curl-easy-cleanup curl)

