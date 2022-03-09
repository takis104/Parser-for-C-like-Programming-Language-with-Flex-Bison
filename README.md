#  Parser-for-C-like-Programming-Language-with-Flex-Bison
Flex-Bison Project 2021 - Compulsory project for the undergraduate course "Principles of programming languages and compilers - CEID_NY132"

Implementation of a lexical analyzer using FLEX (LEX) and a syntax analyzer using BISON (YACC), in order to recognize a C-like custom made programming language.

[comment]: <> (In this project, the above mentioned custom made programming language will also be described in BNF form.)

Created by Christos-Panagiotis Balatsouras, StudentID: 1054335

[comment]: <> (All the provided documentation is in Greek language.)

## Make instructions for Linux

Flex and Bison must be installed in the Linux machine before.

1. bison -y -d c-like_parser.y
2. flex c-like_lexer.l
3. gcc -o myparser y.tab.c lex.yy.c -lfl
4. ./myparser prog.c

