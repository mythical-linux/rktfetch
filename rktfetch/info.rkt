#!/usr/bin/env racket


#lang info


(define test-omit-paths
  '("scribblings"))

(define racket-launcher-names '("rktfetch"))
(define racket-launcher-libraries '("main.rkt"))

(define raco-commands
  '(("rktfetch" (submod rktfetch main) "display system informatiom" #f)))

(define scribblings
  '(("scribblings/rktfetch.scrbl"
     () (tool) "rktfetch")))
