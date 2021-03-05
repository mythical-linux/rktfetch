# rktfetch
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
OS:      Unix
KERNEL:  5.10.10-ck-VALLEY
SHELL:   BASH
DESKTOP: leftwm
CPU:     Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz
```

## TODO
- CPU (parse `/proc/cpuinfo`)
  + ~~Linux support (generic)~~
  + ARM Linux support
  + BSD support
- Device 
  + read `/sys/devices/virtual/dmi/id/product_name`
  + then fallback to `/sys/firmware/devicetree/base/model`
- Distro 
  + parse `/bedrock/etc/os-release`
  + then fallback to `/etc/os-release`
  + then fallback to `/var/lib/os-release`
- DE/WM (split the current WM output into an array delimited by spaces and take the last element)
- Editor (get the contents of the `$EDITOR` environmental variable)
- Hostname 
  + read `/etc/hostname`
  + then fallback to `hostname`
- Memory (parse `/proc/meminfo`)
- Music Info (MPD)
- Packages
  + apk
  + dnf
  + dpkg
  + pkg
  + rpm
  + pacman
  + portage (*DON'T USE QLIST*, we should be able to use pure Racket code for this)
  + xbps
  + yum
  + zypper
- Terminal 
  + parse the `/proc/?/status` of the current PID
  + use it to find the PPID, parse the status of that
  + repeat until terminal found while applying exceptions where necessary
- Uptime (parse `/proc/uptime`)
