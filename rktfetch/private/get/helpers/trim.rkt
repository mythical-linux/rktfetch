#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/string string-trim)
 )

(provide (all-defined-out))


(define (trim str lst)
  (cond
    [(not (list? lst))  (error 'oops "Not a list")]
    [(null? lst)  str]
    [else  (trim (string-trim str (car lst) #:repeat? #t) (cdr lst))]
    )
  )

;; newlines:
;; - \n for UNIX
;; - \r for Mac
;; - \r\n for NT

(define (remove-newlines str)
  (trim str '("\n" "\r"))
  )


(module+ test
  (require rackunit)

  (check-equal?  (remove-newlines "zzz\n")  "zzz")
  (check-equal?  (remove-newlines "zzz\r\n")  "zzz")
  (check-equal?  (remove-newlines "zzz\r")  "zzz")
  )
