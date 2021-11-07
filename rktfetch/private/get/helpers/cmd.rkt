#!/usr/bin/env racket


#lang racket/base

(require
 racket/contract
 (only-in racket/port port->lines)
 (only-in racket/system process)
 )

(provide cmd->flat-str)


(define/contract (cmd->flat-str command)
  (-> string? string?)
  (apply string-append (port->lines (car (process command))))
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
