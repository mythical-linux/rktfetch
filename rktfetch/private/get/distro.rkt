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
    [(file-is? "/bedrock/etc/os-release")  => pretty-name]
    [(file-is? "/etc/os-release")          => pretty-name]
    [(file-is? "/var/lib/os-release")      => pretty-name]
    [else  "N/A (could not read your distro)"]
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
