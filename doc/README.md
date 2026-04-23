# Python 0.9.1 Documentation

> [!NOTE]
> This file contains the full content of the original LaTeX documentation,
> converted to Markdown. The source files are `tut.tex` (tutorial) and
> `mod.tex` + `mod1.tex` + `mod2.tex` + `mod3.tex` (library reference).
> The original README is preserved as [`README.old`](README.old).

# Part 1: Python Tutorial (DRAFT)

**Author:** Guido van Rossum  
Dept. CST, CWI, Kruislaan 413  
1098 SJ Amsterdam, The Netherlands  
E-mail: guido@cwi.nl

Python is a simple, yet powerful programming language that bridges the
gap between C and shell programming, and is thus ideally suited for rapid
prototyping. Its syntax is put together from constructs borrowed from a
variety of other languages; most prominent are influences from ABC, C,
Modula-3 and Icon.

The Python interpreter is easily extended with new functions and data
types implemented in C. Python is also suitable as an extension language
for highly customizable C applications such as editors or window managers.

Python is available for various operating systems, amongst which several
flavors of Unix, Amoeba, and the Apple Macintosh O.S.

This tutorial introduces the reader informally to the basic concepts and
features of the Python language and system. It helps to have a Python
interpreter handy for hands-on experience, but as the examples are
self-contained, the tutorial can be read off-line as well.

For a description of standard objects and modules, see Part 2 (Library
Reference). The Language Reference document (XXX not yet existing) gives
a more formal reference to the language.


## 1. Whetting Your Appetite

If you ever wrote a large shell script, you probably know this feeling:
you'd love to add yet another feature, but it's already so slow, and so
big, and so complicated; or the feature involves a system call or other
function that is only accessible from C... Usually the problem at hand
isn't serious enough to warrant rewriting the script in C; perhaps
because the problem requires variable-length strings or other data types
(like sorted lists of file names) that are easy in the shell but lots of
work to implement in C; or perhaps just because you're not sufficiently
familiar with C.

In all such cases, Python is just the language for you. Python is simple
to use, but it is a real programming language, offering much more
structure and support for large programs than the shell has. On the other
hand, it also offers much more error checking than C, and, being a
*very-high-level language*, it has high-level data types built in, such
as flexible arrays and dictionaries that would cost you days to implement
efficiently in C. Because of its more general data types Python is
applicable to a much larger problem domain than *Awk* or even *Perl*, yet
most simple things are at least as easy in Python as in those languages.

Python allows you to split up your program in modules that can be reused
in other Python programs. It comes with a large collection of standard
modules that you can use as the basis for your programs -- or as examples
to start learning to program in Python. There are also built-in modules
that provide things like file I/O, system calls, and even a generic
interface to window systems (STDWIN).

Python is an interpreted language, which saves you considerable time
during program development because no compilation and linking is
necessary. The interpreter can be used interactively, which makes it easy
to experiment with features of the language, to write throw-away programs,
or to test functions during bottom-up program development. It is also a
handy desk calculator.

Python allows writing very compact and readable programs. Programs written
in Python are typically much shorter than equivalent C programs: no
declarations are necessary (all type checking is dynamic); statement
grouping is done by indentation instead of begin/end brackets; and the
high-level data types allow you to express complex operations in a single
statement.

Python is *extensible*: if you know how to program in C it is easy to add
a new built-in module to the interpreter, either to perform critical
operations at maximum speed, or to link Python programs to libraries that
may be only available in binary form (such as a vendor-specific graphics
library). Once you are really hooked, you can link the Python interpreter
into an application written in C and use it as an extension or command
language.

### Where From Here

Since the best introduction to a language is using it, the next section
explains the mechanics of using the interpreter. The rest of the tutorial
introduces various features of the Python language and system through
examples, beginning with simple expressions, statements and data types,
through functions and modules, and finally touching upon advanced concepts
like exceptions and classes.


## 2. Using the Python Interpreter

The Python interpreter is usually installed as `/usr/local/python` on
those machines where it is available; putting `/usr/local` in your Unix
shell's search path makes it possible to start it by typing:

```
python
```

The interpreter operates somewhat like the Unix shell: when called with
standard input connected to a tty device, it reads and executes commands
interactively; when called with a file name argument or with a file as
standard input, it reads and executes a *script* from that file.

