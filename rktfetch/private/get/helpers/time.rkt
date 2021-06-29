#!/usr/bin/env racket


#lang racket/base

(require racket/contract)

(provide (all-defined-out))


(define/contract (seconds->time-str seconds)
  (-> number? string?)
  (let*
      (
       [minutes (modulo (quotient seconds 60) 60)]
       [hours   (modulo (quotient seconds (* 60 60)) 24)]
       [days            (quotient seconds (* 60 60 24))]
       )
    (if (= 0 days hours minutes)
        (string-append
         (number->string seconds) "s"
         )
        (string-append
         (number->string days)    "d" " "
         (number->string hours)   "h" " "
         (number->string minutes) "m" " "
         )
        )
    )
  )


(module+ test
  (require rackunit)

  (check-equal? "0d 0h 1m " (seconds->time-str 60))
  )
