
%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

underscore	    "_"
digit 		      [0-9]
letter 	        [a-zA-Z]
chartype 	      "CHAR"
inttype	        "INTEGER"
datatype	      {chartype}|{inttype}
basiccharacter	{underscore}|{letter}|{digit}
number		      {digit}+|{digit}+"."{digit}+
basicstring 	  {basiccharacter}*
name 		        {letter}{basicstring}|{underscore}{basicstring}
array		        "["{number}"]"

%%

"\n"		    { return NEWLINE; }
";"		      { return ';'; }
","		      { return ','; }
"("		      { return '('; }
")"		      { return ')'; }
"+"		      { return '+'; }
"-"		      { return '-'; }
"^"		      { return '^'; }
"*"		      { return '*'; }
"/"		      { return '/'; }
"="		      { return '='; }
"PROGRAM"   { return PROGRAM; }
"VARS"		  { return VARS; }
"FUNCTION"	{ return FUNCTION; }
{datatype}	{ return DATATYPE; }
{name}		  { return NAME; }
{number}	  { return NUM; }
{array}	    { return ARRAY; }
.		        ;

%%
