#!/usr/bin/env racket


#lang racket/base

(require
 racket/contract
 (only-in racket/list last)
 (only-in racket/string string-split)
 )

(provide (all-defined-out))


(define/contract (basename str)
  (-> path-string? string?)
  (last (string-split str "/"))
  )