If available, the script name and additional arguments thereafter are
passed to the script in the variable `sys.argv`, which is a list of
strings.

When standard input is a tty, the interpreter is said to be in
*interactive mode*. In this mode it prompts for the next command with the
*primary prompt*, usually three greater-than signs (`>>>`); for
continuation lines it prompts with the *secondary prompt*, by default
three dots (`...`). Typing an EOF (Control-D) at the primary prompt causes
the interpreter to exit with a zero exit status.

When an error occurs in interactive mode, the interpreter prints a message
and a stack trace and returns to the primary prompt; with input from a
file, it exits with a nonzero exit status. All error messages are written
to the standard error stream; normal output from the executed commands is
written to standard output.

Typing an interrupt (normally Control-C or DEL) to the primary or
secondary prompt cancels the input and returns to the primary prompt.
Typing an interrupt while a command is being executed raises the
`KeyboardInterrupt` exception, which may be handled by a `try` statement.

When a module named `foo` is imported, the interpreter searches for a
file named `foo.py` in a list of directories specified by the environment
variable `PYTHONPATH`. It has the same syntax as the Unix shell variable
`PATH`, i.e., a list of colon-separated directory names. When
`PYTHONPATH` is not set, an installation-dependent default path is used,
usually `.:/usr/local/lib/python`.

On BSD'ish Unix systems, Python scripts can be made directly executable,
like shell scripts, by putting the line:

```
#! /usr/local/python
```

at the beginning of the script and giving the file an executable mode.

### Interactive Input Editing and History Substitution

Some versions of the Python interpreter support editing of the current
input line and history substitution, similar to facilities found in the
Korn shell and the GNU Bash shell. This is implemented using the *GNU
Readline* library, which supports Emacs-style and vi-style editing.

The most important editing keys are:

- `C-A` -- move to beginning of line
- `C-E` -- move to end of line
- `C-B` / `C-F` -- move left / right one character
- `Backspace` -- erase character to the left
- `C-D` -- erase character to the right
- `C-K` -- kill rest of line to the right
- `C-Y` -- yank back last killed string
- `C-_` -- undo last change

History substitution:

- `C-P` / `C-N` -- move up / down in history buffer
- `C-R` / `C-S` -- incremental reverse / forward search
- `Return` -- pass current line to interpreter

The Readline library can be customized via `$HOME/.inputrc`. Example:

```
# prefer vi-style editing:
set editing-mode vi
# edit using a single line:
set horizontal-scroll-mode On
# rebind some keys:
Meta-h: backward-kill-word
Control-u: universal-argument
```

Note that the default binding for TAB in Python is to insert a TAB
instead of Readline's default filename completion function.


## 3. An Informal Introduction to Python

In the following examples, input and output are distinguished by the
presence or absence of prompts (`>>>` and `...`): to repeat the example,
you must type everything after the prompt, when the prompt appears;
everything on lines that do not begin with a prompt is output from the
interpreter. A secondary prompt on a line by itself means you must type a
blank line to end a multi-line command.

### Using Python as a Calculator

The interpreter acts as a simple calculator. Expression syntax is
straightforward: the operators `+`, `-`, `*` and `/` work as in most
other languages; parentheses can be used for grouping:

```
>>> # This is a comment
>>> 2+2
4
>>> (50-5+5*6+25)/4
25
>>> # Division truncates towards zero:
>>> 7/3
2
```

The equal sign (`=`) is used to assign a value to a variable:

```
>>> width = 20
>>> height = 5*9
>>> width * height
900
```

There is some support for floating point, but you can't mix floating
point and integral numbers in an expression (yet):

```
>>> 10.0 / 3.3
3.0303030303
```

Python can also manipulate strings, enclosed in single quotes:

```
>>> 'foo bar'
'foo bar'
>>> 'doesn\'t'
'doesn\'t'
```

Strings can be concatenated with `+` and repeated with `*`:

```
>>> word = 'Help' + 'A'
>>> word
'HelpA'
>>> '<' + word*5 + '>'
'<HelpAHelpAHelpAHelpAHelpA>'
```

Strings can be subscripted; the first character has subscript 0.
Substrings can be specified with *slice* notation (two indices separated
by a colon):

