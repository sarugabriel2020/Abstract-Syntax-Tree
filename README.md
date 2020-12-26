# Abstract-Syntax-Tree


-In this project , I implemented an assembly language function that parses a mathematical expression into a prefixed form and builds an AST (abstract syntax tree).
-The numbers that appear in the expression are signed integers, on 32 bits, and the operations that apply to them are: +, -, /, *. The prefixed expression will be received as a string that is given as a function parameter, the result being a pointer to the root node of the tree, saved in the EAX register.

What are Abstract Syntactic Trees?

--Abstract syntactic trees are a data structure with which compilers represent the structure of a program. After traversing the AST, a compiler generates the metadata needed to transform from high-level code to assembly code.
--The representation in the form of an AST of a program / expression has the advantage of clearly defining the order of evaluation of operations without the need for parentheses.

---Implementation---

•The program will use as input a string containing the preorder traversal of the tree, in order, root, left, right .
•This expression is transformed into a tree by the create_tree (char * token) function in the ast.asm file, which is called by the checker. The checker also handles the release of the memory used to hold the shaft.
•Moreover, the iocla_atoi function is implemented (in the same file), which has a functionality similar to the atoi function in C.
