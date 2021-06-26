;; Information gathering functions


#lang racket/base

(require
 racket/file
 racket/list
 racket/string
 "helpers.rkt"
 )

(provide (all-defined-out) )


(define (get-os)
  (symbol->string (system-type 'os))
  )


(define (get-cpu)
  (let
      (
       [linux-info-file "/proc/cpuinfo"]
       )
    (cond
      [(file-exists? linux-info-file)
       (let*
           ([model-name (grep-first->str "model name" linux-info-file)])
         (cond
           [(non-empty-string? model-name) (string-trim
                                            (second (string-split model-name ":"))
                                            #:left? #t
                                            )
                                           ]
           [else "N/A (/proc/cpuinfo doesn't provide required information)"]
           )
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


(define (get-distro-unix)
  (let
      (
       [os-release-list '(
                          "/bedrock/etc/os-release"
                          "/etc/os-release"
                          "/var/lib/os-release"
                          )]
       [dist ""]
       )
    (for ([l os-release-list]
          #:when (file-exists? l))
      (set! dist
        (string-replace (string-trim
                         (grep-first->str "PRETTY_NAME=" l)
                         "PRETTY_NAME=") "\"" "")
        )
      )
    (if (non-empty-string? dist)
        dist
        "N/A (could not read '/bedrock/etc/os-release', '/etc/os-release', nor '/var/lib/os-release')"
        )
    )
  )

(define (get-distro-windows)
  (cmd->flat-str "ver")
  )

(define (get-distro os)
  (case os
    [("unix")     (get-distro-unix)]
    [("windows")  (get-distro-windows)]
    [else "Other"]
    )
  )


(define (get-editor)
  (let* (
         [editor-string (or (getenv "EDITOR")
                           "N/A (could not read $EDITOR, make sure it is set)"
                           )
                        ]
         )
    (if (string-prefix? editor-string "/")
        (string-titlecase (basename editor-string))
        (string-titlecase editor-string))
    )
  )


(define (get-environment)
  (let*
      (
       [xinitrc (or (getenv "XINITRC")
                   (if (getenv "HOME")
                       (string-append (getenv "HOME") "/.xinitrc")
                       "/root/.xinitrc"
                       )
                   )]
       [xinitrc-exists (file-exists? xinitrc)]
       )
    (cond
      [(getenv "XDG_DESKTOP_SESSION")]
      [(getenv "XDG_CURRENT_DESKTOP")]
      [(getenv "DESKTOP_SESSION")]
      [xinitrc-exists (last (string-split (last (file->lines xinitrc)) " "))]
      [else "N/A (could not read the specified env variables, nor could was parsing xinitrc possible)"])
    )
  )


(define (get-kernel-unix)
  (let
      ([linux-kernel-file "/proc/sys/kernel/osrelease"])
    (cond
      [(file-exists? linux-kernel-file)
       (remove-newlines  (file->string linux-kernel-file))
       ]
      [(cmd->flat-str "uname -r")]
      [else "N/A (could not read '/proc/sys/kernel/osrelease' nor could run 'uname')"]
      )
    )
  )

(define (get-kernel os)
  (case os
    [("unix")  (get-kernel-unix)]
    [else "N/A (your OS isn't supported)"])
  )


(define (get-memory-unix)
  (let
      (
       [linux-memory-file "/proc/meminfo"]
       )
    (cond
      [(file-exists? linux-memory-file)
       (let*
           ;; "memory-string" can be #f if we have given a string where a number
           ;; cannot be extracted to string->number
           ;; which can happen sometimes when attempting to parse /proc/meminfo
           ([memory-string (string->number
                            (first (string-split
                                    (string-trim
                                     (second (string-split
                                              (first (file->lines linux-memory-file))
                                              ":"
                                              ))
                                     #:left? #t
                                     )
                                    " "
                                    ))
                            )
                           ])
         (if (number? memory-string)
             (string-append (number->string (quotient memory-string 1024)) "MB")
             "N/A (misformatted /proc/meminfo?)"
             )
         )
       ]
      [else "N/A (could not parse /proc/meminfo)"]
      )
    )
  )

(define (get-memory os)
  (case os
    [("unix")  (get-memory-unix)]
    [else "N/A (your OS isn't supported)"])
  )


(define (get-pkgmanager-unix)
  (cond
    [(find-executable-path "apk")        "APK"]
    [(find-executable-path "dnf")        "DNF"]
    [(find-executable-path "dpkg")       "DPKG"]
    [(find-executable-path "emerge")     "Portage"]
    [(find-executable-path "guix")       "Guix"]
    [(find-executable-path "nix-env")    "Nix"]
    [(find-executable-path "pacman")     "Pacman"]
    [(find-executable-path "pkg")        "PKG"]
    [(find-executable-path "rpm")        "RPM"]
    [(find-executable-path "xbps-query") "XBPS"]
    [(find-executable-path "yum")        "YUM"]
    [(find-executable-path "zypper")     "Zypper"]
    [else "N/A (unknown package manager)"]
    )
  )

(define (get-pkgmanager os)
  (case os
    [("unix")  (get-pkgmanager-unix)]
    [else "N/A (your OS isn't supported)"]
    )
  )


(define (get-shell)
  (if (getenv "SHELL")
      (string-upcase (basename (getenv "SHELL")))
      "N/A (shell not set)"
      )
  )


(define (get-uptime-unix)
  (let
      ([linux-uptime-file "/proc/uptime"])
    (cond
      [(file-exists? linux-uptime-file)
       (seconds->time-str
        (string->number
         (first (string-split (remove-newlines (file->string linux-uptime-file)) "." #:trim? #t))
         )
        )
       ]
      [(cmd->flat-str "uptime -p")]
      )
    )
  )

(define (get-uptime os)
  (case os
    [("Unix")  (get-uptime-unix)]
    [else "N/A"]
    )
  )


(define (get-user)
  (or (getenv "USER")
     "nobody"
     )
  )
