# Abstract Syntax Tree 


## About

• I have implemented an assembly language function that parses a mathematical expression into a prefixed form and builds an AST (Abstract Syntax Tree).

• The numbers that appear in the expression are signed integers, on 32 bits, and the operations that apply to them are: +, -, /, *. 
  
• The prefixed expression will be received as a string that is given as a function parameter, the result being a pointer to the root node of the tree, saved in the EAX register.

## What is an Abstract Syntax Tree ? 

Abstract Syntactic Trees are a data structure with which compilers represent the structure of a program. More exactly, after traversing the AST, a compiler generates the metadata needed to transform from high-level code to assembly code.

The representation in the form of an AST of a program / expression **has the advantage of clearly defining the order of evaluation of operations without the need for parentheses.**

So  the expression 4/64 - 2 * (3 + 1) can be represented in the form:

![](/AST.JPG)

## Implementation

The program will use as input a string in which is the preorder traversal of the tree, in the order, root, left, right, which is called the prefixed Polish shape.

This expression must be transformed into a tree by the create_tree (char * token) function in the ast.asm file, which is called by the checker. The checker also handles the release of the memory used to hold the shaft.

Moreover, you will have to implement the function iocla_atoi (in the same file), which has a functionality similar to the function atoi in C.

> int iocla_atoi(char* token)

Also, the structure used to store a node in the tree looks like this:

>struct __attribute__((__packed__)) Node
>{\
>    char* data;\
>    struct Node* left;\
>    struct Node* right;\
>};

The data string contains either **an operator (+, -, *, / )** or **an operand (number)**. In both cases, the string ends with the character \0.

## What is __attribute__((__packed__)) ? 

• The following code does not allow to the compiler to add padding within a structure, the distances from the beginning of the structure where its fields are, thus being the expected ones and not varying from one car to another.

### Padding and Packing

**Padding** aligns structure members to "natural" address boundaries - say, int members would have offsets, which are mod(4) == 0 on 32-bit platform. Padding is on by default. It inserts the following "gaps" into your first structure:

```sh

struct mystruct_A {
    char a;
    char gap_0[3];\ /* inserted by compiler: for alignment of b */
    int b;
    char c;
    char gap_1[3]; /* -"-: for alignment of the whole struct in an array */
} x;

```

**Packing**, on the other hand prevents compiler from doing padding - this has to be explicitly requested - under GCC it's __attribute__((__packed__)), so the following:

```sh
struct __attribute__((__packed__)) mystruct_A {
    char a;
    int b;
    char c;
};
```

## Example of runnig the program:

```sh

$ ./ast
* -  5 6 7
-7

$ ./ast
+ + * 5 3 2 * 2 3 
23

$ ./ast 
- * 4 + 3 2 5
15

```
