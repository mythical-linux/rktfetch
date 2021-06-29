#!/usr/bin/env racket


#lang racket/base

(require
 "helpers/basename.rkt"
 "helpers/cmd.rkt"
 (only-in "helpers/string.rkt" remove-strings)
 )

(provide get-editor)


(define (get-editor-unix)
  (let
      ([EDITOR (getenv "EDITOR")])
    (if EDITOR
        (string-titlecase (basename EDITOR))
        "N/A (could not read $EDITOR, make sure it is set)"
        )
    )
  )

(define (get-editor-windows)
  (remove-strings (cmd->flat-str "ftype textfile") '("textfile=" "\""))
  )


(define (get-editor os)
  (case os
    [("unix")  (get-editor-unix)]
    [("windows")  (get-editor-windows)]
    [else "N/A (your OS isn't supported)"])
  )
