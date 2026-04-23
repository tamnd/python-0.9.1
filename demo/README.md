# Demo scripts

The original README is preserved as `README.old`.

These scripts were written by Guido van Rossum in 1991 for his SGI IRIS
workstation. Most of them require modules that were never built into the
portable version of the interpreter (`stdwin`, `gl`, `audio`, `panel`),
or they hit a 64-bit integer multiplication bug that exists in the
Python 0.9.1 runtime.

Tested on macOS 15 / Apple clang 17 and Debian bookworm / GCC 12
(via podman). Results are the same on both platforms.

---

## scripts/

### suff.py -- works

Groups a list of files by their suffix and counts them.

    cd src
    ./python ../demo/scripts/suff.py ../demo/scripts/*.py

Output:

    '.py' 5

That is about it for working demos. Everything else below is broken
for one reason or another.

---

### ptags.py -- broken

Creates a ctags-style index for Python source files. Fails at runtime
with:

    type error: string member test needs char left operand

The `in` operator in Python 0.9.1 only accepts a single character on
the left side when testing membership in a string. The line
`while line[i:i+1] in whitespace` passes a one-character slice, which
should work, but the runtime rejects it. This is a bug in the 0.9.1
runtime itself.

---

### findlinksto.py -- broken

Walks a directory tree and prints symbolic links that point to a given
prefix. Crashes with integer overflow inside `path.ismount()`, which
calls `commands.getoutput('/etc/mount')` and then does arithmetic on
the result. The 64-bit integer multiplication overflow bug in 0.9.1
hits here.

---

### mkreal.py -- broken

Replaces a symlink to a directory with a real copy. Fails immediately
at startup:

    BUFSIZE = 32*1024

`32 * 1024 = 32768`, which should be fine, but Python 0.9.1's integer
multiplication overflow check was written for 32-bit platforms. On
64-bit, the check compares against `(double)(long)0x80000000`, which
evaluates to `+2147483648.0` instead of `-2147483648.0`, making the
condition always true. Every multiplication overflows.

---

### xxci.py -- broken

Checks files into RCS if `rcsdiff` returns nonzero. Same overflow as
above, hits on `MAXSIZE = 200*1024`.

---

## stdwin/

### wdiff.py -- broken (missing module)

A windowed recursive diff tool. Requires the `stdwin` module, which
needs the STDWIN X11 library from 1990. Not built in the portable
configuration.

---

## sgi/

All scripts under `sgi/` require hardware and modules that were only
ever available on Silicon Graphics IRIS workstations: `gl`, `panel`,
and `audio`. None of them will run on modern systems.

- `sgi/gl/` -- needs the `gl` module (SGI OpenGL predecessor)
- `sgi/gl_panel/` -- needs `gl` + `panel`
- `sgi/audio/` -- needs the `audio` module (`/dev/audio` on IRIS)
- `sgi/audio_stdwin/` -- needs `audio` + `stdwin`

---

## Notes

The shebang line in most scripts reads:

    #! /ufs/guido/bin/sgi/python

That was Guido's home directory path on the CWI SGI machine. Run them
as `./python ../demo/scripts/foo.py` instead.

Python 0.9.1 uses single-quoted strings only. Double quotes are not
part of the language yet.
