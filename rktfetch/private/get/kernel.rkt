#!/usr/bin/env racket


#lang racket/base

(require
 "helpers/cmd.rkt"
 (only-in "helpers/grep.rkt" first-line)
 (only-in "helpers/is.rkt" file-is?)
 )

(provide get-kernel)


(define (get-kernel-unix)
  (cond
    [(file-is? "/proc/sys/kernel/osrelease") => first-line]
    [(cmd->flat-str "uname -r")]
    [else "N/A (could not read kernel)"]
    )
  )


(define (get-kernel os)
  (case os
    [("unix")  (get-kernel-unix)]
    [else "N/A (your OS isn't supported)"])
  )
