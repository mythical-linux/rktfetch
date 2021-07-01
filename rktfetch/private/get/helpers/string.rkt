#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/string string-replace)
 (only-in racket/contract define/contract -> listof)
 )

(provide (all-defined-out))


(define/contract (string-remove str substr)
  (-> string? string? string?)
  (string-replace str substr "")
  )

(define/contract (remove-strings str lst)
  (-> string? (listof string?) string?)
  (cond
    [(null? lst)  str]
    [else  (remove-strings (string-remove str (car lst)) (cdr lst))]
    )
  )

;; newlines:
;; - \n for UNIX
;; - \r for Mac
;; - \r\n for NT

(define/contract (remove-newlines str)
  (-> string? string?)
  (remove-strings str '("\r\n" "\n" "\r"))
  )


(module+ test
  (require rackunit)

  (check-equal?  (remove-strings "1.123.124.125" '("1" "12"))  ".23.24.25")
  (check-equal?  (remove-strings "1.123.124.125" '("12" "1"))  ".3.4.5")

  (check-equal?  (remove-newlines "\nzz\nz\n")  "zzz")
  (check-equal?  (remove-newlines "\r\nzz\r\nz\r\n")  "zzz")
  (check-equal?  (remove-newlines "\rzz\rz\r")  "zzz")
  )
