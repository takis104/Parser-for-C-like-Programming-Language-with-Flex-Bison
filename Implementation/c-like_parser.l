
%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap yylineno

underscore	"_"
digit 		[0-9]
letter 	[a-zA-Z]
chartype 	"CHAR"
inttype	"INTEGER"
comparative	">"|"<"|"=="|"!="|"AND"|"OR"
datatype	{chartype}|{inttype}
basiccharacter	{underscore}|{letter}|{digit}
number		{digit}+|{digit}+"."{digit}+
basicstring 	{basiccharacter}*
name 		{letter}{basicstring}|{underscore}{basicstring}
array		"["{number}"]"

%%

"\n"		{ return NEWLINE; }
";"		{ return ';'; }
","		{ return ','; }
"("		{ return '('; }
")"		{ return ')'; }
"+"		{ return '+'; }
"-"		{ return '-'; }
"^"		{ return '^'; }
"*"		{ return '*'; }
"/"		{ return '/'; }
"="		{ return '='; }
":="		{ return ASSIGN; }
"PROGRAM" 	{ return PROGRAM; }
"VARS"		{ return VARS; }
"FUNCTION"	{ return FUNCTION; }
"END_FUNCTION"	{ return END_FUNCTION; }
"RETURN"	{ return RETURN; }
"WHILE"	{ return WHILE; }
"ENDWHILE"	{ return ENDWHILE; }
"FOR"		{ return FOR; }
"TO"		{ return TO; }
"STEP"		{ return STEP; }
"ENDFOR"	{ return ENDFOR; }
"IF"		{ return IF; }
"THEN"		{ return THEN; }
"ELSEIF"	{ return ELSEIF; }
"ELSE"		{ return ELSE; }
"ENDIF"	{ return ENDIF; }
"SWITCH"	{ return SWITCH; }
"CASE"		{ return CASE; }
"DEFAULT"	{ return DEFAULT; }
"ENDSWITCH"	{ return ENDSWITCH; }
"PRINT"	{ return PRINT; }
"BREAK"	{ return BREAK; }
{datatype}	{ return DATATYPE; }
{name}		{ return NAME; }
{number}	{ return NUM; }
{array}	{ return ARRAY; }
{comparative}	{ return COMP_OPERATOR; }

%%
