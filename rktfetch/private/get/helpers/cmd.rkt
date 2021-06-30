#!/usr/bin/env racket


#lang racket/base

(require
 racket/contract
 (only-in racket/port with-output-to-string)
 (only-in racket/system system)
 (only-in "string.rkt" remove-newlines)
 )

(provide (all-defined-out))


(define/contract (cmd->flat-str command)
  (-> string? string?)
  (remove-newlines
   (with-output-to-string (lambda () (system command)))
   )
  )


(module+ test
  (require rackunit)
  (case (system-type)
    [(unix)     (check-not-false (cmd->flat-str "ls"))]
    [(windows)  (check-not-false (cmd->flat-str "dir"))]
    )
  ;; CONSIDER: Do all systems have echo?
  (check-equal?  (cmd->flat-str "echo ok")  "ok")
  )