```
>>> word[4]
'A'
>>> word[0:2]
'He'
>>> word[2:4]
'lp'
>>> word[:2]    # Take first two characters
'He'
>>> word[2:]    # Drop first two characters
'lpA'
>>> word[:3] + word[3:]
'HelpA'
```

Degenerate cases are handled gracefully:

```
>>> word[1:100]
'elpA'
>>> word[10:]
''
>>> word[2:1]
''
```

Slice indices may be negative, to start counting from the right:

```
>>> word[-2:]    # Take last two characters
'pA'
>>> word[:-2]    # Drop last two characters
'Hel'
>>> word[-0:]    # (since -0 equals 0)
'HelpA'
```

The best way to remember how slices work is to think of the indices as
pointing *between* characters, with the left edge of the first character
numbered 0:

```
 +---+---+---+---+---+
 | H | e | l | p | A |
 +---+---+---+---+---+
 0   1   2   3   4   5
-5  -4  -3  -2  -1
```

`len()` computes the length of a string:

```
>>> s = 'supercalifragilisticexpialidocious'
>>> len(s)
34
```

The most versatile compound data type is the *list*:

```
>>> a = ['foo', 'bar', 100, 1234]
>>> a
['foo', 'bar', 100, 1234]
>>> a[0]
'foo'
>>> a[3]
1234
>>> a[1:3]
['bar', 100]
>>> a[:2] + ['bletch', 2*2]
['foo', 'bar', 'bletch', 4]
```

Unlike strings, which are *immutable*, individual elements of a list can
be changed:

```
>>> a[2] = a[2] + 23
>>> a
['foo', 'bar', 123, 1234]
```

Assignment to slices may change the size of the list:

```
>>> a[0:2] = [1, 12]
>>> a
[1, 12, 123, 1234]
>>> a[0:2] = []
>>> a
[123, 1234]
>>> a[1:1] = ['bletch', 'xyzzy']
>>> a
[123, 'bletch', 'xyzzy', 1234]
```

`len()` also applies to lists:

```
>>> len(a)
4
```

### Tuples and Sequences

XXX To Be Done.

### First Steps Towards Programming

We can write an initial subsequence of the *Fibonacci* series as follows:

```
>>> a, b = 0, 1
>>> while b < 100:
...       print b
...       a, b = b, a+b
...
1
1
2
3
5
8
13
21
34
55
89
```

This example introduces several new features:

- The first line contains a *multiple assignment*: `a` and `b`
  simultaneously get the new values 0 and 1. On the last line this is
  used again, demonstrating that expressions on the right-hand side are
  all evaluated first before any of the assignments take place.

- The `while` loop executes as long as the condition (here: `b < 100`)
  remains true. In Python, as in C, any non-zero integer value is true;
  zero is false. The standard comparison operators are `<`, `>`, `=`,
  `<=`, `>=` and `<>`.

- The *body* of the loop is *indented*: indentation is Python's way of
  grouping statements.

- The `print` statement writes the value of the expression(s) it is
  given. Strings are written without quotes and a space is inserted
  between items:

  ```
  >>> i = 256*256
  >>> print 'The value of i is', i
  The value of i is 65536
  ```

  A trailing comma avoids the newline after the output:

  ```
  >>> a, b = 0, 1
  >>> while b < 1000:
  ...     print b,
  ...     a, b = b, a+b
  ...
  1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987
  ```

### More Control Flow Tools

#### If Statements

```
>>> if x < 0:
...      x = 0
...      print 'Negative changed to zero'
... elif x = 0:
...      print 'Zero'
... elif x = 1:
...      print 'Single'
... else:
...      print 'More'
```

There can be zero or more `elif` parts, and the `else` part is optional.
The keyword `elif` is short for `else if`, and is useful to avoid
excessive indentation. An `if...elif...elif...` sequence is a substitute
for the *switch* or *case* statements found in other languages.

#### For Statements

The `for` statement in Python iterates over the items of any sequence
(e.g., a list or a string):

```
>>> a = ['cat', 'window', 'defenestrate']
>>> for x in a:
...     print x, len(x)
...
cat 3
window 6
defenestrate 12
```

#### The `range()` Function

If you need to iterate over a sequence of numbers, the built-in function
`range()` comes in handy. It generates lists containing arithmetic
progressions:

