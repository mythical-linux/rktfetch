#lang racket/base


(require racket/string)
(require racket/file)


(provide grep)


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
