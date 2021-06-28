#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/file file->string)
 "helpers/trim.rkt"
 )

(provide get-device)


(define (get-device)
  (let
      (
       [device-file-list '("/sys/devices/virtual/dmi/id/product_name" "/sys/firmware/devicetree/base/model")]
       [dev #f]
       )
    (for ([dl device-file-list]
          #:when (file-exists? dl))
      (set! dev  (remove-newlines (file->string dl)))
      )
    (or dev
       "N/A (could not read '/sys/devices/virtual/dmi/id/product_name' nor '/sys/firmware/devicetree/base/model')"
     )
    )
  )
