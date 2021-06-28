#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/list last)
 (only-in racket/string string-split)
 )

(provide (all-defined-out))


(define (basename str)
  (last (string-split str "/"))
  )
