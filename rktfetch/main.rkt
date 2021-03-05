#lang racket/base

;; (require racket/cmdline)
(require racket/string)
(require racket/file)
(require racket/list)
(require racket/os)
(require racket/port)
(require racket/system)
(require "private/grep.rkt")

;;; What we need:
;; CPU -- ARM Linux, BSD
;; Device
;; Distro
;; Kernel -- BSD
;; Memory
;; Packages
;; Terminal
;; Uptime
;;
;; Refactor codebase -- functional programming?

(define (basename str)
  (last (string-split str "/"))
  )

(define (remove-newlines str)
  (string-replace str "\n" "")
  )

(define (cmd->flat-str command)
  (remove-newlines
   (with-output-to-string (lambda () (system command)))
   )
  )

(define (get-cpu)
  (let
      (
       [linux-info-file "/proc/cpuinfo"]
       )
    (cond
      [(file-exists? linux-info-file)
       (string-trim
        (second (string-split (first (grep "model name" linux-info-file #:first #t)) ":"))
        #:left? #t
        )
       ]
      [else "N/A"]
      )
    )
  )

(define (get-kernel os)
     (case os
       [("Unix") (let (
                       [linux-kernel-file "/proc/sys/kernel/osrelease"]
                       )
                   (cond
                       [(file-exists? linux-kernel-file) (remove-newlines  (file->string linux-kernel-file))]
                       [(cmd->flat-str "uname -r")]
                       )
                   )]
       [else "N/A"])
  )

(define (get-environment xinitrc)
  (cond
    [(getenv "XDG_DESKTOP_SESSION")]
    [(getenv "XDG_CURRENT_DESKTOP")]
    [(getenv "DESKTOP_SESSION")]
    [(file-exists? xinitrc) (last (string-split (last (file->lines xinitrc)) " "))]
    [else "N/A"])
)

(let*
    (
     [user    (getenv "USER")]
     [host    (gethostname)]
     [os      (string-titlecase (symbol->string (system-type 'os)))]
     [kernel  (get-kernel os)]
     [shell   (string-upcase (basename (getenv "SHELL")))]
     [xinitrc (string-append (getenv "HOME") "/.xinitrc")]
     [desktop (get-environment xinitrc)]
     [cpu (get-cpu)]
     )
  (display
   (string-append
    user "@" host       "\n"
    "OS:      " os      "\n"
    "KERNEL:  " kernel  "\n"
    "SHELL:   " shell   "\n"
    "DESKTOP: " desktop "\n"
    "CPU:     " cpu     "\n"
    )
   )
  )
