#!/usr/bin/env racket


#lang racket/base

(require
 racket/os
 ;; racket/cmdline - add this when we get to cmdline options
 "private/get.rkt"
 )

;;; What we need:
;; CPU -- BSD
;; Device
;; Kernel -- BSD
;; Memory
;; Packages
;; Terminal
;; Uptime -- BSD

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
       [os      (string-titlecase (symbol->string (system-type 'os)))]
       [distro  (get-distro os)]
       [kernel  (get-kernel os)]
       [memory  (get-memory os)]
       [pkg     (get-pkgmanager os)]
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
      "PKGS:    " pkg     "\n"
      "MEMORY:  " memory  "\n"
      "SHELL:   " shell   "\n"
      "UPTIME:  " uptime  "\n"
      )
     )
    )
  )
