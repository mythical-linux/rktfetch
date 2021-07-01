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


(define (after-separator str sep)
  (string-trim (second (string-split str sep)))
  )

(define (doesnt-provide-info str)
  (string-append "N/A (file \"" str "\" doesn't provide required information)")
  )


(define (get-cpu-unix)
  (let
      (
       [linux-info-file "/proc/cpuinfo"]
       [bsd-dmesg-file  "/var/run/dmesg.boot"]
       )
    (cond
      [(file-exists? linux-info-file)
       (let*
           (
            [model-line (grep-first->str "model name" linux-info-file)]
            [model-name (after-separator model-line ":")]
            )
         (cond
           [(non-empty-string? model-name)  model-name]
           [else (doesnt-provide-info linux-info-file)]
           )
         )
       ]
      [(file-exists? bsd-dmesg-file)
       (let*
           (
            [model-line (grep-first->str "cpu0 at cpus0" bsd-dmesg-file)]
            [model-name (after-separator model-line ":")]
            )
         (cond
           [(non-empty-string? model-name)  model-name]
           [else  (doesnt-provide-info bsd-dmesg-file)]
           )
         )
       ]
      [else "N/A (could not read /proc/cpuinfo)"]
      )
    )
  )


(define (get-cpu os)
  (case os
    [("unix")  (get-cpu-unix)]
    [else "N/A (your OS isn't supported)"]
    )
  )
