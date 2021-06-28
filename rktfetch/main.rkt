#!/usr/bin/env racket


#lang racket/base

(require
 racket/format
 racket/list
 racket/os
 racket/string
 ;; racket/cmdline - add this when we get to cmdline options
 "private/get.rkt"
 "private/logo.rkt"
 )


;;; What we need:
;; CPU -- BSD
;; Device
;; Kernel -- BSD
;; Memory
;; Packages
;; Terminal
;; Uptime -- BSD


(define (>- val num1 num2)
  "Return no less than VAL from difference between NUM1 and NUM2."
  (let
      ([res (- num1 num2)])
    (if (> res val) res val
        )
    )
  )


(module+ main
  ;; Gather info and output
  (let*
      (
       [user    (get-user)]
       [host    (gethostname)]
       [cpu     (get-cpu)]
       [desktop (get-environment)]
       [device  (get-device)]
       [editor  (get-editor)]
       [os      (get-os)]
       [distro  (get-distro os)]
       [kernel  (get-kernel os)]
       [memory  (get-memory os)]
       [pkg     (get-pkgmanager os)]
       [shell   (get-shell)]
       [uptime  (get-uptime os)]
       [logo
        (hash-ref system-logos os)
        ]
       [info
        (list
         (string-append user "@" host       "\n")
         (string-append "CPU:     " cpu     "\n")
         (string-append "DESKTOP: " desktop "\n")
         (string-append "DEVICE:  " device  "\n")
         (string-append "DISTRO:  " distro  "\n")
         (string-append "EDITOR:  " editor  "\n")
         (string-append "KERNEL:  " kernel  "\n")
         (string-append "PKGS:    " pkg     "\n")
         (string-append "MEMORY:  " memory  "\n")
         (string-append "SHELL:   " shell   "\n")
         (string-append "UPTIME:  " uptime  "\n")
         )
        ]
       [logo-side
        (append logo (make-list (>- 0 (length info) (length logo)) ""))
        ]
       [info-side
        (append info (make-list (>- 0 (length logo) (length info)) ""))
        ]
       [logo-longest-size
        (string-length (car (sort logo #:key string-length >)))
        ]
       )

    (display (string-join
              (map
               (lambda (left right)
                 (string-append
                  (~a left
                      #:min-width (- logo-longest-size (string-length left)))
                  "  " right
                  )
                 )
               logo-side info-side
               )
              ""
              )
             )

    )
  )
