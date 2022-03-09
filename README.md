#  Parser-for-C-like-Programming-Language-with-Flex-Bison
Flex-Bison Project 2021 for Undergraduate course of Principles of Programming Languages and Compiler Design, University of Patras.

Project created on May 2021.

## Project Creator
Christos Mpalatsouras

Computer Engineering & Informatics Student at the University of Patras.

## Project Description:
Implementation of a lexical analyzer using FLEX (LEX) and a syntax analyzer using BISON (YACC), in order to recognize a C-like custom made programming language.

## Make instructions for Linux
Flex and Bison must be installed in the Linux machine before.

1. bison -y -d c-like_parser.y
2. flex c-like_lexer.l
3. gcc -o myparser y.tab.c lex.yy.c -lfl
4. ./myparser prog.c

