#lang racket
(require web-server/servlet
         web-server/servlet-env
         web-server/dispatch)
 
(define (start req)
  (sorry-dispatch req))
 
(define-values (sorry-dispatch sorry-url)
  (dispatch-rules
   [((string-arg) "") show-page]
   [((string-arg) "make") make-gif]))

(define (show-page req template-name) `(p "show"))

(define template-table (make-hash))

(struct template (template-video
                  template-subtitle
                  example-image))

(define (load-templates dir)
  (map load-template (scan-directories)))

(define (scan-directories)
  (filter directory-exists? (directory-list "templates")))

(define (load-template dir)
  (let ([t-name     (path-string dir)]
        [t-video    (build-path "templates" dir "template.mp4")]
        [t-subtitle (build-path "templates" dir "template.erb")] ;; FIX!!
        [t-image    (build-path "templates" dir "example.png")])
    (if (andmap file-exists? (list
                              t-video
                              t-subtitle
                              t-image))
        (hash-set! template-table t-name
                   (template t-name t-video t-subtitle t-image))
        (printf "Error loading template: ~a\n" t-name))))

(define (make-gif req template-name)
  (response/xexpr `(p
                    (a ((href "/cache/...") (target "_blank"))
                       (p "点击下载")))))

(serve/servlet start
               #:launch-browser? #f               
               #:listen-ip "0.0.0.0"
               #:port 4567
               #:servlet-regexp #rx""
               #:extra-files-paths
               (list
                (build-path (current-directory) "public")))