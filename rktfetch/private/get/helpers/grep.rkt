#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/file file->lines)
 (only-in racket/string string-contains?)
 (only-in racket/contract define/contract -> ->*)
 (only-in racket/list
          empty?
          first
          )
 )

(provide (all-defined-out))


;; TODO: add keywords to control behavior
;; TODO: add regexp?

(define/contract (grep str file-name #:first-hit [first-hit #f])
  (->* (string? path-string?) (#:first-hit boolean?) list?)
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

(define/contract (grep-first->str str file-name)
  (-> string? path-string? string?)
  (let*
      ([grep-list (grep str file-name #:first-hit #t)])
    (if (empty? grep-list)
        ""
        (first grep-list)
        )
    )
  )


(module+ test
  (require rackunit)

  (check-equal?  (grep-first->str "lang" "./grep.rkt")  "#lang racket/base")
  )
