#!/usr/bin/env racket


#lang racket/base

(require
 "helpers/cmd.rkt"
 (only-in "helpers/grep.rkt" grep-first)
 (only-in "helpers/is.rkt" file-is?)
 (only-in "helpers/string.rkt" remove-strings)
 )

(provide get-distro)


(define (pretty-name path)
  (remove-strings (grep-first "PRETTY_NAME=" path)
                  '("PRETTY_NAME=" "\"" " "))
  )


(define (get-distro-unix)
  (cond
    [(for/or ([f '("/bedrock/etc/os-release"
                   "/etc/os-release"
                   "/usr/lib/os-release"
                   "/var/lib/os-release")])
       (and (file-exists? f) (pretty-name f)))]
    [else  "N/A (could not read your distro)"]
    ))

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
