#!/usr/bin/env racket


#lang racket/base


(require
 (only-in racket/file file->lines)
 (only-in racket/list last)
 (only-in racket/string string-split)
 (only-in "helpers/is.rkt" file-is?)
 )

(provide get-desktop)


(define (get-desktop-unix)
  (let* ([xinitrc (or (getenv "XINITRC")
                     (if (getenv "HOME")
                         (string-append (getenv "HOME") "/.xinitrc")
                         "/root/.xinitrc"
                         )
                     )])
    (cond
      [(getenv "XDG_DESKTOP_SESSION")]
      [(getenv "XDG_CURRENT_DESKTOP")]
      [(getenv "DESKTOP_SESSION")]
      [(file-is? xinitrc)
       => (lambda (f)
            (last (string-split (last (file->lines xinitrc)) " ")))]
      [else "N/A (could not get current desktop)"]
      )))


(define (get-desktop os)
  (case os
    [("unix")  (get-desktop-unix)]
    [else  "N/A (your OS isn't supported)"]
    ))
