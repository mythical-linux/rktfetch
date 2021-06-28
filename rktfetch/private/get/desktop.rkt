#!/usr/bin/env racket


#lang racket/base


(require
 (only-in racket/file file->lines)
 (only-in racket/list last)
 (only-in racket/string string-split)
 )

(provide get-desktop)


(define (get-desktop)
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
