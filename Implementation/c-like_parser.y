
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(char *);
extern FILE *yyin;							
extern FILE *yyout;							
%}

%token PROGRAM PROGRAMNAME NEWLINE

%start program

%%

program: program_declaration NEWLINE { printf("All success!\n"); }
       ;

program_declaration: PROGRAM PROGRAMNAME NEWLINE { printf("Program Statement found\n"); }
                   ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}									


int main ( int argc, char **argv  ) 
  {
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "output", "w" );	
  yyparse ();	    
  return 0;
  }   
			
