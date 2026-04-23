---
title: Tutorial
nav_order: 2
---

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


