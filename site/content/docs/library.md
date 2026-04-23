---
title: "Library Reference"
weight: 2
---

# Part 2: Python Library Reference (DRAFT)

**Author:** Guido van Rossum  
Dept. CST, CWI, Kruislaan 413  
1098 SJ Amsterdam, The Netherlands  
E-mail: guido@cwi.nl

This document describes the built-in types, exceptions and functions and
the standard modules that come with the Python system. It assumes basic
knowledge about the Python language. For an informal introduction to the
language, see Part 1 (Tutorial). The Language Reference document (XXX not
yet existing) gives a more formal reference to the language.

The Python library consists of three parts, with different levels of
integration with the interpreter. Closest to the interpreter are built-in
types, exceptions and functions. Next are built-in modules, which are
written in C and linked statically with the interpreter. Finally there are
standard modules that are implemented entirely in Python, but are always
available.


## 1. Built-in Types, Exceptions and Functions

Names for built-in exceptions and functions are found in a separate
read-only symbol table which cannot be modified. This table is searched
last, so local and global user-defined names can override built-in names.
Built-in types have no names but are created by syntactic constructs
(such as constants) or built-in functions.

### Built-in Types

#### Numeric Types

There are two numeric types: integers and floating point numbers. Integers
are implemented using `long` in C, so they have at least 32 bits of
precision. Floating point numbers are implemented using `double` in C.

Numeric types support the following operations:

| Operation | Result | Notes |
|-----------|--------|-------|
| `abs(x)` | absolute value of x | |
| `int(x)` | x converted to integer | (1) |
| `float(x)` | x converted to floating point | |
| `-x` | x negated | |
| `+x` | x unchanged | |
| `x+y` | sum of x and y | |
| `x-y` | difference of x and y | |
| `x*y` | product of x and y | |
| `x/y` | quotient of x and y | (2) |
| `x%y` | remainder of x/y | (3) |

Notes:

1. This may round or truncate as in C; see functions `floor` and `ceil` in module `math`.
2. Integer division is defined as in C: the result is an integer; with positive operands, it truncates towards zero; with a negative operand, the result is unspecified.
3. Only defined for integers.

Mixed arithmetic is not supported; both operands must have the same type.

#### Sequence Types

There are three sequence types: strings, lists and tuples. String constants
are written in single quotes: `'xyzzy'`. Lists are constructed with square
brackets: `[a, b, c]`. Tuples are constructed by the comma operator or
with an empty set of parentheses: `a, b, c` or `()`.

Sequence types support the following operations (s and t are sequences of
the same type; n, i and j are integers):

| Operation | Result | Notes |
|-----------|--------|-------|
| `len(s)` | length of s | |
| `min(s)` | smallest item of s | |
| `max(s)` | largest item of s | |
| `x in s` | true if an item of s is equal to x | |
| `x not in s` | false if an item of s is equal to x | |
| `s+t` | concatenation of s and t | |
| `s*n`, `n*s` | n copies of s concatenated | (1) |
| `s[i]` | i'th item of s | |
| `s[i:j]` | slice of s from i to j | (2) |

Notes:

1. Sequence repetition is only supported for strings.
2. The slice of s from i to j is defined as the sequence of items with index k such that i <= k < j.

**Mutable Sequence Types**

List objects support additional operations that allow in-place modification:

| Operation | Result |
|-----------|--------|
| `s[i] = x` | item i of s is replaced by x |
| `s[i:j] = t` | slice of s from i to j is replaced by t |
| `del s[i:j]` | same as `s[i:j] = []` |
| `s.append(x)` | same as `s[len(s):len(s)] = [x]` |
| `s.insert(i, x)` | same as `s[i:i] = [x]` |
| `s.sort()` | the items of s are permuted to satisfy s[i] <= s[j] for i < j |

#### Mapping Types

A *mapping* object maps values of one type (the key type) to arbitrary
objects. There is currently only one mapping type, the *dictionary*. A
dictionary's keys are strings. An empty dictionary is created by the
expression `{}`.

The following operations are defined on mappings (where a is a mapping, k
is a key and x is an arbitrary object):

| Operation | Result | Notes |
|-----------|--------|-------|
| `len(a)` | the number of elements in a | |
| `a[k]` | the item of a with key k | |
| `a[k] = x` | set a[k] to x | |
| `del a[k]` | remove a[k] from a | |
| `a.keys()` | a copy of a's list of keys | (1) |
| `a.has_key(k)` | true if a has a key k | |

Notes:

1. Keys are listed in random order.

A small example using a dictionary:

