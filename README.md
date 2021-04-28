# Flex-Bison-Project-2021-CEID_NY132
Flex Bison Project 2021

Compulsory project for the undergraduate course "Principles of programming languages and compilers - CEID_NY132"

Implementation of a lexical analyzer using FLEX and a syntax analyzer using BISON, in order to analyze a C-like custom made programming language.

In this project, the above mentioned custom made programming language will also be described in BNF form.

Created by Christos-Panagiotis Balatsouras, StudentID: 1054335

All the provided documentation is in Greek language.

## Make instructions for Linux
1. bison -y -d c-like_parser.y
2. flex c-like_lexer.l
3. gcc y.tab.c lex.yy.c -lfl
4. ./a.out prog.c

