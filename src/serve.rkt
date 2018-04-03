#lang racket

(require racket/date)

(define (go)
 'yep-it-works)

(define (serve port-no)
  (define main-cust (make-custodian))
  (parameterize ([current-custodian main-cust])
    (define listener (tcp-listen port-no 5 #t))
    (define (loop)
      (accept-and-handle listener)
      (loop))
    (thread loop))
  (lambda ()
    (custodian-shutdown-all main-cust)))

(define (accept-and-handle listener)
  (define cust (make-custodian))
  (parameterize ([current-custodian cust])
    (define-values (in out) (tcp-accept listener))
    (thread
     (lambda () (handle in out)
       (close-input-port in)
       (close-output-port out))))
  ;; Watcher thread
  (thread (lambda ()
            (sleep 10)
            (custodian-shutdown-all cust))))

(define (handle in out)
  (regexp-match #rx"(\r\n|^)\r\n" in)

  (display "HTTP/1.0 200 Okay\r\n" out)
  (display "\r\n" out)
  (display
   (format "<html><body><h1>~a</h1></body></html>" (format-time))
   out))

(define (format-time)
  (parameterize ([date-display-format 'chinese])
    (date->string (current-date))))

(println "Server is running...")
(define stop (serve 1234))