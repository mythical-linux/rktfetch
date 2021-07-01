#!/usr/bin/env racket


#lang scribble/manual

@require[
         @only-in[scribble/bnf nonterm]
         @for-label[
                    rktfetch
                    racket/base
                    ]
         ]


@title{RKTFetch}

@author{Mythical Linux}


@section{About}

RKTFetch is a system fetch program in Racket.
It is heavily inspired by @exec{neofetch}


@section{rktfetch executable}

@commandline{rktfetch}


@section{Requiring the rktfetch module}

@defmodule[rktfetch]

Requiring the module is unnecessary, it is reccomended to run
@exec{rktfetch} via it's launcher instead.

But it can also be executed with @exec{racket -l rktfetch}


@section{Command-line interface}

@itemlist[
          @item{
                @DFlag{cpu} @nonterm{str}
                --- Force specified CPU
                }
          @item{
                @DFlag{desktop} @nonterm{str}
                --- Force specified desktop
                }
          @item{
                @DFlag{device} @nonterm{str}
                --- Force specified device
                }
          @item{
                @DFlag{distro} @nonterm{str}
                --- Force specified system distribution
                }
          @item{
                @DFlag{editor} @nonterm{str}
                --- Force specified file editor
                }
          @item{
                @DFlag{host} @nonterm{str}
                --- Force specified host
                }
          @item{
                @DFlag{kernel} @nonterm{str}
                --- Force specified system kernel
                }
          @item{
                @DFlag{memory} @nonterm{str}
                --- Force specified RAM amount
                }
          @item{
                @DFlag{os} @nonterm{str}
                --- Force specified operating system
                }
          @item{
                @DFlag{pkg} @nonterm{str}
                --- Force specified packages count
                }
          @item{
                @DFlag{shell} @nonterm{str}
                --- Force specified login shell
                }
          @item{
                @DFlag{uptime} @nonterm{str}
                --- Force specified uptime
                }
          @item{
                @DFlag{user} @nonterm{str}
                --- Force specified user
                }
          @item{
                @DFlag{no-logo}
                --- Don't display the logo
                }
          @item{
                @DFlag{spacing} @nonterm{num}
                --- Space between logo and info (natural number)
                }
          @item{
                @DFlag{help} or @Flag{h}
                --- Show help
                }
          ]
