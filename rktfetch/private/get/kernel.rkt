#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/file file->string)
 "helpers/trim.rkt"
 "helpers/cmd.rkt"
 )

(provide get-kernel)


(define (get-kernel-unix)
  (let
      ([linux-kernel-file "/proc/sys/kernel/osrelease"])
    (cond
      [(file-exists? linux-kernel-file)
       (remove-newlines  (file->string linux-kernel-file))
       ]
      [(cmd->flat-str "uname -r")]
      [else "N/A (could not read '/proc/sys/kernel/osrelease' nor could run 'uname')"]
      )
    )
  )

(define (get-kernel os)
  (case os
    [("unix")  (get-kernel-unix)]
    [else "N/A (your OS isn't supported)"])
  )
