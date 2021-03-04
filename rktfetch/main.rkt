#lang racket/base


;; (require racket/cmdline)
(require racket/string)
(require racket/file)
(require racket/list)
(require racket/os)


;;; What we need:
;; USER @ HOST
;; CPU
;; OS
;; KERNEL ( Win/NT / Linux running / Mach? )
;; Uptime
;; Packages
;; SHELL
;; DE/WM ?


(define (basename str)
  (last (string-split str "/"))
  )


(let*
    (
     [user    (getenv "USER")]
     [host    (gethostname)]
     [system  (string-titlecase (symbol->string (system-type 'os*)))]
     [shell   (string-upcase (basename (getenv "SHELL")))]
     [xinitrc (string-append (getenv "HOME") "/.xinitrc")]
     [desktop (cond
                [(getenv "XDG_DESKTOP_SESSION")]
                [(getenv "XDG_CURRENT_DESKTOP")]
                [(getenv "DESKTOP_SESSION")]
                [(file-exists? xinitrc) (last (file->lines xinitrc))]
                [else "N/A"]
                )
              ]
     )
  (display
   (string-append
    user "@" host       "\n"
    "OS:      " system  "\n"
    "SHELL:   " shell   "\n"
    "DESKTOP: " desktop "\n"
    )
   )
  )
