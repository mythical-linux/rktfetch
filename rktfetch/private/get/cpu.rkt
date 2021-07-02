#!/usr/bin/env racket


#lang racket/base

(require
 "helpers/grep.rkt"
 "helpers/is.rkt"
 "helpers/separator.rkt"
 )

(provide get-cpu)


(define (valid-info? str)
  (is? str (lambda (s) (not (equal? s ""))))
  )

(define (validate-info-file info-str file-name)
  (cond
    [(valid-info? info-str)]
    [else  (string-append
            "N/A (file \"" file-name "\" doesn't provide required information)"
            )
           ]
    )
  )


(define (get-cpu-unix)
  (cond
    [(file-is? "/proc/cpuinfo")
     => (lambda (f) (validate-info-file
                (string->separated-after (grep-first->str "model name" f)
                                         ":") f))]
    [(file-is? "/var/run/dmesg.boot")
     => (lambda (f) (validate-info-file
                (string->separated-after (grep-first->str "cpu0 at cpus0" f)
                                         ":") f))]
    [else  "N/A (no file to gather CPU info)"]
    )
  )


(define (get-cpu os)
  (case os
    [("unix")  (get-cpu-unix)]
    [else "N/A (your OS isn't supported)"]
    )
  )
