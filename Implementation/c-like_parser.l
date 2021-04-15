
%{
#include "y.tab.h"  
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

underscore	"_"
digit 		[0-9]
letter 	[a-zA-Z]
basiccharacter	{underscore}|{letter}|{digit}
basicstring 	{basiccharacter}*
varname 	{letter}{basicstring}|{underscore}{basicstring}
programname 	{letter}{basicstring}


%%

"PROGRAM" 	{ return PROGRAM; }
{programname} 	{ return PROGRAMNAME; }
"\n"		{ return NEWLINE; }

%%
