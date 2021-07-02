#!/usr/bin/env racket


#lang racket/base


(require
 "helpers/cmd.rkt"
 "helpers/time.rkt"
 (only-in "helpers/grep.rkt" first-line)
 (only-in "helpers/is.rkt" file-is?)
 (only-in "helpers/separator.rkt" string->separated-before)
 )

(provide get-uptime)


(define (get-uptime-unix)
  (cond
    [(file-is? "/proc/uptime")
     => (lambda (f)
          (seconds->time-str
           ;; WORKAROUND: by picking "." as separator we discard fractional part
           (string->number (string->separated-before (first-line f) "."))
           )
          )
     ]
    [(cmd->flat-str "uptime -p")]
    )
  )

(define (get-uptime os)
  (case os
    [("unix")  (get-uptime-unix)]
    [else "N/A"]
    )
  )
