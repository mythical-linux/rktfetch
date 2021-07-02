#!/usr/bin/env racket


#lang racket/base


(require
 (only-in racket/format ~a)
 (only-in racket/string string-join)
 "helpers/cmd.rkt"
 )

(provide get-pkg)


(define (get-pkgmanagers-unix)
  (let
      (
       [all  '#hash(
                    ["apk"        . "APK"]
                    ["dpkg"       . "DPKG"]
                    ["emerge"     . "Portage"]
                    ["guix"       . "Guix"]
                    ["nix-env"    . "Nix"]
                    ["pacman"     . "Pacman"]
                    ["pkg_info"   . "PKG"]
                    ["rpm"        . "RPM"]
                    ["xbps-query" . "XBPS"]
                    )]
       [found '()]
       )
    (hash-for-each
     all
     (lambda (k v)
       (when (find-executable-path k)  (set! found (cons v found)))
       )
     )
    found
    )
  )

(define (cnt-out cmd)
  (cmd->flat-str (~a cmd " | wc -l"))
  )

(define (package-count-apk)
  (cnt-out "apk info")
  )

(define (package-count-dpkg)
  (cnt-out "dpkg-query -f '.\n' -W")
  )

(define (package-count-guix)
  (cnt-out "guix package --list-installed")
  )

(define (package-count-nix)
  (cnt-out "nix-store -q --requisites ~/.nix-profile")
  )

(define (package-count-pacman)
  (cnt-out "pacman -Qq")
  )

(define (package-count-pkg)
  (cnt-out "pkg_info")
  )

(define (package-count-portage)
  (apply + (map
            (λ (path)
              (length (filter (lambda (subdir)
                                (directory-exists? (build-path path subdir))
                                )
                              (directory-list path))))
            (directory-list "/var/db/pkg" #:build? #t)
            )
         )
  )

(define (package-count-rpm)
  (cnt-out "rpm -qa")
  )

(define (package-count-xbps)
  (cnt-out "xbps-query -l")
  )

;; this is a very cool magic trick ;P
(define ns (variable-reference->namespace (#%variable-reference)))

(define-syntax-rule (package-count pm)
  ((eval
    (string->symbol (string-append "package-count-" (string-downcase pm)))
    ns
    ))
  )

(define (get-pkgmanager-unix)
  (let
      ([pms (get-pkgmanagers-unix)])
    (if (null? pms)
        "N/A (unknown package manager)"
        (string-join
         (map (lambda (pm) (~a pm " (" (package-count pm) ")")) pms)
         ", "
         )
        )
    )
  )


(define (get-pkg os)
  (case os
    [("unix")  (get-pkgmanager-unix)]
    [else "N/A (your OS isn't supported)"]
    )
  )
