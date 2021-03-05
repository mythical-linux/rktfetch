#lang racket/base

(require racket/list)
(require racket/port)
(require racket/string)
(require racket/system)

(provide
 basename
 cmd->flat-str
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
