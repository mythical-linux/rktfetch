#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/list second)
 (only-in racket/string
          non-empty-string?
          string-split
          string-trim
          )
 "helpers/grep.rkt"
 )

(provide get-cpu)


(define (get-cpu)
  (let
      (
       [linux-info-file "/proc/cpuinfo"]
       )
    (cond
      [(file-exists? linux-info-file)
       (let*
           ([model-name (grep-first->str "model name" linux-info-file)])
         (cond
           [(non-empty-string? model-name) (string-trim
                                            (second (string-split model-name ":"))
                                            #:left? #t
                                            )
                                           ]
           [else "N/A (/proc/cpuinfo doesn't provide required information)"]
           )
         )
       ]
      [else "N/A (could not read /proc/cpuinfo)"]
      )
    )
  )
