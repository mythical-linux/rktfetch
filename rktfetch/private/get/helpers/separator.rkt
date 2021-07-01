#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/contract define/contract listof ->)
 (only-in racket/list
          first
          last
          )
 (only-in racket/string
          string-split
          string-trim
          )
 )

(provide (all-defined-out))


(struct separated (before separator after) #:transparent)

(define/contract (string->separated str sep)
  (-> string? string? struct?)
  (cond
    [(equal? sep "")  (separated str "" str)]
    [(equal? str "")  (separated "" sep "")]
    [else  (let* (
                  [t (string-split str sep)]
                  [f (first t)]
                  [l (last t)]
                  )
             (separated (string-trim f) sep (string-trim l))
             )]
    )
  )

(define/contract (string->separated-before str sep)
  (-> string? string? string?)
  (separated-before (string->separated str sep))
  )

(define/contract (string->separated-after str sep)
  (-> string? string? string?)
  (separated-after (string->separated str sep))
  )


(module+ test
  (require rackunit)
  (check-equal?  (string->separated "" "")  (separated "" "" ""))
  (check-equal?  (string->separated "" "z")  (separated "" "z" ""))
  (check-equal?  (string->separated "z" "")  (separated "z" "" "z"))
  (check-equal?  (string->separated "asd" "s")  (separated "a" "s" "d"))
  (check-equal?  (string->separated "asd" "f")  (separated "asd" "f" "asd"))
  )
