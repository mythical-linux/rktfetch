#lang racket/base

;; (require racket/cmdline)
(require racket/os)
(require "private/get.rkt")
(require "private/helpers.rkt")

;;; What we need:
;; CPU -- BSD
;; Device
;; Kernel -- BSD
;; Memory
;; Packages
;; Terminal
;; Uptime -- BSD

;; Gather info and output
(let*
    (
     [user    (getenv "USER")]
     [host    (gethostname)]
     [cpu     (get-cpu)]
     [distro  (get-distro)]
     [desktop (get-environment)]
     [device  (get-device)]
     [editor  (get-editor)]
     [os      (string-titlecase (symbol->string (system-type 'os)))]
     [kernel  (get-kernel os)]
     [memory  (get-memory os)]
     [shell   (get-shell)]
     [uptime  (get-uptime os)]
     )
  (display
   (string-append
    user "@" host       "\n"
    "CPU:     " cpu     "\n"
    "DESKTOP: " desktop "\n"
    "DEVICE:  " device  "\n"
    "DISTRO:  " distro  "\n"
    "EDITOR:  " editor  "\n"
    "KERNEL:  " kernel  "\n"
    "MEMORY:  " memory  "\n"
    "SHELL:   " shell   "\n"
    "UPTIME:  " uptime  "\n"
    )
   )
  )
