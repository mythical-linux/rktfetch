#!/usr/bin/env racket


#lang racket/base

(require
 ;; racket/cmdline - add this when we get to cmdline options
 (only-in racket/format ~a)
 (only-in racket/list make-list)
 (only-in racket/os gethostname)
 (only-in racket/string
          string-contains?
          string-join
          )
 "private/get.rkt"
 "private/logo.rkt"
 (only-in "private/get/helpers/string.rkt" string-remove)
 )


;;; What we need:
;; CPU -- BSD
;; Device
;; Kernel -- BSD
;; Memory
;; Packages
;; Terminal
;; Uptime -- BSD


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

(define (>- val num1 num2)
  "Return no less than VAL from difference between NUM1 and NUM2."
  (let
      ([res (- num1 num2)])
    (if (> res val) res val
        )
    )
  )


(module+ main
  (let*
      (
       ;; Gather info
       [cpu     (get-cpu)]
       [desktop (get-desktop)]
       [device  (get-device)]
       [host    (gethostname)]
       [os      (get-os)]
       [shell   (get-shell)]
       [user    (get-user)]
       [distro  (get-distro os)]
       [editor  (get-editor os)]
       [kernel  (get-kernel os)]
       [memory  (get-memory os)]
       [pkg     (get-pkg    os)]
       [uptime  (get-uptime os)]
       ;; pick logo        (left side)
       [logo    (get-logo   os distro)]
       ;; create info side (right side)
       [info
        (list
         (string-append user   "@"  host   )
         (string-append "CPU:     " cpu    )
         (string-append "DESKTOP: " desktop)
         (string-append "DEVICE:  " device )
         (string-append "DISTRO:  " distro )
         (string-append "EDITOR:  " editor )
         (string-append "KERNEL:  " kernel )
         (string-append "PKGS:    " pkg    )
         (string-append "MEMORY:  " memory )
         (string-append "SHELL:   " shell  )
         (string-append "UPTIME:  " uptime )
         )
        ]
       ;; extend the length of logo side to the length of info side
       [logo-side
        (append logo (make-list (>- 0 (length info) (length logo)) ""))
        ]
       ;; extend the length of info side to the length of logo side
       [info-side
        (append info (make-list (>- 0 (length logo) (length info)) ""))
        ]
       ;; length of the longest string in the logo,
       ;; used to align the text in output-lst
       [logo-longest-size
        (string-length (car (sort logo #:key string-length >)))
        ]
       [output-lst
        (map
         (lambda (left right)
           (string-append
            (~a left #:min-width logo-longest-size) "  " right
            ;;  ^ left element   ^ alignment   spacing ^ ^ right element
            )
           )
         logo-side info-side
         )
        ]
       )
    ;; Output
    (displayln (string-join output-lst "\n"))
    )
  )
