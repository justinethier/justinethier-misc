(define-library (cyclone curl)
  (include-c-header "<curl/curl.h>")
  (export curl-version)
  (c-linker-options "-lcurl")
  ;(import (scheme base)
  ;        (scheme write)
  ;)
  (begin

    (define test "test")
    (define-c curl-version
      "(void *data, int argc, closure _, object k)"
      "char *version = curl_version();
       make_string(scm_version, version);
       return_closcall1(data, k, &scm_version); ")
  )
)
