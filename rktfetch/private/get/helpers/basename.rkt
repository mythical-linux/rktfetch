#!/usr/bin/env racket


#lang racket/base

(require
 racket/contract
 (only-in racket/list last)
 (only-in racket/string string-split)
 )

(provide (all-defined-out))


(define (basename str)
  (-> string? string?)
  (last (string-split str "/"))
  )
