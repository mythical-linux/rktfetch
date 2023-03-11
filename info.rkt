#lang info


(define pkg-authors '(DrownNotably Phate6660 xgqt))

(define pkg-desc "System fetch program in Racket")

(define version "1.0")

(define license 'CC0-1.0)

(define collection 'multi)

(define deps
  '("base"))

(define build-deps
  '("racket-doc"
    "rackunit-lib"
    "scribble-lib"))