```
>>> range(10)
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> range(5, 10)
[5, 6, 7, 8, 9]
>>> range(0, 10, 3)
[0, 3, 6, 9]
>>> range(-10, -100, -30)
[-10, -40, -70]
```

To iterate over the indices of a sequence, combine `range()` and `len()`:

```
>>> a = ['Mary', 'had', 'a', 'little', 'boy']
>>> for i in range(len(a)):
...     print i, a[i]
...
0 Mary
1 had
2 a
3 little
4 boy
```

#### Break Statements and Else Clauses on Loops

The `break` statement breaks out of the smallest enclosing `for` or
`while` loop. Loop statements may have an `else` clause; it is executed
when the loop terminates normally but not when terminated by `break`:

```
>>> for n in range(2, 10):
...     for x in range(2, n):
...         if n % x = 0:
...            print n, 'equals', x, '*', n/x
...            break
...     else:
...          print n, 'is a prime number'
...
2 is a prime number
3 is a prime number
4 equals 2 * 2
5 is a prime number
6 equals 2 * 3
7 is a prime number
8 equals 2 * 4
9 equals 3 * 3
```

#### Pass Statements

The `pass` statement does nothing. It can be used when a statement is
required syntactically but the program requires no action:

```
>>> while 1:
...       pass # Busy-wait for keyboard interrupt
```

#### Conditions Revisited

XXX To Be Done.

### Defining Functions

We can create a function that writes the Fibonacci series to an arbitrary
boundary:

```
>>> def fib(n):    # write Fibonacci series up to n
...     a, b = 0, 1
...     while b <= n:
...           print b,
...           a, b = b, a+b
...
>>> fib(2000)
1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597
```

The keyword `def` introduces a function *definition*. It must be followed
by the function name and the parenthesized list of formal parameters. The
*execution* of a function introduces a new symbol table used for the
local variables of the function. Variable assignments in a function store
the value in the local symbol table; variable references first look in
the local symbol table, then in the global symbol table, and then in the
table of built-in names. Thus, the global symbol table is *read-only*
within a function. Arguments are passed using *call by value*.

A function definition introduces the function name in the global symbol
table. The value can be assigned to another name which can then also be
used as a function:

```
>>> fib
<function object at 10042ed0>
>>> f = fib
>>> f(100)
1 1 2 3 5 8 13 21 34 55 89
```

In Python, procedures are just functions that don't return a value. They
return `None` (a built-in name):

```
>>> print fib(0)
None
```

A function that returns a list of Fibonacci numbers instead of printing
them:

```
>>> def fib2(n): # return Fibonacci series up to n
...     result = []
...     a, b = 0, 1
...     while b <= n:
...           result.append(b)
...           a, b = b, a+b
...     return result
...
>>> f100 = fib2(100)
>>> f100
[1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
```

The `return` statement returns with a value from a function. The method
`append` adds a new element at the end of the list; it is equivalent to
`ret = ret + [b]`, but more efficient.

The list object type has two more methods:

- **`insert(i, x)`** -- inserts an item at a given position. `a.insert(0, x)` inserts at the front, `a.insert(len(a), x)` is equivalent to `a.append(x)`.
- **`sort()`** -- sorts the elements of the list.

```
>>> a = [10, 100, 1, 1000]
>>> a.insert(2, -1)
>>> a
[10, 100, -1, 1, 1000]
>>> a.sort()
>>> a
[-1, 1, 10, 100, 1000]
>>> b = ['Mary', 'had', 'a', 'little', 'boy']
>>> b.sort()
>>> b
['Mary', 'a', 'boy', 'had', 'little']
```

### Modules

If you quit from the Python interpreter and enter it again, the
definitions you have made are lost. To write a longer program, use a text
editor to prepare the input for the interpreter and run it with that file
as input. Such a file is called a *script*. You may also want to split a
program into several files, or to use a handy function in several
programs. To support this, Python has a way to put definitions in a file
and use them in a script or in an interactive instance of the interpreter.
Such a file is called a *module*; definitions from a module can be
*imported* into other modules or into the *main* module.

A module is a file containing Python definitions and statements. The file
name is the module name with the suffix `.py` appended. For instance,
create a file called `fibo.py` with the following contents:

