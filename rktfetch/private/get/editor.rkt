#!/usr/bin/env racket


#lang racket/base

(require
 "helpers/basename.rkt"
 )

(provide get-editor)


(define (get-editor)
  (let
      ([EDITOR (getenv "EDITOR")])
    (if EDITOR
        (string-titlecase (basename EDITOR))
        "N/A (could not read $EDITOR, make sure it is set)"
        )
    )
  )
