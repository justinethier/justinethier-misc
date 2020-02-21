(define-library (cyclone curl)
  (include-c-header "<curl/curl.h>")
  (export 
    curl-global-init
    curl-easy-init
    curl-easy-cleanup
    curl-easy-setopt
    curl-easy-perform
    curl-version
  )
  (c-linker-options "-lcurl")
  ;(import (scheme base)
  ;        (scheme write)
  ;)
  (begin

    (define-c curl-version
      "(void *data, int argc, closure _, object k)"
      "char *version = curl_version();
       make_string(scm_version, version);
       return_closcall1(data, k, &scm_version); ")

    (define-c curl-global-init
      "(void *data, int argc, closure _, object k, object flags)"
      " CURLcode result = curl_global_init(obj_obj2int(flags));
        return_closcall1(data, k, obj_int2obj(result)); ")

    (define-c curl-easy-init
      "(void *data, int argc, closure _, object k)"
      " CURL *curl = curl_easy_init();
        if (curl) {
          make_c_opaque(opq, curl);
          return_closcall1(data, k, &opq); 
        } else {
          return_closcall1(data, k, boolean_f); 
        } ")

    (define-c curl-easy-cleanup
      "(void *data, int argc, closure _, object k, object opq)"
      " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
        CURL *handle = opaque_ptr(opq);
        curl_easy_cleanup(handle);
        return_closcall1(data, k, boolean_t); ")

 ;; TODO: see https://curl.haxx.se/libcurl/c/curl_easy_setopt.html
 ;;       need to encode all the options...
;curl_easy_setopt()
    (define-c curl-easy-setopt
      "(void *data, int argc, closure _, object k, object opq, object option, object param)"
      " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
        CURL *handle = opaque_ptr(opq);
        CURLoption coption = obj_obj2int(option); // TODO: type checking. also could this be truncating data??
        // TODO: param can be many types depending on options
        CURLcode result = curl_easy_setopt(handle, coption, string_str(param)); // TODO: not good enough for str
        return_closcall1(data, k, obj_int2obj(result)); ")

    (define-c curl-easy-perform
      "(void *data, int argc, closure _, object k, object opq)"
      " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
        CURL *handle = opaque_ptr(opq);
        CURLcode result = curl_easy_perform(handle);
        return_closcall1(data, k, obj_int2obj(result)); ")
;curl_easy_getinfo()
; TODO: see https://curl.haxx.se/libcurl/c/curl_easy_getinfo.html
;    (define-c curl-easy-getinfo
;      "(void *data, int argc, closure _, object k, object opq)"
;      " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
;        CURL *handle = opaque_ptr(opq);
;        CURLcode result = curl_easy_perform(handle);
;        return_closcall1(data, k, obj_int2obj(result)); ")

  )
)
