#!/usr/bin/env racket


#lang racket/base

(require
 racket/contract
 (only-in racket/list last)
 (only-in racket/string string-split)
 )

(provide (all-defined-out))


(define/contract (basename path-str)
  (-> path-string? string?)
  (path->string (last (explode-path path-str)))
  )


(module+ test
  (require rackunit)
  (check-equal?  (basename "/")  "/")
  (check-equal?  (basename "/a")  "a")
  (check-equal?  (basename "/a/s/d")  "d")
  )
