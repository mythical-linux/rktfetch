#!/usr/bin/env racket


#lang racket/base

(require
 "helpers/logos.rkt"
 (only-in "helpers/string.rkt" string-remove)
 (only-in racket/string string-contains?)
 )

(provide get-logo)


(define (get-logo os distro)
  (let
      (
       [dist (string-remove (string-downcase distro) "linux")]
       ;; initial logo
       [logo (if (string-contains? distro "linux")
                 (hash-ref system-logos "linux")
                 (case os
                   (("unix")    (hash-ref system-logos "unix"))
                   (("windows") (hash-ref system-logos "windows"))
                   (else        (hash-ref system-logos "other"))
                   )
                 )]
       )
    (for ([i (hash-keys system-logos)])
      (when (string-contains? dist i)
        (set! logo (hash-ref system-logos i))
        )
      )
    logo
    )
  )