```
>>> tel = {}
>>> tel['jack'] = 4098
>>> tel['sape'] = 4139
>>> tel['guido'] = 4127
>>> tel['jack']
4098
>>> tel
{'sape': 4139; 'guido': 4127; 'jack': 4098}
>>> del tel['sape']
>>> tel['irv'] = 4127
>>> tel
{'guido': 4127; 'irv': 4127; 'jack': 4098}
>>> tel.keys()
['guido', 'irv', 'jack']
>>> tel.has_key('guido')
1
```

#### Other Built-in Types

**Modules**

The only operation on a module is member access: `m.name`, where m is a
module and name accesses a name defined in m's symbol table. Module
members can be assigned to.

**Classes and Class Objects**

XXX Classes will be explained at length in a later version of this
document.

**Functions**

Function objects are created by function definitions. The only operation
on a function object is to call it: `func(optional-arguments)`.

Built-in functions have a different type than user-defined functions, but
they support the same operation.

**Methods**

Methods are functions that are called using the member access notation.
There are two flavors: built-in methods (such as `append()` on lists) and
class member methods.

**Type Objects**

Type objects represent the various object types. An object's type is
accessed by the built-in function `type()`. There are no operations on
type objects.

**The Null Object**

This object is returned by functions that don't explicitly return a value.
It supports no operations. There is exactly one null object, named `None`
(a built-in name).

**File Objects**

File objects are implemented using C's *stdio* package and can be created
with the built-in function `open()`. They have the following methods:

- **`close()`** -- closes the file. A closed file cannot be read or written anymore.
- **`read(size)`** -- reads at most `size` bytes from the file. The bytes are returned as a string object. An empty string is returned when EOF is hit immediately.
- **`readline(size)`** -- reads a line of at most `size` bytes from the file. A trailing newline character, if present, is kept in the string. The size is optional.
- **`write(str)`** -- writes a string to the file. Returns no value.

### Built-in Exceptions

The following exceptions can be generated by the interpreter or built-in
functions. Except where mentioned, they have a string argument indicating
the detailed cause of the error.

- **`EOFError = 'end-of-file read'`** -- (No argument.) Raised when a built-in function (`input()` or `raw_input()`) hits an end-of-file condition without reading any data.
- **`KeyboardInterrupt = 'end-of-file read'`** -- (No argument.) Raised when the user hits the interrupt key (normally Control-C or DEL).
- **`MemoryError = 'out of memory'`** -- Raised when an operation runs out of memory but the situation may still be rescued (by deleting some objects).
- **`NameError = 'undefined name'`** -- Raised when a name is not found. The string argument is the name that could not be found.
- **`RuntimeError = 'run-time error'`** -- Raised for a variety of reasons, e.g., division by zero or index out of range.
- **`SystemError = 'system error'`** -- Raised when the interpreter finds an internal error, but the situation does not look so serious to cause it to abandon all hope.
- **`TypeError = 'type error'`** -- Raised when an operation or built-in function is applied to an object of inappropriate type.

### Built-in Functions

The Python interpreter has a small number of functions built into it that
are always available. Listed here in alphabetical order:

- **`abs(x)`** -- returns the absolute value of a number. The argument may be an integer or floating point number.

- **`chr(i)`** -- returns a string of one character whose ASCII code is the integer `i`, e.g., `chr(97)` returns the string `'a'`. This is the inverse of `ord()`.

- **`dir()`** -- without arguments, returns the list of names in the current local symbol table, sorted alphabetically. With a module object as argument, returns the sorted list of names in that module's global symbol table:
  ```
  >>> import sys
  >>> dir()
  ['sys']
  >>> dir(sys)
  ['argv', 'exit', 'modules', 'path', 'stderr', 'stdin', 'stdout']
  ```

- **`divmod(a, b)`** -- takes two integers as arguments and returns a pair of integers consisting of their quotient and remainder. For `q, r = divmod(a, b)`, the invariants are: `a = q*b + r`, `abs(r) < abs(b)`, r has the same sign as b:
  ```
  >>> divmod(100, 7)
  (14, 2)
  >>> divmod(-100, 7)
  (-15, 5)
  ```

- **`eval(s)`** -- takes a string as argument and parses and evaluates it as a Python expression:
  ```
  >>> x = 1
  >>> eval('x+1')
  2
  ```

- **`exec(s)`** -- takes a string as argument and parses and evaluates it as a sequence of Python statements. The string should end with a newline (`'\n'`):
  ```
  >>> x = 1
  >>> exec('x = x+1\n')
  >>> x
  2
  ```

- **`float(x)`** -- converts a number to floating point.

- **`input(s)`** -- equivalent to `eval(raw_input(s))`. The argument is optional.

- **`int(x)`** -- converts a number to integer.

- **`len(s)`** -- returns the length (the number of items) of an object. The argument may be a sequence (string, tuple or list) or a mapping (dictionary).

