#!/usr/bin/env racket


#lang racket/base


(require
 "helpers/basename.rkt"
 )

(provide get-shell)


(define (get-shell)
  (if (getenv "SHELL")
      (string-upcase (basename (getenv "SHELL")))
      "N/A (shell not set)"
      )
  )
