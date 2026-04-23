# Python 0.9.1

> [!NOTE]
> This is Python 0.9.1, the first public beta release, written by Guido van Rossum in 1991. The source is preserved as-is. This fork patches it to compile on modern macOS and Linux with no changes to the language or runtime behavior.

Guido uploaded this to alt.sources on February 20, 1991. It predates classes (those came in 0.9.4), has no `list.append`, and only understands single-quoted strings. It is a fully working Python interpreter you can build and run today.

## Build

### macOS

```sh
cd src
make python
./python
```

Requires Xcode Command Line Tools (`xcode-select --install`). Tested on macOS 15 with Apple clang 17.

### Linux (Docker / Podman)

```sh
# podman works too, just swap the command
docker build -t python091 .
docker run --rm -it python091
```

Tested on Debian bookworm inside Podman on macOS.

## Run

```
>>> print 'hello, 1991'
hello, 1991
>>> 1 + 1
2
>>> def fact(n): return 1 if n <= 1 else n * fact(n-1)
```

> [!WARNING]
> Double-quoted strings do not exist in this version. Use single quotes only.

## What works, what doesn't

The interpreter itself is solid. The demo scripts are a mixed bag:

| Script | Status | Reason |
|---|---|---|
| `demo/suff.py` | Works | Basic string ops, no deps |
| `demo/ptags.py` | Broken | `in` operator bug on string membership |
| `demo/mkreal.py` | Broken | 64-bit integer overflow in the runtime |
| `demo/xxci.py` | Broken | Same overflow |
| `demo/findlinksto.py` | Broken | Same overflow |
| `demo/stdwin/wdiff.py` | Broken | Requires STDWIN (1991 window toolkit) |
| `demo/sgi/*` | Broken | SGI IRIX hardware only |

The overflow bug: `intobject.c` checks for multiplication overflow using `(long)0x80000000`, which on a 64-bit system is +2147483648 instead of -2147483648. Every multiplication involving large constants triggers a false overflow. It's a known 32-bit assumption, not a fix we applied.

See [`demo/README.md`](demo/README.md) for full notes.

## What changed from the original

Three minimal patches to compile on modern toolchains:

1. **`src/Makefile`** -- added `-std=gnu89 -w -Wno-incompatible-function-pointer-types -DSIGTYPE=void` to CFLAGS and dropped a hardcoded SGI path from DEFPYTHONPATH
2. **`src/ceval.h`** -- added missing `flushline()` declaration (called in `bltinmodule.c`, never declared)
3. **`src/bltinmodule.c`** -- added `#include "fgetsintr.h"` (called `fgets_intr()` without the header)

Nothing in the language, bytecode, or standard library was touched. See [`Dockerfile`](Dockerfile) for the Linux build recipe.

## Docs

The original LaTeX documentation is in [`doc/`](doc/). A readable Markdown version converted from all the `.tex` files is at [`doc/README.md`](doc/README.md).

There is also a Unix man page at [`python.man`](python.man).

## Original README

Guido's original note is preserved at [`README.old`](README.old).

## License

CWI 1991 open source license. See [`LICENSE`](LICENSE).
