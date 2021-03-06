#lang racket/base

(require racket/file)
(require racket/list)
(require racket/string)
(require "helpers.rkt")

;; Provide the appropriate functions
(provide
 get-cpu
 get-distro
 get-environment
 get-device
 get-distro
 get-editor
 get-kernel
 get-memory
 get-uptime
 )

;; Information gathering functions
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

(define (get-distro)
  (let
      (
       [os-release-list '("/bedrock/etc/os-release" "/etc/os-release" "/var/lib/os-release")]
       [dist ""]
       )
    (for ([l os-release-list]
          #:when (file-exists? l))
      (set! dist
            (string-replace (string-replace (grep-first->str "PRETTY_NAME=" l) "PRETTY_NAME=" "") "\"" "")
            )
      )
    (if (non-empty-string? dist)
        dist
        "N/A (could not read '/bedrock/etc/os-release', '/etc/os-release', nor '/var/lib/os-release')"
        )
    )
  )

(define (get-editor)
  (let* (
         [editor-string (if (getenv "EDITOR")
                            (getenv "EDITOR")
                            "N/A (could not read $EDITOR, make sure it is set)"
                            )
                        ]
         )
    (if (string-prefix? editor-string "/")
        (string-titlecase (basename editor-string))
        (string-titlecase editor-string))
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
                       [else "N/A (could not read '/proc/sys/kernel/osrelease' nor could run 'uname')"]
                       )
                   )]
       [else "N/A (your OS isn't supported)"])
  )

(define (get-memory os)
  (case os
    [("Unix")
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
     ]
    [else "N/A (your OS isn't supported)"])
  )

(define (seconds->time-str seconds)
  (let*
      (
       [minutes (modulo (quotient seconds 60) 60)]
       [hours   (modulo (quotient seconds (* 60 60)) 24)]
       [days            (quotient seconds (* 60 60 24))]
       )
    (if (= 0 days hours minutes)
        (string-append
         (number->string seconds) "s"
         )
        (string-append
         (number->string days)    "d" " "
         (number->string hours)   "h" " "
         (number->string minutes) "m" " "
         )
        )
    )
  )

(define (get-uptime os)
  (case os
    [("Unix") (let (
                    [linux-uptime-file "/proc/uptime"]
                    )
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
              ]
    [else "N/A"]
    )
  )
