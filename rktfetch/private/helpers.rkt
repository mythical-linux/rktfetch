#lang racket/base

(require racket/file)
(require racket/list)
(require racket/port)
(require racket/string)
(require racket/system)

(provide
 basename
 cmd->flat-str
 grep
 grep-first->str
 remove-newlines
 )

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

;; TODO: add keywords to control behavior
;; TODO: add regexp?
(define (grep str file-name
              #:first [first-hit #f]
              )
  (let
      ([out '()])
    (for (
          [line (file->lines file-name)]
          #:when (case first-hit
                   [(#t) (<= (length out) 0)]
                   [else #t]
                   )
          )
      (when (string-contains? line str)
        (set! out (append out (list line)))
        )
      )
    out
    )
  )

(define (grep-first->str str file-name)
  (let*
      ([grep-list (grep str file-name #:first #t)])
    (if (empty? grep-list)
        ""
        (first grep-list)
        )
    )
  )
