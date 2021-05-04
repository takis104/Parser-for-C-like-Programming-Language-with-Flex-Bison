
%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option yylineno

underscore	"_"
digit 		[0-9]
letter 	[a-zA-Z]
chartype 	"CHAR"
inttype	"INTEGER"
userdatatype	"Node"
comparative	">"|"<"|"=="|"!="
char		.
charsequence	{char}*
strliteral	\"{charsequence}\"
charliteral	"'"{char}"'"
linecomment	"%"{charsequence}
datatype	{chartype}|{inttype}
basiccharacter	{underscore}|{letter}|{digit}
number		{digit}+|{digit}+"."{digit}+
basicstring 	{basiccharacter}*	
name 		{letter}{basicstring}|{underscore}{basicstring}
array		"["{number}"]"

%%

[ \t]		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext);}
"\n"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return NEWLINE; }
";"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ';'; }
":"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ':'; }
","		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ','; }
"("		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return '('; }
")"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ')'; }
"+"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return '+'; }
"-"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return '-'; }
"^"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return '^'; }
"*"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return '*'; }
"/"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return '/'; }
"="		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return '='; }
"AND"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return AND; }
"OR"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return OR; }
":="		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ASSIGN_OPERATOR; }
"PROGRAM" 	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return PROGRAM; }
"VARS"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return VARS; }
"TYPEDEF" 	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return TYPEDEF; }
"STRUCT" 	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return STRUCT; }
"ENDSTRUCT" 	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ENDSTRUCT; }
"FUNCTION"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return FUNCTION; }
"END_FUNCTION"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return END_FUNCTION; }
"RETURN"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return RETURN; }
"WHILE"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return WHILE; }
"ENDWHILE"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ENDWHILE; }
"FOR"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return FOR; }
"TO"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return TO; }
"STEP"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return STEP; }
"ENDFOR"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ENDFOR; }
"IF"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return IF; }
"THEN"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return THEN; }
"ELSEIF"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ELSEIF; }
"ELSE"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ELSE; }
"ENDIF"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ENDIF; }
"SWITCH"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return SWITCH; }
"CASE"		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return CASE; }
"DEFAULT"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return DEFAULT; }
"ENDSWITCH"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ENDSWITCH; }
"PRINT"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return PRINT; }
"BREAK"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return BREAK; }
"STARTMAIN"	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return STARTMAIN; }
"ENDMAIN"	{ yylval.str = strdup(yytext); ECHO; printf("%s\n",yytext); return ENDMAIN; }
{strliteral}	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return STRLITERAL; }
{charliteral}	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return CHARLITERAL; }
{linecomment}	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); }
{userdatatype}	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return USERDATATYPE; }
{datatype}	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return DATATYPE; }
{name}		{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return NAME; }
{number}	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return NUM; }
{array}	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return ARRAY; }
{comparative}	{ yylval.str = strdup(yytext); ECHO; printf("%s",yytext); return COMP_OPERATOR; }

%%
