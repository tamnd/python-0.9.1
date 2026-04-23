---
title: Python 0.9.1
type: docs
---

# Python 0.9.1

Python 0.9.1 is the first public beta release of Python, uploaded by Guido van Rossum to alt.sources on February 20, 1991.

It predates classes (those came in 0.9.4), has no `list.append`, and only understands single-quoted strings. This fork patches the source to compile on modern macOS and Linux with no changes to the language or runtime behavior.

Here is how Guido described it at the time:

> This is Python, an extensible interpreted programming language that
> combines remarkable power with very clear syntax.
>
> Python can be used instead of shell, Awk or Perl scripts, to write
> prototypes of real applications, or as an extension language of large
> systems, you name it.
>
> — Guido van Rossum, CWI Amsterdam, 1991

## Quick Start

```sh
git clone https://github.com/tamnd/python-0.9.1
cd python-0.9.1/src
make python
./python
```

Then:

```
>>> print 'hello, 1991'
hello, 1991
```

Use single quotes only. Double-quoted strings do not exist in this version.

## Repositories

- [tamnd/python-0.9.1](https://github.com/tamnd/python-0.9.1) — this fork, patched to compile on modern macOS and Linux
- [smontanaro/python-0.9.1](https://github.com/smontanaro/python-0.9.1) — the original archive by Skip Montanaro that made this possible
