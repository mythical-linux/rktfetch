#!/usr/bin/env racket


#lang racket/base

(require
 (only-in "helpers/grep.rkt" grep-first->str)
 (only-in "helpers/is.rkt" file-is?)
 )

(provide get-device)


(define (1st-line path)
  (grep-first->str "" path)
  )


(define (get-device-unix)
  (cond
    [(file-is? "/sys/devices/virtual/dmi/id/product_name") => 1st-line]
    [(file-is? "/sys/firmware/devicetree/base/model") => 1st-line]
    [else  "N/A (could not get device)"]
    )
  )


(define (get-device os)
 (case os
    [("unix")  (get-device-unix)]
    [else  "N/A (your OS isn't supported)"]
    )
  )
