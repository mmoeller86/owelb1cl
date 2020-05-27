.keep begin
.section &ptr86.
.*
.pp
.*
.************************************************************************
.*
.shade begin
Note: the following sections only apply to the &wc286. (16-bit) compiler.
For the &wc386. compiler, see the section "&ptr386.".
..if '&target' eq 'PC 370' ..th ..do begin
.pp
The next section applying to the &wlooc. compiler is "Void".
..do end
.shade end
.*
.************************************************************************
.*
.keep end
.pp
On the 8086, a normal pointer
(16 bits) can only point to a 64K region of
the total memory available on the machine.
This effectively limits any program to a maximum of 64K of
executable code and 64K of data.
For many applications,
this does not pose a limitation.
.pp
Some applications need more than 64K of code or data, or
both. The &wc286. compiler provides a mechanism whereby pointers
can be declared that get beyond the 64K limit. This can be done either
by specifying an option when compiling the files (see the
&userguide) or by including a special
.ix 'type' 'pointer'
type qualifier keyword in the declaration of the object.
Later sections describe these keywords and their use.
.pp
The use of the keywords may prevent the program from compiling
using other C compilers, in particular when the program is being
transported to another system.
However, the preprocessor can be used to eliminate the keywords on
these other systems.
.pp
Before discussing the special pointer types,
it is important to understand the different
.ix 'memory model'
.us memory models
that are available and what they mean.
The five memory models are
referred to as:
:ZDL termhi=1.
:ZDT.small
.ix 'memory model' 'small'
.ix 'small memory model'
:ZDD.
small code (code < 64K), small data (data < 64K)
:ZDT.compact
.ix 'memory model' 'compact'
.ix 'compact memory model'
:ZDD.
small code (code < 64K), big data (total data > 64K, all objects < 64K)
:ZDT.medium
.ix 'memory model' 'medium'
.ix 'medium memory model'
:ZDD.
big code (code > 64K), small data (data < 64K)
:ZDT.large
.ix 'memory model' 'large'
.ix 'large memory model'
:ZDD.
big code (code > 64K), big data (total data > 64K, all objects < 64K)
:ZDT.huge
.ix 'memory model' 'huge'
.ix 'huge memory model'
:ZDD.
big code (code > 64K), huge data (total data > 64K, objects > 64K)
:ZeDL.
.pp
The following sections discuss the memory models in terms of
"small" and "big" code
and data sizes.
The terms "small", "compact", "medium", "large" and
"huge" are simply concise terms used to describe the
combinations of
code and data
sizes available.
.*
.beglevel
.*
.section The Small and Big Code Models
.*
.ix 'memory model' 'big code'
.ix 'memory model' 'small code'
.ix 'small code'
.ix 'big code'
.pp
Each program can use either
.us small code
(less than 64K) or
.us big code
(more than 64K).
Small code means that all functions (together)
must fit within the 64K limit on
code size. It is possible to call a function using only a 16-bit
pointer.
This is the default.
.pp
Big code removes the restriction, but requires that all functions
be called with a 32-bit pointer.
A 32-bit pointer consists of
two 16-bit quantities,
called the
.ix 'pointer' 'segment'
.us segment
and
.ix 'pointer' 'offset'
.us offset.
(When the computer uses the segment and offset to refer to an
actual memory location, the two values are combined to produce a
20-bit memory address, which allows for the addressing of 1024K
of memory.)
Because of the larger pointers,
the code generated by
the big code option takes more space and takes longer to execute.
.pp
When the big code option is being used, it is possible to group
functions together into several 64K (or smaller) regions.
Each module can be its own region, or several modules can be
grouped.
It is possible to call other functions within the same group using
a 16-bit value.
These functions are said to be
.ix 'function' 'near'
.ix 'near'
.us near.
Functions outside the group can still be called, but
must be called using a 32-bit value.
These functions are said to be
.ix 'function' 'far'
.ix 'far'
.us far.
.pp
When the big code option is given on the command line
for compiling the module,
ordinary pointers to functions will
be defined automatically to be of the
larger type, and function calls will be done using the longer
(32-bit) form.
.pp
It is also possible to use the small code option, and to override
certain functions and pointers to functions as being
.us far.
However, this method may lead to problems.
The &wc286. compiler generates special function calls that the
programmer doesn't see, such as checking for stack overflow when
a function is invoked.
These calls are either
.us near
or
.us far
depending entirely on the memory model chosen when the module is
compiled.
If the small code model is being used, all calls will be near calls.
If, however, several code groups are created with far calls between
them, they will all need to access the stack overflow checking routines.
The linker can only place these special routines
in one of the code groups,
leaving the other functions without access to them, causing an error.
.pp
To resolve this problem, mixing code models requires that all modules
be compiled with the big code model, overriding certain functions
as being near.
In this manner, the stack checking routines can be placed in any code
group, which the other code groups can still access.
Alternatively, a command-line switch may be used to turn off
stack checking, so no stack checking routines get called.
.*
.section The Small and Big Data Models
.*
.ix 'memory model' 'small data'
.ix 'memory model' 'big data'
.ix 'small data'
.ix 'big data'
.pp
Each program can use either
.us small data
(less than 64K) or
.us big data
(more than 64K).
Small data requires that all objects exist within one 64K region of
memory. It is possible to refer to each object using a 16-bit pointer.
This is the default.
.pp
Big data removes the restriction, but all pointers to data objects
require a 32-bit pointer.
As with the big code option, extra instructions are required
to manipulate the 32-bit pointer, so the generated code will
be larger and not as fast.
.pp
With either small or big data,
each object is restricted in size to a maximum of 64K bytes.
However, an object may be declared as
.us huge,
allowing the object to be bigger than 64K bytes.
Pointers to huge objects are the least efficient
because of extra code required to handle them, especially when
doing pointer arithmetic.
Huge objects are discussed in the section "&hugekw.".
.pp
When the big data option is being used,
the program still retains one region up to 64K in size in which
objects can be referred to using 16-bit pointers,
regardless of the code group being executed.
These objects are
said to be
.ix 'near'
.us near.
Objects outside this region can still be referenced, but must be
referred to using a 32-bit value.
These objects are said to be
.ix 'far'
.us far.
.pp
When the big data option is given on the command line
for compiling the module,
ordinary pointers to objects other than functions will
be defined automatically to be of the larger type.
.pp
It is also possible to use the small data option, and to override
certain objects as being
.us far.
The programmer must decide which method is easier to use.
.*
.section Mixing Memory Models
.*
.ix 'memory model' 'mixing'
.pp
It is possible to mix small and big code and data pointers within one
program. In fact, a programmer striving for optimum efficiency will
probably mix pointer types. But great care must be taken!
.pp
In some applications, the programmer may want the ability to have
either big code or big data, but won't want to pay the extra-code
penalty required to compile everything accordingly.
In the case of big data,
the programmer may realize that 99% of the data structures
can reside within the 64K limit, and the remaining ones must go
beyond that limit. Similarly, it may be desirable to have only a few
functions that don't fit within the 64K limit.
.pp
When overriding the current memory model, it is
.us very
important to declare each type properly.
.* because the compiler generally can't help detect
.* problems in the declarations of objects.
.pp
The following sections describe how to override the current memory model.
.*
.section The &kwfar_sp. Keyword for &wc286.
.*
.pp
When the big code memory model is in effect,
functions are
.us far
and pointers to functions are
declared automatically to be
.ix 'far pointer'
.ix 'pointer' 'far'
pointers to
.us far
functions. Similarly, the big data model causes all pointers to objects
(other than functions) to be
.ix 'far pointer'
.ix 'pointer' 'far'
pointers to
.us far
objects. However, when either the small code or small data model
is being used, the keyword
.kwix &kwfar_sp.
.kwfont &kwfar.
may be used to override to the big model.
.pp
The
.kwix &kwfar_sp.
.kwfont &kwfar.
keyword
is a type qualifier that modifies the token that follows it.
If
.kwix &kwfar_sp.
.kwfont &kwfar.
precedes
.mono *
(as in
.mono &kwfar. *
..ct ),
then the pointer points to something far. Otherwise, if
.kwix &kwfar_sp.
.kwfont &kwfar.
precedes the identifier of the object or function being declared
(as in
.mono &kwfar. x)
.ct , then the object itself is far.
.pp
The keyword
.kwix &kwfar_sp.
.kwfont &kwfar.
can only be applied to function and object names
and the indirection (pointer) symbol
.mono *
.period
Parameters to functions may
.us not
be declared as
.kwix &kwfar_sp.
.kwfont &kwfar.
since they are always in the 64K data area that is near.
.shade begin
&wc286. provides the predefined macros
.mkw far
and
.mkw _far
for convenience and compatibility with the Microsoft C compiler.
They may be used in place of
.kwix &kwfar_sp.
.kwfont &kwfar.
.period
.shade end
.pp
The following examples illustrate the use of the
.kwix &kwfar_sp.
.kwfont &kwfar.
keyword.
The examples assume that the
small memory model (small code, small data)
is being used.
.millust begin
int &kwfar. * ptr;
.millust end
.discuss begin
declares
.mono ptr
to be a pointer to an integer. The object
.mono ptr
is near (addressable using only 16 bits),
but the value of the pointer is the address of an integer which is far,
and so the pointer contains 32 bits.
.discuss end
.millust begin
int * &kwfar. fptr;
.millust end
.discuss begin
also declares
.mono fptr
to be a pointer to an integer. However, the object
.mono fptr
is far, but the integer that it points to is near.
.discuss end
.millust begin
int &kwfar. * &kwfar. ffptr;
.millust end
.discuss begin
declares
.mono ffptr
to be a pointer (which is far) to an integer (which is far).
.discuss end
.pp
When declaring a function, placing the keyword
.kwix &kwfar_sp.
.kwfont &kwfar.
in front of the function name causes the compiler to treat the function
as being far. It is important, if the function is called before its
definition, that a
.ix 'function' 'prototype'
.us function prototype
be included prior to any calls.
For example, the declaration,
.millust begin
void &kwfar. BubbleSort();
.millust end
.pc
declares the function
.mono BubbleSort
to be far, meaning that any calls to it must be far calls.
.pp
Here are a few more examples. These, too, assume that
the small memory model
(small code,
small data)
is being used.
.millust begin
struct symbol * &kwfar. FSymAlloc( void );
.millust end
.discuss begin
declares the function
.mono FSymAlloc
to be far, returning a pointer to a near
.mono symbol
structure.
.discuss end
.millust begin
struct symbol &kwfar. * &kwfar. FFSymAlloc( void );
.millust end
.discuss begin
declares the function
.mono FFSymAlloc
to be far, returning a pointer to a far
.mono symbol
structure.
.discuss end
.millust begin
void Indirect( float &kwfar. fn() );
.millust end
.discuss begin
declares the function
.mono Indirect
to be near, taking one parameter
.mono fn
which is a pointer
.* (which is near)
to a far function that returns a
.kw float
.period
.discuss end
.keep begin
.millust begin
int AdjustLeft( struct symbol * &kwfar. symptr );
.millust end
.discuss begin
is an invalid declaration, since it attempts to declare
.mono symptr
to be far. All parameters must be near, since
they reside in the 64K data area that is always near.
.discuss end
.keep end
.*
.section The &kwnear_sp. Keyword for &wc286.
.*
.pp
When the small code memory model is in effect,
functions are
.us near,
and pointers to functions are
automatically declared to be
.ix 'near pointer'
.ix 'pointer' 'near'
pointers to
.us near
functions. Similarly, the small data model causes all pointers to objects
(other than functions) to be
.ix 'near pointer'
.ix 'pointer' 'near'
pointers to
.us near
objects. However, when either the big code or big data model
is being used, the keyword
.kwix &kwnear_sp.
.kwfont &kwnear.
may be used to override to the small model.
.pp
The
.kwix &kwnear_sp.
.kwfont &kwnear.
keyword
is a type qualifier that modifies the token that follows it.
If
.kwix &kwnear_sp.
.kwfont &kwnear.
precedes
.mono *
(as in
.mono &kwnear. *
..ct ),
then the pointer points to something near. Otherwise, if
.kwix &kwnear_sp.
.kwfont &kwnear.
precedes the identifier of the object or function being declared
(as in
.mono &kwnear. x)
.ct , then the object itself is near.
.pp
The keyword
.kwix &kwnear_sp.
.kwfont &kwnear.
can only be applied to function and object names
and the indirection (pointer) symbol
.mono *.
.shade begin
&wc286. provides the predefined macros
.mkw near
and
.mkw _near
for convenience and compatibility with the Microsoft C compiler.
They may be used in place of
.kwix &kwnear_sp.
.kwfont &kwnear.
.period
.shade end
.pp
The following examples illustrate the use of the
.kwix &kwnear_sp.
.kwfont &kwnear.
keyword.
These examples assume that the large memory module
(big code, big data)
is being used.
.millust begin
extern int &kwnear. * x;
.millust end
.discuss begin
declares the object
.mono x
to be a pointer to a near integer.
(
..ct .mono x
is not necessarily
within the 64K data area that is near, but the integer that it
points to is.)
.discuss end
.millust begin
extern int * &kwnear. nx;
.millust end
.discuss begin
declares the object
.mono nx
to be near, and is a pointer to a far integer.
(
..ct .mono nx
is within the 64K data area that is near, but the integer that it
points to might not be.)
.discuss end
.millust begin
extern int &kwnear. * &kwnear. nnx;
.millust end
.discuss begin
declares the object
.mono nnx
to be near, and is a pointer to a near integer.
(
..ct .mono nnx
and the integer that it points to are both within the 64K data area
that is near.)
.discuss end
.millust begin
struct symbol * &kwnear. NSymAlloc( void );
.millust end
.discuss begin
declares the function
.mono NSymAlloc
to be near, and returns a pointer to a far
.mono symbol
structure.
.discuss end
.keep begin
.millust begin
struct symbol &kwnear. * &kwnear. NNSymAlloc( void );
.millust end
.discuss begin
declares the function
.mono NNSymAlloc
to be near, and returns a pointer to a near
.mono symbol
structure.
.discuss end
.keep end
.*
.section &hugekw. for &wc286.
.*
.ix 'pointer' 'huge'
.ix 'huge pointer'
.pp
Even using the big data model, each object is restricted in size
to 64K.
Some applications will need to get beyond this limitation.
The &wc286. compiler provides the keyword
.kwix &kwhuge_sp.
.kwfont &kwhuge.
to describe those objects that exceed 64K in size. The code generated
for these objects is less efficient than for
.kwix &kwfar_sp.
.kwfont &kwfar.
objects.
.pp
The declaration of such objects follows the same pattern as above, with
the keyword
.kwix &kwhuge_sp.
.kwfont &kwhuge.
preceding the name of the object if the object itself is bigger than
64K, or preceding the
.mono *
if the pointer is to an object that is bigger than 64K.
.pp
The keyword
.kwix &kwhuge_sp.
.kwfont &kwhuge.
can only be applied to arrays.
Huge objects may be used in both the small and big data models.
.shade begin
&wc286. provides the predefined macros
.mkw huge
and
.mkw _huge
for convenience and compatibility with the Microsoft C compiler.
They may be used in place of
.kwix &kwhuge_sp.
.kwfont &kwhuge.
.period
.shade end
.pp
These examples illustrate the use of the
.kwix &kwhuge_sp.
.kwfont &kwhuge.
keyword. They assume that big code, small data
.ix 'memory model' 'medium'
.ix 'medium memory model'
(the medium memory model) is in effect.
.millust begin
int &kwhuge. iarray[50000];
.millust end
.discuss begin
declares the object
.mono iarray
to be an array of 50000 integers, for a total size of 100000 bytes.
.discuss end
.millust begin
int &kwhuge. * iptr;
.millust end
.discuss begin
declares
.mono iptr
to be near, and a pointer to an integer that is part of a huge array,
such as an element of
.mono iarray.
.discuss end
.endlevel
.*
.section &ptr386.
.*
.pp
With an 80386 processor in "protect" mode,
a normal pointer (32 bits) can point to
a 4 gigabyte (4,294,967,296 byte) region of the memory available
on the machine.
(In practice, memory limits may mean that these regions will be
smaller than 4 gigabytes.)
These regions are called
.us segments,
and
there may be more than one
segment
defined for the memory.
Each 32-bit pointer is actually an offset within a 4 gigabyte segment,
and the offsets within two different segments are generally not related
to each other in a known manner.
.pp
As an example, the screen memory may be set up so that it resides in a
different region of the memory from the program's data.
Normal pointers (those within the program's data area)
will not be able to access such regions.
.pp
Like the 16-bit version of &wcgeneric. (for the 8086 and 80286),
&wc386. uses the
.kwix &kwnear_sp.
.kwfont &kwnear.
and
.kwix &kwfar_sp.
.kwfont &kwfar.
keywords to describe objects that are either in the normal data space
or elsewhere.
.pp
Objects or functions that are near require a 32-bit pointer to access them.
.pp
Objects or functions that are far require a 48-bit pointer to access them.
This 48-bit pointer consists of two parts:
a
.ix 'pointer' 'selector'
.ul selector
consisting of 16 bits,
and an
.ix 'pointer' 'offset'
.ul offset
consisting of 32 bits.
A selector is similar to a segment in a 16-bit program's far pointer,
except that the numeric value of the selector does not directly determine
the memory region.
Instead, the processor uses the selector value in conjunction with a
"descriptor table" to determine what region of memory is to be
accessed.
In the discussion of far pointers on the 80386, the terms
.ix 'pointer' 'selector'
selector and
.ix 'pointer' 'segment'
segment may be used interchangeably.
.pp
Like the 16-bit compiler, the &wc386. compiler supports the
.ix 'memory model' 'small'
.ix 'small memory model'
small,
.ix 'memory model' 'compact'
.ix 'compact memory model'
compact,
.ix 'memory model' 'medium'
.ix 'medium memory model'
medium and
.ix 'memory model' 'large'
.ix 'large memory model'
large memory models.
Throughout the discussions in the following sections, it is assumed
that the small memory model is being used, since it is the most likely
to be used.
.*
.beglevel
.section The &kwfar_sp. Keyword for &wc386.
.*
.pp
The
.kwix &kwfar_sp.
.kwfont &kwfar.
keyword is a type qualifier that modifies the token that follows it.
If
.kwix &kwfar_sp.
.kwfont &kwfar.
precedes
.mono *
(as in
.mono &kwfar. *
..ct ), then the pointer points to something that is far (not in the
normal data region).
Otherwise, if
.kwix &kwfar_sp.
.kwfont &kwfar.
precedes the identifier of the object or function being declared (as in
.mono &kwfar. x
..ct ), then the object or function is far.
.pp
The keyword
.kwix &kwfar_sp.
.kwfont &kwfar.
can only be applied to function and object names and the
indirection (pointer) symbol
.mono *
.period
Parameters to functions may
.us not
be declared as
.kwix &kwfar_sp.
.kwfont &kwfar.
.ct , since they are always in the normal data region.
.pp
These examples illustrate the use of the
.kwix &kwfar_sp.
.kwfont &kwfar.
keyword, and assume that the small memory model is being used.
.millust begin
int &kwfar. * ptr;
.millust end
.discuss begin
declares
.mono ptr
to be a pointer to an integer.
The object
.mono ptr
is near
but the integer that it points to is far.
.discuss end
.millust begin
int * &kwfar. fptr;
.millust end
.discuss begin
also declares
.mono fptr
to be a pointer to an integer.
However, the object
.mono fptr
is far, but the integer that it points to is near.
.discuss end
.millust begin
int &kwfar. * &kwfar. ffptr;
.millust end
.discuss begin
declares
.mono ffptr
to be a pointer (which is far) to an integer (which is far).
.discuss end
.pp
When declaring a function, placing the keyword
.kwix &kwfar_sp.
.kwfont &kwfar.
in front of the function name causes the compiler to treat the function
as being far. It is important, if the function is called before its
definition, that a
.ix 'function' 'prototype'
.us function prototype
be included prior to any calls.
For example, the declaration,
.millust begin
extern void &kwfar. SystemService();
.millust end
.pc
declares the function
.mono SystemService
to be far, meaning that any calls to it must be far calls.
.keep begin
.pp
Here are a few more examples:
.millust begin
extern struct systbl * &kwfar. FSysTblPtr( void );
.millust end
.discuss begin
declares the function
.mono FSysTblPtr
to be far, returning a pointer to a near
.mono systbl
structure.
.discuss end
.keep break
.millust begin
extern struct systbl &kwfar. * &kwfar. FFSysTblPtr( void );
.millust end
.discuss begin
declares the function
.mono FFSysTblPtr
to be far, returning a pointer to a far
.mono systbl
structure.
.discuss end
.keep break
.millust begin
extern void Indirect( char &kwfar. fn() );
.millust end
.discuss begin
declares the function
.mono Indirect
to be near, taking one parameter
.mono fn
which is a pointer
.* which is near
to a far function that returns a
.kw char
.period
.discuss end
.keep break
.millust begin
extern int StoreSysTbl( struct systbl * &kwfar. sysptr );
.millust end
.discuss begin
is an invalid declaration, since it attempts to declare
.mono sysptr
to be far.
All parameters must be near, since
they reside in the normal data area that is always near.
.discuss end
.keep end
.*
.section The &kwnear_sp. Keyword for &wc386.
.*
.pp
The
.kwix &kwnear_sp.
.kwfont &kwnear.
keyword is a type qualifier that modifies the token that follows it.
If
.kwix &kwnear_sp.
.kwfont &kwnear.
precedes
.mono *
(as in
.mono &kwnear. *
..ct ), then the pointer points to something that is near (in the
normal data region).
Otherwise, if
.kwix &kwnear_sp.
.kwfont &kwnear.
precedes the identifier of the object or function being declared (as in
.mono &kwnear. x
..ct ), then the object or function is near.
.pp
The keyword
.kwix &kwnear_sp.
.kwfont &kwnear.
can only be applied to function and object names and the
indirection (pointer) symbol
.mono *
.period
.pp
For programmers using the small memory model, the
.kwix &kwnear_sp.
.kwfont &kwnear.
keyword is not required, but may be useful for making
the program more readable.
.* .pp
.* In fact, the
.* .kwix &kwnear_sp.
.* .kwfont &kwnear.
.* keyword has no effect.
.* Since &wc386. only supports one memory model, where all of the
.* program's data is always near (there is no option to make it far),
.* the
.* .kwix &kwnear_sp.
.* .kwfont &kwnear.
.* keyword is most useful for making the program more readable.
.*
..im ptr16
.*
.endlevel
