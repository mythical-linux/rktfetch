#!/usr/bin/env racket


#lang racket/base


(require
 (only-in racket/file file->string)
 (only-in racket/string string-split)
 "helpers/cmd.rkt"
 "helpers/time.rkt"
 "helpers/trim.rkt"
 )

(provide get-uptime)


(define (get-uptime-unix)
  (let
      ([linux-uptime-file "/proc/uptime"])
    (cond
      [(file-exists? linux-uptime-file)
       (seconds->time-str
        (string->number
         (car (string-split (remove-newlines (file->string linux-uptime-file)) "." #:trim? #t))
         )
        )
       ]
      [(cmd->flat-str "uptime -p")]
      )
    )
  )

(define (get-uptime os)
  (case os
    [("unix")  (get-uptime-unix)]
    [else "N/A"]
    )
  )
