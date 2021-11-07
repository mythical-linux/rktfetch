#!/usr/bin/env racket


#lang racket/base

(require
 racket/cmdline
 (only-in racket/format ~a)
 (only-in racket/list make-list)
 (only-in racket/os gethostname)
 (only-in racket/string string-join)
 "private/get.rkt"
 )


;; Return no less 0 VAL from difference between NUM1 and NUM2
(define (>0 num1 num2)
  (let ([res (- num1 num2)])
    (if (> res 0)  res  0)
    ))


(module+ main
  (let* (
         ;; Gather info
         [host    (make-parameter (gethostname))]
         [os      (make-parameter (get-os))]
         [shell   (make-parameter (get-shell))]
         [user    (make-parameter (get-user))]
         [cpu     (make-parameter (get-cpu     (os)))]
         [desktop (make-parameter (get-desktop (os)))]
         [device  (make-parameter (get-device  (os)))]
         [distro  (make-parameter (get-distro  (os)))]
         [editor  (make-parameter (get-editor  (os)))]
         [kernel  (make-parameter (get-kernel  (os)))]
         [memory  (make-parameter (get-memory  (os)))]
         [pkg     (make-parameter (get-pkg     (os)))]
         [uptime  (make-parameter (get-uptime  (os)))]
         ;; additional CLI parameters
         [do-logo (make-parameter #t)]
         [spacing (make-parameter "  ")]
         )
    (command-line
     #:program "RKTFetch"
     #:ps
     "Created by Mythical-Linux group,"
     "among others: XGQT, Phate6660 & DrownNotably"
     "Released into the Public Domain"
     "Upstream: https://github.com/mythical-linux/rktfetch"
     #:once-each
     ;; overwrite a detected component
     [("--cpu"    ) str "Force specified CPU"                    (cpu     str)]
     [("--desktop") str "Force specified desktop"                (desktop str)]
     [("--device" ) str "Force specified device"                 (device  str)]
     [("--distro" ) str "Force specified system distribution"    (distro  str)]
     [("--editor" ) str "Force specified file editor"            (editor  str)]
     [("--host"   ) str "Force specified host"                   (host    str)]
     [("--kernel" ) str "Force specified system kernel"          (kernel  str)]
     [("--memory" ) str "Force specified RAM amount"             (memory  str)]
     [("--os"     ) str "Force specified operating system"       (os      str)]
     [("--pkg"    ) str "Force specified packages count"         (pkg     str)]
     [("--shell"  ) str "Force specified login shell"            (shell   str)]
     [("--uptime" ) str "Force specified uptime"                 (uptime  str)]
     [("--user"   ) str "Force specified user"                   (user    str)]
     ;; additional CLI switches
     [("--no-logo")     "Don't display the logo"                 (do-logo  #f)]
     [("--spacing") num "Space between logo and info (natural number)"
                    (spacing (make-string (string->number num) #\space))]
     )
    (let* (
           ;; pick logo        (left side)
           [logo  (if (do-logo)  (get-logo (os) (distro))  '(""))]
           ;; create info side (right side)
           [info
            (list
             (string-append (user)  "@" (host)   )
             (string-append "CPU:     " (cpu)    )
             (string-append "DESKTOP: " (desktop))
             (string-append "DEVICE:  " (device) )
             (string-append "DISTRO:  " (distro) )
             (string-append "EDITOR:  " (editor) )
             (string-append "KERNEL:  " (kernel) )
             (string-append "PKGS:    " (pkg)    )
             (string-append "MEMORY:  " (memory) )
             (string-append "SHELL:   " (shell)  )
             (string-append "UPTIME:  " (uptime) )
             )
            ]
           ;; extend the length of logo side to the length of info side
           [logo-side
            (append logo (make-list (>0 (length info) (length logo)) ""))
            ]
           ;; extend the length of info side to the length of logo side
           [info-side
            (append info (make-list (>0 (length logo) (length info)) ""))
            ]
           ;; length of the longest string in the logo,
           ;; used to align the text in output-lst
           [logo-longest-size
            (string-length (car (sort logo #:key string-length >)))]
           [output-lst
            (map
             (lambda (left right)
               (string-append
                (~a left #:min-width logo-longest-size) (spacing) right
                ;;  ^ left element   ^ alignment        ^ spacing ^ right element
                ))
             logo-side info-side
             )]
           )
      ;; Output
      (displayln (string-join output-lst "\n"))
      )
    ))
