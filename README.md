# rktfetch

<p align="center">
    <a href="http://pkgs.racket-lang.org/package/rktfetch">
        <img src="https://img.shields.io/badge/raco_pkg_install-rktfetch-aa00ff.svg">
    <a href="https://github.com/mythical-linux/rktfetch/actions/workflows/ci.yml">
        <img src="https://github.com/mythical-linux/rktfetch/actions/workflows/ci.yml/badge.svg">
    </a>
</p>

rktfetch is an info fetch tool (like neofetch) but written in Racket.

## Usage
After you've installed racket, just run `racket rktfetch/main.rkt`.

There is also a Makefile, which contains the following targets:
- `run` (runs the program)
- `exe` (compiles an executable)
- `install` (install the program)
- `dist` (create a package for the program)
- `distclean` (remove the created package)
- `clean` (remove any compiles files and created packages)
- `remove` (removes the installed package)
- `purge` (run the `remove` and `clean` targets)

## Output
This is accurate as of the repo having 13 commits.

`$ racket rktfetch/main.rkt`:
```
valley@gentoo
CPU:     Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz
DESKTOP: leftwm
DEVICE:  OptiPlex 7010
DISTRO:  Gentoo/Linux
EDITOR:  Vim
KERNEL:  5.10.10-ck-VALLEY
MEMORY:  15966MB
SHELL:   BASH
UPTIME:  2d 8h 8m
```

## TODO
- CPU on Windows
- Device on Windows
- ~~Distro~~
- DE/WM (split the current WM output into an array delimited by spaces and take the last element)
- ~~Editor~~
- Memory (parse `/proc/meminfo`)
  + Used/Total
  + ~~Linux support~~
  + BSD support
- Music Info (MPD)
- ~~Packages~~
- Terminal
  + parse the `/proc/?/status` of the current PID
  + use it to find the PPID, parse the status of that
  + repeat until terminal found while applying exceptions where necessary
- Uptime (parse `/proc/uptime`)
  + ~~Linux support~~
  + BSD support
