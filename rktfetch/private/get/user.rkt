#!/usr/bin/env racket


#lang racket/base

(provide get-user)


(define (get-user)
  (or (getenv "USER")
     "nobody"
     )
  )
