#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/format ~a)
 (only-in racket/string string-join)
 (only-in racket/contract
          define/contract
          ->
          )
 )

(provide (all-defined-out))


(define/contract (seconds->time-str seconds-num)
  (-> number? string?)
  (if (= seconds-num 0)
      "0s"
      (let*
          (
           [seconds (modulo seconds-num 60)]
           [minutes (modulo (quotient seconds-num 60) 60)]
           [hours   (modulo (quotient seconds-num (* 60 60)) 24)]
           [days            (quotient seconds-num (* 60 60 24))]
           [s       (if  (> seconds 0) (~a seconds "s")  #f)]
           [m       (if  (> minutes 0) (~a minutes "m")  #f)]
           [h       (if  (> hours   0) (~a hours   "h")  #f)]
           [d       (if  (> days    0) (~a days    "d")  #f)]
           )
        (string-join (filter string? (list d h m s)))
        )
      )
  )


(module+ test
  (require rackunit)

  (check-equal?  (seconds->time-str 0)  "0s")

  (define-values (1s 1m 1h 1d) (values 1 60 (* 60 60) (* 60 60 24)))
  (check-equal?  (seconds->time-str 1s)  "1s")
  (check-equal?  (seconds->time-str 1m)  "1m")
  (check-equal?  (seconds->time-str 1h)  "1h")
  (check-equal?  (seconds->time-str 1d)  "1d")
  (check-equal?  (seconds->time-str (+ 1h 1m))        "1h 1m")
  (check-equal?  (seconds->time-str (+ 1d 1h 1m))  "1d 1h 1m")

  (define-values (59s 59m 23h) (values 59 (* 59 60) (* 60 60 23)))
  (check-equal?  (seconds->time-str 59s)  "59s")
  (check-equal?  (seconds->time-str 59m)  "59m")
  (check-equal?  (seconds->time-str 23h)  "23h")
  (check-equal?  (seconds->time-str (+ 23h 59m 59s))  "23h 59m 59s")
  )
