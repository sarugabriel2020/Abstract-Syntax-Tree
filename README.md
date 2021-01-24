# Abstract-Syntax-Tree

## A small introduction

• The theme of this project was to implement an Assembly language function that parses a mathematical expression into a prefixed form and builds an AST (Abstract Syntax Tree).

## Mentions 

- The numbers that appear in the expression are signed integers, on 32 bits, and the operations that apply to them are: +, -, /, * . 

- The prefixed expression will be received as a string that is given as a function parameter, the result being a pointer to the root node of the tree , saved in the EAX register.

## What are Abstract Syntactic Trees ?

-> Abstract Syntactic Trees are a Data Structure with which compilers represent the structure of a program. After traversing the AST, a compiler generates the metadata needed to transform from high-level code to Assembly code.

-> The representation in the form of an AST of a program / expression has the advantage of clearly defining the order of evaluation of operations without the need for parentheses.


## Abut the Implementation

• The program will use as input a string containing the preorder traversal of the tree, in the next order : Root , Left, Right .

• The expression is transformed into a Tree by the create_tree(char * token) function in the ast.asm file, which is called by the checker. 
 ( The checker also handles the release of the memory used to hold the shaft . )

• Moreover, the iocla_atoi function is implemented (in the same file), which has a functionality similar to the atoi function in C.
## The solving + realisation

• To carry out this project, I needed the following auxiliary functions:

    - calloc, through which I allocated memory on the heap for a node (each node in
    part, obviously);
    
    - strtok, to break the received input, a string, after the delimiter  received as a variable in the skeleton;
    
    - strlen, to calculate the length of a string in a node (value node);
    
    - malloc, to allocate on the heap a contiguous memory area, necessary for our string that we want to allocate; by default, we will allocate a number of bytes equal to the lunigm calculated with strlen;
    
    - memcpy, to move the problem we already had in static format to the previously allocated heap memory area;

• To solve the project , I've also used other functions, implemented by this personal data, such as:
 
    - is_operand, which checks if a value in a node represents an operand or is an integer;
    
    - make_node, function that creates a new node (memory allocation, value insertion + tree binding); if it returns 0, it means that a new strtok could not be made, and therefore the program ends;
    
    - tree_nodes_generator, the most important function in the whole program; it is the one that gives us the functionality of the way of working, and which presents it directly to the way of thinking.