- **`max(s)`** -- returns the largest item of a non-empty sequence.

- **`min(s)`** -- returns the smallest item of a non-empty sequence.

- **`open(name, mode)`** -- returns a file object. The string arguments are the same as for stdio's `fopen()`: `'r'` opens the file for reading, `'w'` opens it for writing (truncating an existing file), `'a'` opens it for appending.

- **`ord(c)`** -- takes a string of one character and returns its ASCII value, e.g., `ord('a')` returns the integer `97`. This is the inverse of `chr()`.

- **`range()`** -- creates lists containing arithmetic progressions of integers:
  ```
  >>> range(10)
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  >>> range(1, 1+10)
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  >>> range(0, 30, 5)
  [0, 5, 10, 15, 20, 25]
  >>> range(0, -10, -1)
  [0, -1, -2, -3, -4, -5, -6, -7, -8, -9]
  >>> range(0)
  []
  ```

- **`raw_input(s)`** -- the argument is optional; if present, it is written to standard output without a trailing newline. The function then reads a line from input:
  ```
  >>> raw_input('Type anything: ')
  Type anything: Mutant Teenage Ninja Turtles
  'Mutant Teenage Ninja Turtles'
  ```

- **`reload(module)`** -- causes an already imported module to be re-parsed and re-initialized. Useful if you have edited the module source file.

- **`type(x)`** -- returns the type of an object.


## 2. Built-in Modules

The modules described in this section are built into the interpreter.
They must be imported using `import`. Some modules are not always
available; it is a configuration option to provide them.

### Module `sys`

This module provides access to some variables used or maintained by the
interpreter and to functions that interact strongly with the interpreter.
It is always available.

- **`argv`** -- the list of command line arguments passed to a Python script. `sys.argv[0]` is the script name. If no script name was passed, `sys.argv` is empty.
- **`exit(n)`** -- exits from Python with numeric exit status `n`. This closes all open files and performs other cleanup actions (but `finally` clauses of `try` statements are not executed).
- **`modules`** -- gives the list of modules that have already been loaded.
- **`path`** -- a list of strings that specifies the search path for modules. Initialized from `PYTHONPATH`, or an installation-dependent default.
- **`ps1`, `ps2`** -- strings specifying the primary and secondary prompt of the interpreter. Only defined if the interpreter is in interactive mode. Initial values are `'>>> '` and `'... '`.
- **`stdin`, `stdout`, `stderr`** -- file objects corresponding to the interpreter's standard input, output and error streams.

### Module `math`

This module is always available. It provides access to the mathematical
functions defined by the C standard. They are: `acos(x)`, `asin(x)`,
`atan(x)`, `atan2(x,y)`, `ceil(x)`, `cos(x)`, `cosh(x)`, `exp(x)`,
`fabs(x)`, `floor(x)`, `log(x)`, `log10(x)`, `pow(x,y)`, `sin(x)`,
`sinh(x)`, `sqrt(x)`, `tan(x)`, `tanh(x)`.

It also defines two mathematical constants: `pi` and `e`.

### Module `time`

This module provides various time-related functions. It is always
available.

- **`sleep(secs)`** -- suspends execution for the given number of seconds.
- **`time()`** -- returns the time in seconds since the Epoch (Thursday January 1, 00:00:00, 1970 UCT on Unix machines).

In some versions (Amoeba, Mac) the following functions also exist:

- **`millisleep(msecs)`** -- suspends execution for the given number of milliseconds.
- **`millitimer()`** -- returns the number of milliseconds of real time elapsed since some point in the past that is fixed per execution of the python interpreter.

The granularity of the milliseconds functions may be more than a
millisecond (100 msecs on Amoeba, 1/60 sec on the Mac).

### Module `regexp`

This module provides a regular expression matching operation. It is always
available. The module defines a function and an exception:

