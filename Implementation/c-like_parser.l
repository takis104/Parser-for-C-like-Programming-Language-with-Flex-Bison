
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
comparative	">"|"<"|"=="|"!="
datatype	{chartype}|{inttype}
basiccharacter	{underscore}|{letter}|{digit}
number		{digit}+|{digit}+"."{digit}+
basicstring 	{basiccharacter}*
name 		{letter}{basicstring}|{underscore}{basicstring}
array		"["{number}"]"

%%

"\n"		{ yylval.str = strdup(yytext); ECHO; return NEWLINE; }
";"		{ yylval.str = strdup(yytext); ECHO; return ';'; }
":"		{ yylval.str = strdup(yytext); ECHO; return ':'; }
","		{ yylval.str = strdup(yytext); ECHO; return ','; }
"("		{ yylval.str = strdup(yytext); ECHO; return '('; }
")"		{ yylval.str = strdup(yytext); ECHO; return ')'; }
"+"		{ yylval.str = strdup(yytext); ECHO; return '+'; }
"-"		{ yylval.str = strdup(yytext); ECHO; return '-'; }
"^"		{ yylval.str = strdup(yytext); ECHO; return '^'; }
"*"		{ yylval.str = strdup(yytext); ECHO; return '*'; }
"/"		{ yylval.str = strdup(yytext); ECHO; return '/'; }
"="		{ yylval.str = strdup(yytext); ECHO; return '='; }
"AND"		{ yylval.str = strdup(yytext); ECHO; return AND; }
"OR"		{ yylval.str = strdup(yytext); ECHO; return OR; }
":="		{ yylval.str = strdup(yytext); ECHO; return ASSIGN_OPERATOR; }
"PROGRAM" 	{ yylval.str = strdup(yytext); ECHO; return PROGRAM; }
"VARS"		{ yylval.str = strdup(yytext); ECHO; return VARS; }
"FUNCTION"	{ yylval.str = strdup(yytext); ECHO; return FUNCTION; }
"END_FUNCTION"	{ yylval.str = strdup(yytext); ECHO; return END_FUNCTION; }
"RETURN"	{ yylval.str = strdup(yytext); ECHO; return RETURN; }
"WHILE"	{ yylval.str = strdup(yytext); ECHO; return WHILE; }
"ENDWHILE"	{ yylval.str = strdup(yytext); ECHO; return ENDWHILE; }
"FOR"		{ yylval.str = strdup(yytext); ECHO; return FOR; }
"TO"		{ yylval.str = strdup(yytext); ECHO; return TO; }
"STEP"		{ yylval.str = strdup(yytext); ECHO; return STEP; }
"ENDFOR"	{ yylval.str = strdup(yytext); ECHO; return ENDFOR; }
"IF"		{ yylval.str = strdup(yytext); ECHO; return IF; }
"THEN"		{ yylval.str = strdup(yytext); ECHO; return THEN; }
"ELSEIF"	{ yylval.str = strdup(yytext); ECHO; return ELSEIF; }
"ELSE"		{ yylval.str = strdup(yytext); ECHO; return ELSE; }
"ENDIF"	{ yylval.str = strdup(yytext); ECHO; return ENDIF; }
"SWITCH"	{ yylval.str = strdup(yytext); ECHO; return SWITCH; }
"CASE"		{ yylval.str = strdup(yytext); ECHO; return CASE; }
"DEFAULT"	{ yylval.str = strdup(yytext); ECHO; return DEFAULT; }
"ENDSWITCH"	{ yylval.str = strdup(yytext); ECHO; return ENDSWITCH; }
"PRINT"	{ yylval.str = strdup(yytext); ECHO; return PRINT; }
"BREAK"	{ yylval.str = strdup(yytext); ECHO; return BREAK; }
{datatype}	{ yylval.str = strdup(yytext); ECHO; return DATATYPE; }
{name}		{ yylval.str = strdup(yytext); ECHO; return NAME; }
{number}	{ yylval.str = strdup(yytext); ECHO; return NUM; }
{array}	{ yylval.str = strdup(yytext); ECHO; return ARRAY; }
{comparative}	{ yylval.str = strdup(yytext); ECHO; return COMP_OPERATOR; }

%%
