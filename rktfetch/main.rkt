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
;; CPU -- BSD
;; Device
;; Kernel -- BSD
;; Memory
;; Packages
;; Terminal
;; Uptime

;; Helper functions
(define (basename str)
  (last (string-split str "/"))
  )

(define (cmd->flat-str command)
  (remove-newlines
   (with-output-to-string (lambda () (system command)))
   )
  )

(define (remove-newlines str)
  (string-replace str "\n" "")
  )

;; Information gathering functions
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
      [else "N/A (could not read /proc/cpuinfo)"]
      )
    )
  )

(define (get-device)
  (let (
        [device-file-list '("/sys/devices/virtual/dmi/id/product_name" "/sys/firmware/devicetree/base/model")]
        [dev ""])
    (for ([dl device-file-list]
          #:when (file-exists? dl))
      (set! dev
        (remove-newlines (file->string dl))
        ))
    (if (non-empty-string? dev)
      dev
      "N/A (could not read '/sys/devices/virtual/dmi/id/product_name' nor '/sys/firmware/devicetree/base/model')"
      )
    )
  )

(define (get-distro)
  (let
      (
       [os-release-list '("/bedrock/etc/os-release" "/etc/os-release" "/var/lib/os-release")]
       [dist ""]
       )
    (for ([l os-release-list]
          #:when (file-exists? l))
      (set! dist
            (string-replace (string-trim (second (string-split (first (grep "PRETTY_NAME" l #:first #t)) "="))) "\"" "")
            )
      )
    (if (non-empty-string? dist)
        dist
        "N/A (could not read '/bedrock/etc/os-release', '/etc/os-release', nor '/var/lib/os-release')"
        )
    )
  )

(define (get-environment xinitrc)
  (cond
    [(getenv "XDG_DESKTOP_SESSION")]
    [(getenv "XDG_CURRENT_DESKTOP")]
    [(getenv "DESKTOP_SESSION")]
    [(file-exists? xinitrc) (last (string-split (last (file->lines xinitrc)) " "))]
    [else "N/A (could not read the specified env variables, nor could was parsing xinitrc possible"])
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
       [else "N/A (could not read '/proc/sys/kernel/osrelease' nor could run 'uname')"])
  )

;; Gather info and output
(let*
    (
     [user    (getenv "USER")]
     [host    (gethostname)]
     [os      (string-titlecase (symbol->string (system-type 'os)))]
     [kernel  (get-kernel os)]
     [shell   (string-upcase (basename (getenv "SHELL")))]
     [xinitrc (string-append (getenv "HOME") "/.xinitrc")]
     [desktop (get-environment xinitrc)]
     [cpu     (get-cpu)]
     [distro  (get-distro)]
     [device  (get-device)]
     )
  (display
   (string-append
    user "@" host       "\n"
    "CPU:     " cpu     "\n"
    "DESKTOP: " desktop "\n"
    "DEVICE:  " device  "\n"
    "DISTRO:  " distro  "\n"
    "KERNEL:  " kernel  "\n"
    "SHELL:   " shell   "\n"
    )
   )
  )
