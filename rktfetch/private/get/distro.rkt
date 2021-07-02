#!/usr/bin/env racket


#lang racket/base

(require
 (only-in "helpers/grep.rkt" grep-first)
 (only-in racket/string
          string-replace
          string-trim
          )
 "helpers/cmd.rkt"
 )

(provide get-distro)


(define (get-distro-unix)
  (let
      (
       [os-release-list '(
                          "/bedrock/etc/os-release"
                          "/etc/os-release"
                          "/var/lib/os-release"
                          )]
       [dist #f]
       )
    (for ([l os-release-list]
          #:when (file-exists? l))
      (set! dist
        (string-replace (string-trim
                         (grep-first "PRETTY_NAME=" l)
                         "PRETTY_NAME=") "\"" "")
        )
      )
    (or dist
       "N/A (could not read '/bedrock/etc/os-release', '/etc/os-release', nor '/var/lib/os-release')"
       )
    )
  )

(define (get-distro-windows)
  (cmd->flat-str "ver")
  )


(define (get-distro os)
  (case os
    [("unix")     (get-distro-unix)]
    [("windows")  (get-distro-windows)]
    [else "Other"]
    )
  )
