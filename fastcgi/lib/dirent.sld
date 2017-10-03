(define-library (lib dirent)
  (import 
    (scheme base)
    (scheme cyclone util))
  (include-c-header "dirent.h")
  (export
    opendir
    closedir
    readdir
  )
  (begin
  ;; See: 
  ;; https://stackoverflow.com/questions/612097/how-can-i-get-the-list-of-files-in-a-directory-using-c-or-c
  ;; http://pubs.opengroup.org/onlinepubs/7908799/xsh/dirent.h.html

    (define-c opendir
      "(void *data, int argc, closure _, object k, object str)"
      " Cyc_check_str(data, str);
        DIR *result = opendir( string_str(str) );
        if (result) {
          make_c_opaque(opq, result);
          return_closcall1(data, k, &opq);
        } else {
          return_closcall1(data, k, boolean_f);
        }")

    (define-c closedir
      "(void *data, int argc, closure _, object k, object opq)"
      " int result = closedir( opaque_ptr(opq) );
        return_closcall1(data, k, obj_int2obj(result));")

    (define-c readdir
      "(void *data, int argc, closure _, object k, object opq)"
      " DIR *dir = opaque_ptr(opq);
        struct dirent *ent = readdir(dir);
        if (!ent) {
          return_closcall1(data, k, boolean_f);
        } else {
          make_string(str, ent->d_name);
          return_closcall1(data, k, &str);
        } ")
  ))
