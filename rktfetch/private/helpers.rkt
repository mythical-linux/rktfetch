#lang racket/base

(require
 racket/file
 racket/list
 racket/port
 racket/string
 racket/system
 )

(provide
 basename
 cmd->flat-str
 grep
 grep-first->str
 remove-newlines
 seconds->time-str
 )

;; Helper functions
(define (basename str)
  (last (string-split str "/"))
  )

(define (remove-newlines str)
  ;; \r\n for NT
  (string-trim (string-trim str "\r\n") "\n")
  )

(define (cmd->flat-str command)
  (remove-newlines
   (with-output-to-string (lambda () (system command)))
   )
  )

;; TODO: add keywords to control behavior
;; TODO: add regexp?
(define (grep str file-name
              #:first [first-hit #f]
              )
  (let
      ([out '()])
    (for (
          [line (file->lines file-name)]
          #:when (case first-hit
                   [(#t) (<= (length out) 0)]
                   [else #t]
                   )
          )
      (when (string-contains? line str)
        (set! out (append out (list line)))
        )
      )
    out
    )
  )

(define (grep-first->str str file-name)
  (let*
      ([grep-list (grep str file-name #:first #t)])
    (if (empty? grep-list)
        ""
        (first grep-list)
        )
    )
  )

(define (seconds->time-str seconds)
  (let*
      (
       [minutes (modulo (quotient seconds 60) 60)]
       [hours   (modulo (quotient seconds (* 60 60)) 24)]
       [days            (quotient seconds (* 60 60 24))]
       )
    (if (= 0 days hours minutes)
        (string-append
         (number->string seconds) "s"
         )
        (string-append
         (number->string days)    "d" " "
         (number->string hours)   "h" " "
         (number->string minutes) "m" " "
         )
        )
    )
  )


(module+ test
  (require rackunit)
  (check-equal? "0d 0h 1m " (seconds->time-str 60))
  )
