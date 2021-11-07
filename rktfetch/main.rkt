#!/usr/bin/env racket


#lang racket/base

(require
 racket/cmdline
 racket/promise
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

;; peek takes a single argument PARAM-PROC which is a parameter;
;; the content of PARAM-PROC is checked and if it is a promise,
;; that promise is forced
(define (peek param-proc)
  (let ([content (param-proc)])
    (if (promise? content)
        (force content)
        content
        )
    ))


(module+ main
  (let* (
         ;; Gather info
         [host    (make-parameter (gethostname))]
         [os      (make-parameter (get-os))]
         [shell   (make-parameter (delay/thread (get-shell)))]
         [user    (make-parameter (delay/thread (get-user)))]
         [cpu     (make-parameter (delay/thread (get-cpu     (os))))]
         [desktop (make-parameter (delay/thread (get-desktop (os))))]
         [device  (make-parameter (delay/thread (get-device  (os))))]
         [distro  (make-parameter (delay/thread (get-distro  (os))))]
         [editor  (make-parameter (delay/thread (get-editor  (os))))]
         [kernel  (make-parameter (delay/thread (get-kernel  (os))))]
         [memory  (make-parameter (delay/thread (get-memory  (os))))]
         [pkg     (make-parameter (delay/thread (get-pkg         )))]
         [uptime  (make-parameter (delay/thread (get-uptime  (os))))]
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
           [logo  (if (do-logo)  (get-logo (os) (peek distro))  '(""))]
           ;; create info side (right side)
           [header  (string-append (peek user) "@" (host))]
           [info
            (list
             header
             (make-string  (string-length header)  #\-)
             (string-append "CPU:     " (peek cpu)    )
             (string-append "DESKTOP: " (peek desktop))
             (string-append "DEVICE:  " (peek device) )
             (string-append "DISTRO:  " (peek distro) )
             (string-append "EDITOR:  " (peek editor) )
             (string-append "KERNEL:  " (peek kernel) )
             (string-append "PKGS:    " (peek pkg)    )
             (string-append "MEMORY:  " (peek memory) )
             (string-append "SHELL:   " (peek shell)  )
             (string-append "UPTIME:  " (peek uptime) )
             )]
           ;; extend the length of logo side to the length of info side
           [logo-side
            (append logo (make-list (>0 (length info) (length logo)) ""))]
           ;; extend the length of info side to the length of logo side
           [info-side
            (append info (make-list (>0 (length logo) (length info)) ""))]
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