```python
# Fibonacci numbers module

def fib(n):    # write Fibonacci series up to n
    a, b = 0, 1
    while b <= n:
          print b,
          a, b = b, a+b

def fib2(n): # return Fibonacci series up to n
    ret = []
    a, b = 0, 1
    while b <= n:
          ret.append(b)
          a, b = b, a+b
    return ret
```

Then import this module:

```
>>> import fibo
>>> fibo.fib(1000)
1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987
>>> fibo.fib2(100)
[1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
```

If you intend to use a function often you can assign it to a local name:

```
>>> fib = fibo.fib
>>> fib(500)
1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

#### More on Modules

A module can contain executable statements as well as function
definitions. These statements are intended to initialize the module and
are executed only the *first* time the module is imported.

Each module has its own private symbol table, which is used as the global
symbol table by all functions defined in the module. You can touch a
module's global variables with the same notation used to refer to its
functions: `modname.itemname`.

There is a variant of the `import` statement that imports names from a
module directly into the importing module's symbol table:

```
>>> from fibo import fib, fib2
>>> fib(500)
1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

There is even a variant to import all names that a module defines:

```
>>> from fibo import *
>>> fib(500)
1 1 2 3 5 8 13 21 34 55 89 144 233 377
```

This imports all names except those beginning with an underscore (`_`).

#### Standard Modules

Python comes with a library of standard modules. One particular module
deserves some attention: `sys`, which is built into every Python
interpreter. The variables `sys.ps1` and `sys.ps2` define the strings
used as primary and secondary prompts:

```
>>> import sys
>>> sys.ps1
'>>> '
>>> sys.ps2
'... '
>>> sys.ps1 = 'C> '
C> print 'Yuck!'
Yuck!
C>
```

The variable `sys.path` is a list of strings that determine the
interpreter's search path for modules. It is initialized from
`PYTHONPATH` or from a built-in default. You can modify it using standard
list operations:

```
>>> sys.path.append('/ufs/guido/lib/python')
```

### Errors and Exceptions

There are (at least) two distinguishable kinds of errors: *syntax errors*
and *exceptions*.

#### Syntax Errors

Syntax errors, also known as parsing errors, are perhaps the most common
kind of complaint while learning Python:

```
>>> while 1 print 'Hello world'
Parsing error: file <stdin>, line 1:
while 1 print 'Hello world'
             ^
Unhandled exception: run-time error: syntax error
```

The parser repeats the offending line and displays an arrow pointing at
the earliest point where the error was detected.

#### Exceptions

Even if a statement is syntactically correct, it may cause an error when
executed:

```
>>> 10 * (1/0)
Unhandled exception: run-time error: integer division by zero
Stack backtrace (innermost last):
  File "<stdin>", line 1
>>> 4 + foo*3
Unhandled exception: undefined name: foo
Stack backtrace (innermost last):
  File "<stdin>", line 1
>>> '2' + 2
Unhandled exception: type error: illegal argument type for built-in operation
Stack backtrace (innermost last):
  File "<stdin>", line 1
```

Common exception types:

- *Run-time errors* -- caused by wrong data used by the program.
- *Undefined name* errors -- usually caused by misspelled identifiers.
- *Type errors* -- using data the wrong way; the error can be glanced from the object type(s) alone.

#### Handling Exceptions

The `try` statement handles selected exceptions:

```
>>> numbers = [0.3333, 2.5, 0.0, 10.0]
>>> for x in numbers:
...     print x,
...     try:
...         print 1.0 / x
...     except RuntimeError:
...         print '*** has no inverse ***'
...
0.3333 3.00030003
2.5 0.4
0 *** has no inverse ***
10 0.1
```

The `try` statement works as follows:

1. The *try clause* (statements between `try` and `except`) is executed.
2. If no exception occurs, the *except clause* is skipped.
3. If an exception occurs and its type matches the exception named after `except`, the except clause is executed.
4. If an exception occurs which does not match, it is passed on to outer try statements; if no handler is found, it is an *unhandled exception* and execution stops.

A `try` statement may have more than one except clause. An except clause
may name multiple exceptions as a parenthesized list:

```
... except (RuntimeError, TypeError, NameError):
...     pass
```

