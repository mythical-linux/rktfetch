#!/usr/bin/env racket


#lang racket/base


(require
 (only-in racket/file file->lines)
 (only-in racket/list
          first
          second
          )
 (only-in racket/string
          string-split
          string-trim
          )
 )

(provide get-memory)


(define (get-memory-unix)
  (let
      (
       [linux-memory-file "/proc/meminfo"]
       )
    (cond
      [(file-exists? linux-memory-file)
       (let*
           ;; "memory-string" can be #f if we have given a string where a number
           ;; cannot be extracted to string->number
           ;; which can happen sometimes when attempting to parse /proc/meminfo
           ([memory-string (string->number
                            (first (string-split
                                    (string-trim
                                     (second (string-split
                                              (first (file->lines linux-memory-file))
                                              ":"
                                              ))
                                     #:left? #t
                                     )
                                    " "
                                    ))
                            )
                           ])
         (if (number? memory-string)
             (string-append (number->string (quotient memory-string 1024)) "MB")
             "N/A (misformatted /proc/meminfo?)"
             )
         )
       ]
      [else "N/A (could not parse /proc/meminfo)"]
      )
    )
  )

(define (get-memory os)
  (case os
    [("unix")  (get-memory-unix)]
    [else "N/A (your OS isn't supported)"])
  )
