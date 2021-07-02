#!/usr/bin/env racket


#lang racket/base

(require
 (only-in "helpers/grep.rkt" first-line)
 (only-in "helpers/is.rkt" file-is?)
 )

(provide get-device)


(define (get-device-unix)
  (cond
    [(file-is? "/sys/devices/virtual/dmi/id/product_name") => first-line]
    [(file-is? "/sys/firmware/devicetree/base/model")      => first-line]
    [else  "N/A (could not get device)"]
    )
  )


(define (get-device os)
 (case os
    [("unix")  (get-device-unix)]
    [else  "N/A (your OS isn't supported)"]
    )
  )
