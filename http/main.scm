(import
  (http-server)
  (scheme base)
  (srfi 18)
)

(define (start-server)
  (let ((server (server-init 1234)))
    (server-listen-poll server)
    server))

(define (run-server-poll server)
  (let loop ((state (server-poll server)))
    (cond
      ((zero? state)
       #t) ;; All done
      (else
       (loop (server-poll server))))))

(let loop ((server (start-server)))
  (run-server-poll server)
  (thread-sleep! 0.25) ;; TODO: use select() instead
  (loop server))
