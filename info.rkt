#lang info


(define pkg-authors '(Mythical Linux))
(define pkg-desc "System fetch program in Racket")
(define version "0.0.0")

(define collection 'multi)
(define scribblings '(("scribblings/rktfetch.scrbl" ())))

(define deps
  '(
    "base"
    )
  )
(define build-deps
  '(
    "racket-doc"
    "rackunit-lib"
    "scribble-lib"
    )
  )
