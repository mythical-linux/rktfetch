#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/port with-output-to-string)
 (only-in racket/system system)
 (only-in "trim.rkt" remove-newlines)
 )

(provide (all-defined-out))


(define (cmd->flat-str command)
  (remove-newlines
   (with-output-to-string (lambda () (system command)))
   )
  )