- **`compile(pattern)`** -- compile a regular expression given as a string into a regular expression object. The string must be an egrep-style regular expression; the characters `( ) * + ? | ^ $` are special. (Implemented using Henry Spencer's regular expression matching functions.)

- **`error = 'regexp.error'`** -- exception raised when a string passed to `compile()` is not a valid regular expression or when some other error occurs during compilation or matching.

Compiled regular expression objects support a single method:

- **`exec(str)`** -- find the first occurrence of the compiled regular expression in the string `str`. The return value is a tuple of pairs specifying where a match was found and where matches were found for subpatterns. If no match is found, an empty tuple is returned.

Example:

```
>>> import regexp
>>> r = regexp.compile('--(.*)--')
>>> s = 'a--b--c'
>>> r.exec(s)
((1, 6), (3, 4))
>>> s[1:6] # The entire match
'--b--'
>>> s[3:4] # The subpattern
'b'
```

### Module `posix`

This module provides access to operating system functionality that is
standardized by the C Standard and the POSIX standard. It is available in
all Python versions except on the Macintosh. Errors are reported as
exceptions.

- **`chdir(path)`** -- changes the current directory to `path`.
- **`chmod(path, mode)`** -- change the mode of `path` to the numeric `mode`.
- **`environ`** -- a dictionary representing the string environment at the time the interpreter was started. For example, `posix.environ['HOME']` is the pathname of your home directory.
- **`error = 'posix.error'`** -- the exception raised when a POSIX function returns an error. The value is a pair containing the numeric error code from `errno` and the corresponding string.
- **`getcwd()`** -- returns a string representing the current working directory.
- **`link(src, dst)`** -- creates a hard link pointing to `src` named `dst`.
- **`listdir(path)`** -- returns a list containing the names of the entries in the directory. The list is in arbitrary order. It includes the special entries `'.'` and `'..'` if they are present.
- **`mkdir(path, mode)`** -- creates a directory named `path` with numeric mode `mode`.
- **`rename(src, dst)`** -- renames the file or directory `src` to `dst`.
- **`rmdir(path)`** -- removes the directory `path`.
- **`stat(path)`** -- performs a *stat* system call on the given path. The return value is a tuple of at least 10 integers giving the most important members of the *stat* structure, in the order: `st_mode`, `st_ino`, `st_dev`, `st_nlink`, `st_uid`, `st_gid`, `st_size`, `st_atime`, `st_mtime`, `st_ctime`.
- **`system(command)`** -- executes the command (a string) in a subshell. The return value is the exit status of the process.
- **`umask(mask)`** -- sets the current numeric umask and returns the previous umask.
- **`unlink(path)`** -- unlinks the file `path`.
- **`utimes(path, (atime, mtime))`** -- sets the access and modified time of the file to the given values.

The following functions are only available on systems that support
symbolic links:

- **`lstat(path)`** -- like `stat()`, but does not follow symbolic links.
- **`readlink(path)`** -- returns a string representing the path to which the symbolic link points.
- **`symlink(src, dst)`** -- creates a symbolic link pointing to `src` named `dst`.

### Module `stdwin`

This module defines several new object types and functions that provide
access to the functionality of the Standard Window System Interface,
STDWIN [CWI report CR-R8817]. It is available on systems to which STDWIN
has been ported. It is only available if the `DISPLAY` environment
variable is set or an explicit `-display displayname` argument is passed
to the interpreter.

Functions have names that usually resemble their C STDWIN counterparts
with the initial `w` dropped. Points are represented by pairs of integers;
rectangles by pairs of points.

#### Functions Defined in Module `stdwin`

- **`open(title)`** -- opens a new window whose initial title is given by the string argument. Returns a window object.
- **`getevent()`** -- waits for and returns the next event. An event is returned as a triple: event type, window object (or `None`), and type-dependent detail.
- **`setdefwinpos(h, v)`** -- sets the default window position.
- **`setdefwinsize(width, height)`** -- sets the default window size.
- **`menucreate(title)`** -- creates a menu object referring to a global menu.
- **`fleep()`** -- causes a beep or bell.
- **`message(string)`** -- displays a dialog box containing the string. The user must click OK before the function returns.
- **`askync(prompt, default)`** -- displays a dialog that prompts the user to answer yes or no. Returns 0 for no, 1 for yes.
- **`askstr(prompt, default)`** -- displays a dialog that prompts the user for a string.
- **`askfile(prompt, default, new)`** -- asks the user to specify a filename.
- **`setcutbuffer(i, string)`** -- stores the string in the system's cut buffer number `i`.
- **`getcutbuffer(i)`** -- returns the contents of the system's cut buffer number `i`.
- **`rotatebutbuffers(n)`** -- on X11, rotates the 8 cut buffers by `n`. Ignored on the Macintosh.
- **`getselection(i)`** -- returns X11 selection number `i`.
- **`resetselection(i)`** -- resets selection number `i`, if this process owns it.
- **`baseline()`** -- return the baseline of the current font.
- **`lineheight()`** -- return the total line height of the current font.
- **`textbreak(str, width)`** -- return the number of characters of the string that fit into a space of `width` bits wide when drawn in the current font.
- **`textwidth(str)`** -- return the width in bits of the string when drawn in the current font.

#### Window Object Methods

Window objects are created by `stdwin.open()`. Windows are closed when
they are garbage-collected.

- **`begindrawing()`** -- returns a drawing object whose methods allow drawing in the window.
- **`change(rect)`** -- invalidates the given rectangle; this may cause a draw event.
- **`gettitle()`** -- returns the window's title string.
- **`getdocsize()`** -- returns a pair of integers giving the size of the document.
- **`getorigin()`** -- returns a pair of integers giving the origin of the window with respect to the document.
- **`getwinsize()`** -- returns a pair of integers giving the size of the window.
- **`menucreate(title)`** -- creates a menu object referring to a local menu (appears only in this window).
- **`scroll(rect, point)`** -- scrolls the given rectangle by the vector given by the point.
- **`setwincursor(name)`** -- sets the window cursor to a cursor of the given name. Suitable names are `'ibeam'`, `'arrow'`, `'cross'`, `'watch'` and `'plus'`.
- **`setdocsize(point)`** -- sets the size of the drawing document.
- **`setorigin(point)`** -- moves the origin of the window to the given point.
- **`setselection(i, str)`** -- attempts to set X11 selection number `i` to the string `str`. Returns true if it succeeds.
- **`settitle(title)`** -- sets the window's title string.
- **`settimer(dsecs)`** -- schedules a timer event for the window in `dsecs/10` seconds.
- **`show(rect)`** -- tries to ensure that the given rectangle of the document is visible.
- **`textcreate(rect)`** -- creates a text-edit object in the document at the given rectangle.

#### Drawing Object Methods

Drawing objects are created exclusively by the window method
`begindrawing()`. Only one drawing object can exist at any given time.

- **`box(rect)`** -- draws a box around a rectangle.
- **`circle(center, radius)`** -- draws a circle with given center point and radius.
- **`elarc(center, (rh, rv), (a1, a2))`** -- draws an elliptical arc with given center point.
- **`erase(rect)`** -- erases a rectangle.
- **`invert(rect)`** -- inverts a rectangle.
- **`line(p1, p2)`** -- draws a line from point `p1` to `p2`.
- **`paint(rect)`** -- fills a rectangle.
- **`text(p, str)`** -- draws a string starting at point p.
- **`shade(rect, percent)`** -- fills a rectangle with a shading pattern that is about `percent` percent filled.
- **`xorline(p1, p2)`** -- draws a line in XOR mode.
- **`baseline()`, `lineheight()`, `textbreak()`, `textwidth()`** -- similar to the corresponding functions in the `stdwin` module, but use the current font of the window.

#### Menu Object Methods

A menu object represents a menu. The menu is destroyed when the menu
object is deleted.

- **`additem(text, shortcut)`** -- adds a menu item with given text. The shortcut must be a string of length 1, or omitted.
- **`setitem(i, text)`** -- sets the text of item number `i`.
- **`enable(i, flag)`** -- enables or disables item `i`.
- **`check(i, flag)`** -- sets or clears the check mark for item `i`.

#### Text-edit Object Methods

A text-edit object represents a text-edit block.

- **`arrow(code)`** -- passes an arrow event to the text-edit block. The `code` must be one of `WC_LEFT`, `WC_RIGHT`, `WC_UP` or `WC_DOWN`.
- **`draw(rect)`** -- passes a draw event to the text-edit block.
- **`event(type, window, detail)`** -- passes an event to the text-edit block. Returns true if the event was handled.
- **`getfocus()`** -- returns 2 integers representing the start and end positions of the focus.
- **`getfocustext()`** -- returns the text in the focus.
- **`getrect()`** -- returns a rectangle giving the actual position of the text-edit block.
- **`gettext()`** -- returns the entire text buffer.
- **`move(rect)`** -- specifies a new position for the text-edit block in the document.
- **`replace(str)`** -- replaces the focus by the given string.
- **`setfocus(i, j)`** -- specifies the new focus. Out-of-bounds values are silently clipped.

#### Example

A simple example using STDWIN in Python. It creates a window and draws
"Hello world" in the top left corner. The window will be correctly
redrawn when covered and re-exposed.

```python
import stdwin
from stdwinevents import *

def main():
    mywin = stdwin.open('Hello')
    #
    while 1:
        (type, win, detail) = stdwin.getevent()
        if type = WE_DRAW:
            draw = win.begindrawing()
            draw.text((0, 0), 'Hello, world')
            del draw
        elif type = WE_CLOSE:
            break

main()
```

### Module `amoeba`

This module provides some object types and operations useful for Amoeba
applications. It is only available on systems that support Amoeba
operations. RPC errors and other Amoeba errors are reported as the
exception `amoeba.error = 'amoeba.error'`.

- **`name_append(path, cap)`** -- stores a capability in the Amoeba directory tree.
- **`name_delete(path)`** -- deletes a capability from the Amoeba directory tree.
- **`name_lookup(path)`** -- looks up a capability. Returns a *capability* object.
- **`name_replace(path, cap)`** -- replaces a capability in the Amoeba directory tree.
- **`capv`** -- a table representing the capability environment at the time the interpreter was started.
- **`error = 'amoeba.error'`** -- the exception raised when an Amoeba function returns an error. The value is a pair containing the numeric error code and the corresponding string.
- **`timeout(msecs)`** -- sets the transaction timeout, in milliseconds. Returns the previous timeout. Initially set to 2 seconds.

Capabilities are written in a convenient ASCII format:

```
>>> amoeba.name_lookup('/profile/cap')
aa:1c:95:52:6a:fa/14(ff)/8e:ba:5b:8:11:1a
```

Capability object methods:

- **`dir_list()`** -- returns a list of the names of the entries in an Amoeba directory.
- **`b_read(offset, maxsize)`** -- reads at most `maxsize` bytes from a bullet file at offset `offset`. Returns data as a string.
- **`b_size()`** -- returns the size of a bullet file.
- **`dir_append()`, `dir_delete()`, `dir_lookup()`, `dir_replace()`** -- like the corresponding `name_*` functions, but with a path relative to the capability.
- **`std_info()`** -- returns the standard info string of the object.
- **`tod_gettime()`** -- returns the time (in seconds since the Epoch) from a time server.
- **`tod_settime(t)`** -- sets the time kept by a time server.

### Module `audio`

This module provides rudimentary access to the audio I/O device
`/dev/audio` on the Silicon Graphics Personal IRIS.

- **`setoutgain(n)`** -- sets the output gain (0-255).
- **`getoutgain()`** -- returns the output gain.
- **`setrate(n)`** -- sets the sampling rate: 1=32K/sec, 2=16K/sec, 3=8K/sec.
- **`setduration(n)`** -- sets the `sound duration` in units of 1/100 seconds.
- **`read(n)`** -- reads a chunk of `n` sampled bytes from the audio input. The chunk is returned as a string of length n.
- **`write(buf)`** -- writes a chunk of samples to the audio output.

Asynchronous audio I/O:

- **`start_recording(n)`** -- starts a second thread that begins reading `n` bytes from the audio device.
- **`wait_recording()`** -- waits for the second thread to finish and returns the data read.
- **`stop_recording()`** -- makes the second thread stop reading as soon as possible. Returns the data read so far.
- **`poll_recording()`** -- returns true if the second thread has finished reading.
- **`start_playing(chunk)`, `wait_playing()`, `stop_playing()`, `poll_playing()`** -- similar but for output.

Utility operations:

- **`amplify(buf, f1, f2)`** -- amplifies a chunk of samples by a variable factor changing from `f1/256` to `f2/256`.
- **`reverse(buf)`** -- returns a chunk of samples backwards.
- **`add(buf1, buf2)`** -- bytewise adds two chunks of samples.
- **`chr2num(buf)`** -- converts a string of sampled bytes into a list containing the numeric values of the samples.
- **`num2chr(list)`** -- converts a list back to a buffer acceptable by `write()`.

### Module `gl`

This module provides access to the Silicon Graphics *Graphics Library*.
It is available only on Silicon Graphics machines.

**Warning:** some illegal calls to the GL library cause the Python
interpreter to dump core. In particular, the use of most GL calls is
unsafe before the first window is opened.

The parameter conventions for the C functions are translated to Python
as follows:

- All (short, long, unsigned) int values are represented by Python integers.
- All float and double values are represented by Python floating point numbers. In most cases, Python integers are also allowed.
- All arrays are represented by one-dimensional Python lists. In most cases, tuples are also allowed.
- All string and character arguments are represented by Python strings, for instance, `winopen('Hi There!')` and `rotate(900, 'z')`.
- All integer arguments or return values that are only used to specify the length of an array argument are omitted. For example, the C call `lmdef(deftype, index, np, props)` is translated to Python as `lmdef(deftype, index, props)`.
- Output arguments are omitted from the argument list; they are transmitted as function return values instead. For example, `getmcolor(i, &red, &green, &blue)` is translated to `red, green, blue = getmcolor(i)`.

Non-standard functions or functions with special argument conventions:

- **`varray()`** -- equivalent to but faster than a number of `v3d()` calls. The argument is a list (or tuple) of points, each a tuple of coordinates (x, y, z) or (x, y).
- **`nvarray()`** -- equivalent to but faster than a number of `n3f` and `v3f` calls.
- **`vnarray()`** -- similar to `nvarray()` but the pairs have the point first and the normal second.
- **`nurbssurface(s_k[], t_k[], ctl[][], s_ord, t_ord, type)`** -- defines a NURBS surface.
- **`nurbscurve(knots, ctlpoints, order, type)`** -- defines a NURBS curve.
- **`pwlcurve(points, type)`** -- defines a piecewise-linear curve.
- **`pick(n)`, `select(n)`** -- the only argument specifies the desired size of the pick or select buffer.
- **`endpick()`, `endselect()`** -- return a list of integers representing the used part of the pick/select buffer.

A tiny but complete example GL program in Python:

```python
import gl, GL, time

def main():
    gl.foreground()
    gl.prefposition(500, 900, 500, 900)
    w = gl.winopen('CrissCross')
    gl.ortho2(0.0, 400.0, 0.0, 400.0)
    gl.color(GL.WHITE)
    gl.clear()
    gl.color(GL.RED)
    gl.bgnline()
    gl.v2f(0.0, 0.0)
    gl.v2f(400.0, 400.0)
    gl.endline()
    gl.bgnline()
    gl.v2f(400.0, 0.0)
    gl.v2f(0.0, 400.0)
    gl.endline()
    time.sleep(5)

main()
```

### Module `pnl`

This module provides access to the *Panel Library* built by NASA Ames.
All access to it should be done through the standard module `panel`,
which transparently exports most functions from `pnl` but redefines
`pnl.dopanel()`.

**Warning:** the Python interpreter will dump core if you don't create a
GL window before calling `pnl.mkpanel()`.

The module is too large to document here in its entirety.


## 3. Standard Modules

The following standard modules are defined. They are available in one of
the directories in the default module search path (try printing `sys.path`
to find out the default search path).

### Module `string`

This module defines some constants useful for checking character classes,
some exceptions, and some useful string functions.

Constants:

- **`digits`** -- the string `'0123456789'`.
- **`hexdigits`** -- the string `'0123456789abcdefABCDEF'`.
- **`letters`** -- the concatenation of `lowercase` and `uppercase`.
- **`lowercase`** -- the string `'abcdefghijklmnopqrstuvwxyz'`.
- **`octdigits`** -- the string `'01234567'`.
- **`uppercase`** -- the string `'ABCDEFGHIJKLMNOPQRSTUVWXYZ'`.
- **`whitespace`** -- a string containing all characters that are considered whitespace, i.e., space, tab and newline. This definition is used by `split()` and `strip()`.

Exceptions:

- **`atoi_error = 'non-numeric argument to string.atoi'`** -- raised by `atoi` when a non-numeric string argument is detected.
- **`index_error = 'substring not found in string.index'`** -- raised by `index` when `sub` is not found.

Functions:

- **`atoi(s)`** -- converts a string to a number. The string must consist of one or more digits, optionally preceded by a sign.
- **`index(s, sub)`** -- returns the lowest index in `s` where the substring `sub` is found.
- **`lower(s)`** -- convert letters to lower case.
- **`split(s)`** -- returns a list of the whitespace-delimited words of the string `s`.
- **`splitfields(s, sep)`** -- returns a list containing the fields of the string `s`, using the string `sep` as a separator.
- **`strip(s)`** -- removes leading and trailing whitespace from the string `s`.
- **`swapcase(s)`** -- converts lower case letters to upper case and vice versa.
- **`upper(s)`** -- convert letters to upper case.
- **`ljust(s, width)`, `rjust(s, width)`, `center(s, width)`** -- respectively left-justify, right-justify and center a string in a field of given width. The string is never truncated.

### Module `path`

This module implements some useful functions on POSIX pathnames.

- **`basename(p)`** -- returns the base name of pathname `p`.
- **`cat(p, q)`** -- performs intelligent pathname concatenation: if `q` is an absolute path, the return value is `q`; otherwise, the concatenation of `p` and `q` is returned.
- **`commonprefix(list)`** -- returns the longest string that is a prefix of all strings in `list`.
- **`exists(p)`** -- returns true if `p` refers to an existing path.
- **`isdir(p)`** -- returns true if `p` refers to an existing directory.
- **`islink(p)`** -- returns true if `p` refers to a directory entry that is a symbolic link.
- **`ismount(p)`** -- returns true if `p` is an absolute path that occurs in the mount table as output by the `/etc/mount` utility. This output is read once when the function is used for the first time.
- **`split(p)`** -- returns a pair `(head, tail)` such that `tail` contains no slashes and `path.cat(head, tail)` is equal to `p`.
- **`walk(p, visit, arg)`** -- calls the function `visit` with arguments `(arg, dirname, names)` for each directory in the directory tree rooted at `p`. The `visit` function may modify `names` to influence the set of directories visited below `dirname`.

### Module `getopt`

This module helps scripts to parse the command line arguments in
`sys.argv`. It uses the same conventions as the Unix `getopt()` function.
It defines the function `getopt.getopt(args, options)` and the exception
`getopt.error`.

The first argument to `getopt()` is the argument list passed to the
script with its first element chopped off (i.e., `sys.argv[1:]`). The
second argument is the string of option letters that the script wants to
recognize, with options that require an argument followed by a colon
(same format as Unix `getopt()`). The return value consists of two
elements: the first is a list of option-and-value pairs; the second is
the list of program arguments left after the option list was stripped.

Example:

```
>>> import getopt, string
>>> args = string.split('-a -b -cfoo -d bar a1 a2')
>>> args
['-a', '-b', '-cfoo', '-d', 'bar', 'a1', 'a2']
>>> optlist, args = getopt.getopt(args, 'abc:d:')
>>> optlist
[('-a', ''), ('-b', ''), ('-c', 'foo'), ('-d', 'bar')]
>>> args
['a1', 'a2']
```

The exception `getopt.error = 'getopt error'` is raised when an
unrecognized option is found or when an option requiring an argument is
given none.

### Module `rand`

This module implements a pseudo-random number generator similar to
`rand()` in C.

- **`rand()`** -- returns an integer random number in the range [0 ... 32768).
- **`choice(s)`** -- returns a random element from the sequence (string, tuple or list) `s`.
- **`srand(seed)`** -- initializes the random number generator with the given integral seed. When the module is first imported, the random number is initialized with the current time.

### Module `whrandom`

This module implements a Wichmann-Hill pseudo-random number generator.

- **`random()`** -- returns the next random floating point number in the range [0.0 ... 1.0).
- **`seed(x, y, z)`** -- initializes the random number generator from the integers `x`, `y` and `z`. When the module is first imported, it is initialized using values derived from the current time.

### Module `stdwinevents`

This module defines constants used by STDWIN for event types
(`WE_ACTIVATE` etc.), command codes (`WC_LEFT` etc.) and selection types
(`WS_PRIMARY` etc.). Read the file for details. Suggested usage:

```
>>> from stdwinevents import *
```

### Module `rect`

This module contains useful operations on rectangles. A rectangle is
defined as a pair of points, where a point is a pair of integers. For
example:

```
(10, 20), (90, 80)
```

is a rectangle whose left, top, right and bottom edges are 10, 20, 90
and 80, respectively. Note that the positive vertical axis points down.

- **`error = 'rect.error'`** -- the exception raised by functions in this module when they detect an error.
- **`empty`** -- the rectangle returned when some operations return an empty result:
  ```
  >>> import rect
  >>> r1 = (10, 20), (90, 80)
  >>> r2 = (0, 0), (10, 20)
  >>> r3 = rect.intersect(r1, r2)
  >>> if r3 is rect.empty: print 'Empty intersection'
  Empty intersection
  ```
- **`is_empty(r)`** -- returns true if the given rectangle is empty. A rectangle *(left, top), (right, bottom)* is empty if *left >= right* or *top <= bottom*.
- **`intersect(list)`** -- returns the intersection of all rectangles in the list argument. May also be called with a tuple argument or with two or more rectangles as arguments. Raises `rect.error` if the list is empty.
- **`union(list)`** -- returns the smallest rectangle that contains all non-empty rectangles in the list argument. Returns `rect.empty` if the list is empty or all its rectangles are empty.
- **`pointinrect(point, rect)`** -- returns true if the point is inside the rectangle. A point *(h, v)* is inside a rectangle *(left, top), (right, bottom)* if *left <= h < right* and *top <= v < bottom*.
- **`inset(rect, (dh, dv))`** -- returns a rectangle that lies inside the `rect` argument by `dh` pixels horizontally and `dv` pixels vertically.
- **`rect2geom(rect)`** -- converts a rectangle to geometry representation: *(left, top), (width, height)*.
- **`geom2rect(geom)`** -- converts a rectangle given in geometry representation back to the standard representation *(left, top), (right, bottom)*.

### Modules `GL` and `DEVICE`

These modules define the constants used by the Silicon Graphics *Graphics
Library* that C programmers find in the header files `<gl/gl.h>` and
`<gl/device.h>`. Read the module files for details.

### Module `panel`

This module should be used instead of the built-in module `pnl` to
interface with the *Panel Library*.

- **`defpanellist(filename)`** -- parses a panel description file containing S-expressions written by the *Panel Editor* and creates the described panels. Returns a list of panel objects.

**Warning:** the Python interpreter will dump core if you don't create a
GL window before calling `panel.mkpanel()` or `panel.defpanellist()`.

### Module `panelparser`

This module defines a self-contained parser for S-expressions as output
by the Panel Editor (which is written in Scheme). The relevant function
is `panelparser.parse_file(file)` which has a file object (not a
filename) as argument and returns a list of parsed S-expressions. Each
S-expression is converted into a Python list, with atoms converted to
Python strings and sub-expressions (recursively) to Python lists.


## P.M.

Still to be documented (from the original source):

- `commands`
- `cmp`
- `*cache`
- `localtime`
- `calendar`
- `__dict`
- `mac`
