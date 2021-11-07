#!/usr/bin/env racket


#lang racket/base


(require
 (only-in racket/string string-join)
 (only-in racket/system process)
 (only-in racket/port port->lines)
 )

(provide get-pkg)


(define (cnt-out cmd)
  (length (port->lines (car (process cmd))))
  )


(define (package-count-portage)
  (apply +
         (map
          (λ (path)
            (length (filter
                     (lambda (subdir) (directory-exists? (build-path path subdir)))
                     (directory-list path)))
            )
          (directory-list "/var/db/pkg" #:build? #t)
          )
         ))


(define pkg-managers
  (hash
   "apk"        (hash 'brand "APK"      'counter (lambda () (cnt-out "apk info")))
   "dpkg"       (hash 'brand "DPKG"     'counter (lambda () (cnt-out "dpkg-query -f '.\n' -W")))
   "emerge"     (hash 'brand "Portage"  'counter package-count-portage)
   "guix"       (hash 'brand "Guix"     'counter (lambda () (cnt-out "guix package --list-installed")))
   "nix-env"    (hash 'brand "Nix"      'counter (lambda () (cnt-out "nix-store -q --requisites ~/.nix-profile")))
   "pacman"     (hash 'brand "Pacman"   'counter (lambda () (cnt-out "pacman -Qq")))
   "pkg_info"   (hash 'brand "PKG"      'counter (lambda () (cnt-out "pkg_info")))
   "rpm"        (hash 'brand "RPM"      'counter (lambda () (cnt-out "rpm -qa")))
   "xbps-query" (hash 'brand "XBPS"     'counter (lambda () (cnt-out "xbps-query -l")))
   ))


(define (get-pkg)
  (string-join
   (filter
    string?
    (hash-map
     pkg-managers
     (lambda (key val)
       (if (find-executable-path key)
           (let ([count ((hash-ref val 'counter))])
             (if (> count 0)
                 (format "~a (~a)" (hash-ref val 'brand) count)
                 #f))
           #f)
       )
     ))
   ", ")
  )
