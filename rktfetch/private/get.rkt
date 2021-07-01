#!/usr/bin/env racket


#lang racket/base

(require
 (only-in racket/contract/base contract-out ->)
 "get/cpu.rkt"
 "get/device.rkt"
 "get/distro.rkt"
 "get/editor.rkt"
 "get/desktop.rkt"
 "get/kernel.rkt"
 "get/memory.rkt"
 "get/os.rkt"
 "get/pkg.rkt"
 "get/shell.rkt"
 "get/uptime.rkt"
 "get/user.rkt"
 )

(provide
 (contract-out
  [get-desktop  (-> string?)]
  [get-device   (-> string?)]
  [get-os       (-> string?)]
  [get-shell    (-> string?)]
  [get-user     (-> string?)]
  [get-cpu      (-> string? string?)]
  [get-distro   (-> string? string?)]
  [get-editor   (-> string? string?)]
  [get-kernel   (-> string? string?)]
  [get-memory   (-> string? string?)]
  [get-pkg      (-> string? string?)]
  [get-uptime   (-> string? string?)]
  )
 )
