#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/file file->lines)
 (only-in racket/string string-contains?)
 (only-in racket/list
          empty?
          first
          )
 )

(provide (all-defined-out))


;; TODO: add keywords to control behavior
;; TODO: add regexp?

(define (grep str file-name
              #:first [first-hit #f]
              )
  (let
      ([out '()])
    (for (
          [line (file->lines file-name)]
          #:when (case first-hit
                   [(#t) (<= (length out) 0)]
                   [else #t]
                   )
          )
      (when (string-contains? line str)
        (set! out (append out (list line)))
        )
      )
    out
    )
  )

(define (grep-first->str str file-name)
  (let*
      ([grep-list (grep str file-name #:first #t)])
    (if (empty? grep-list)
        ""
        (first grep-list)
        )
    )
  )
