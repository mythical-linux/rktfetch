#!/usr/bin/env racket


#lang racket/base


(require
 (only-in "helpers/grep.rkt" grep-first->str)
 (only-in "helpers/is.rkt" file-is?)
 (only-in "helpers/separator.rkt" string->separated-after)
 (only-in "helpers/string.rkt" remove-strings)
 )

(provide get-memory)


(define (string->memory str)
  (string->number
   (remove-strings (string->separated-after str ":") '("kB" " "))
   )
  )


(define (get-memory-unix)
  (cond
    [(file-is? "/proc/meminfo")
     => (lambda (f)
          (let* (
                 [MemTotal
                  (string->memory (grep-first->str "MemTotal" f))
                  ]
                 [MemFree
                  (string->memory (grep-first->str "MemFree" f))
                  ]
                 ;; includes cache, that's why it's so high
                 [MemUsed
                  (if (and MemTotal MemFree)  (- MemTotal MemFree)  #f)
                  ]
                 )
            (if (number? MemUsed)
                (string-append
                 (number->string (quotient MemUsed  1024)) "MB" " / "
                 (number->string (quotient MemTotal 1024)) "MB"
                 )
                "N/A (malformed /proc/meminfo?)"
                )
            )
          )
     ]
    [else  "N/A"]
    )
  )


(define (get-memory os)
  (case os
    [("unix")  (get-memory-unix)]
    [else "N/A (your OS isn't supported)"])
  )