When an exception has an argument, the except clause may specify a
variable to receive the argument's value:

```
>>> try:
...     foo()
... except NameError, x:
...     print 'name', x, 'undefined'
...
name foo undefined
```

Standard exception names and values:

```
EOFError              'end-of-file read'
KeyboardInterrupt     'keyboard interrupt'
MemoryError           'out of memory'           *
NameError             'undefined name'          *
RuntimeError          'run-time error'          *
SystemError           'system error'            *
TypeError             'type error'              *
```

Those with a `*` have an argument.

Exception handlers also handle exceptions that occur inside functions
called (even indirectly) in the try clause:

```
>>> def this_fails():
...     x = 1/0
...
>>> try:
...     this_fails()
... except RuntimeError, detail:
...     print 'Handling run-time error:', detail
...
Handling run-time error: domain error or zero division
```

#### Raising Exceptions

The `raise` statement forces a specified exception to occur:

```
>>> raise NameError, 'Hi There!'
Unhandled exception: undefined name: Hi There!
Stack backtrace (innermost last):
  File "<stdin>", line 1
```

#### User-defined Exceptions

Programs may name their own exceptions by assigning a string to a
variable:

```
>>> my_exc = 'nobody likes me!'
>>> try:
...     raise my_exc, 2*2
... except my_exc, val:
...     print 'My exception occured, value:', val
...
My exception occured, value: 4
>>> raise my_exc, 1
Unhandled exception: nobody likes me!: 1
```

#### Defining Clean-up Actions

The `try` statement has an optional `finally` clause for clean-up actions
that must execute under all circumstances:

```
>>> try:
...     raise KeyboardInterrupt
... finally:
...     print 'Goodbye, world!'
...
Goodbye, world!
Unhandled exception: keyboard interrupt
```

The *finally clause* is executed whether or not an exception occurred. It
is also executed when the `try` statement is left via a `break` or
`return` statement.

### Classes

Classes in Python make it possible to play the game of encapsulation in a
somewhat different way than with modules. Classes are an advanced topic
and are probably best skipped on the first encounter with Python.

#### Prologue

Python's class mechanism is a mixture of the class mechanisms found in
C++ and Modula-3. The most important features are retained with full
power: the class inheritance mechanism allows multiple base classes, a
derived class can override any method of its base class(es), a method can
call the method of a base class with the same name. Objects can contain an
arbitrary amount of private data.

In C++ terminology, all class members (including data members) are
*public*, and all member functions (methods) are *virtual*. There are no
special constructors or destructors. As in Modula-3, there are no
shorthands for referencing the object's members from its methods: the
method function is declared with an explicit first argument representing
the object, which is provided implicitly by the call.

#### A Simple Example

Consider the following example, which defines a class `Set` representing
a (finite) mathematical set:

```python
class Set():
    def new(self):
        self.elements = []
        return self
    def add(self, e):
        if e not in self.elements:
            self.elements.append(e)
    def remove(self, e):
        if e in self.elements:
            for i in range(len(self.elements)):
                if self.elements[i] = e:
                    del self.elements[i]
                    break
    def is_element(self, e):
        return e in self.elements
    def size(self):
        return len(self.elements)
```

Assuming this class definition is the only contents of the module file
`SetClass.py`, we can use it as follows:

```
>>> from SetClass import Set
>>> a = Set().new() # create a Set object
>>> a.add(2)
>>> a.add(3)
>>> a.add(1)
>>> a.add(1)
>>> if a.is_element(3): print '3 is in the set'
...
3 is in the set
>>> if not a.is_element(4): print '4 is not in the set'
...
4 is not in the set
>>> print 'a has', a.size(), 'elements'
a has 3 elements
>>> a.remove(1)
>>> print 'now a has', a.size(), 'elements'
now a has 2 elements
```

The functions defined in the class (e.g., `add`) can be called using the
*member* notation for the object `a`. The member function is called with
one less argument than it is defined: the object is implicitly passed as
the first argument. Thus, `a.add(2)` is equivalent to `Set.add(a, 2)`.

XXX This section is not complete yet!

### XXX P.M.

Still to be written:

- The `del` statement
- The `dir()` function
- Tuples
- Dictionaries
- Objects and types in general
- Backquotes
- And/Or/Not


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
