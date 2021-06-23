(import 
    (scheme base)
    (scheme write)
    ;(cyclone foreign)
    (srfi 18)
)

(include-c-header "start-server.h")

(define-c server-init
  "(void *data, int argc, closure _, object k, object port)"
  " Cyc_check_fixnum(data, port);
    // TODO: pass port

    start_thread();
    return_closcall1(data, k, boolean_t);
  ")

(define lock (make-mutex))
(define cv (make-condition-variable))

(server-init 0)
(let loop ()
  (mutex-lock! lock)
  (mutex-unlock! lock cv)
  (write `(iterate loop))
  (newline)
  (loop))

