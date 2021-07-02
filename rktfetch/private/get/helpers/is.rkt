#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/string non-empty-string?)
 (only-in racket/contract
          ->
          any/c
          define/contract
          or/c
          )
 )

(provide (all-defined-out))


;; This is for cond, because proc? (boolean?, string?, etc.) return #t or #f


(define/contract (is? v proc?)
  (-> any/c procedure? any/c)
  (if (proc? v)  v  #f)
  )

(define/contract (file-is? path)
  (-> path-string? (or/c boolean? path-string?))
  (is? path file-exists?)
  )

(define/contract (directory-is? path)
  (-> path-string? (or/c boolean? path-string?))
  (is? path directory-exists?)
  )

(define/contract (nonempty-string-is? str)
  (-> string? (or/c boolean? path-string?))
  (is? str non-empty-string?)
  )
