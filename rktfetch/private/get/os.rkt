#!/usr/bin/env racket


#lang racket/base

(provide get-os)


(define (get-os)
  (symbol->string (system-type 'os))
  )
