#!/usr/bin/env racket


#lang racket/base


(require
 (only-in racket/string string-join)
 )

(provide get-pkg)


(define (get-pkgmanagers-unix)
  (let
      (
       [all  '#hash(
                    ["apk"        . "APK"]
                    ["dnf"        . "DNF"]
                    ["dpkg"       . "DPKG"]
                    ["emerge"     . "Portage"]
                    ["guix"       . "Guix"]
                    ["nix-env"    . "Nix"]
                    ["pacman"     . "Pacman"]
                    ["pkg"        . "PKG"]
                    ["rpm"        . "RPM"]
                    ["xbps-query" . "XBPS"]
                    ["yum"        . "YUM"]
                    ["zypper"     . "Zypper"]
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

(define (get-pkgmanager-unix)
  (let
      ([pms (get-pkgmanagers-unix)])
    (if (null? pms)
        "N/A (unknown package manager)"
        (string-join pms ", ")
        )
    )
  )

(define (get-pkg os)
  (case os
    [("unix")  (get-pkgmanager-unix)]
    [else "N/A (your OS isn't supported)"]
    )
  )
