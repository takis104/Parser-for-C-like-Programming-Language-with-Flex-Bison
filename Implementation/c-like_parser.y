
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(char *);
extern FILE *yyin;							
extern FILE *yyout;
int line = 0;
%}

%token PROGRAM NAME ARRAY NUM
%token VARS DATATYPE FUNCTION
%token NEWLINE
%left ','
%left '+' '-'
%left '*' '/'
%right '^'

%start program

%%

program: program_declaration function assignment newline { printf("Code Parsed successfully!\n"); } /* Will be revised later */
       ;

program_declaration: PROGRAM NAME newline { printf("Program Statement found\n"); }
                   ;
                   
variable_declaration: VARS DATATYPE variable ';' newline { printf("Variable Statement found\n"); }
                    | VARS DATATYPE variable ';' newline variable_declaration { printf("Variable Statement found\n"); }
                    ;
                    
function: function_declaration variable_declaration { printf("Function Statement found\n"); }
        | function_declaration variable_declaration function { printf("Function Statement found\n"); }
        ;
         
function_declaration: FUNCTION function_name newline { printf("Function Declared\n"); }
                    ;
                    
function_name: NAME '(' variable ')'
             ;
             
assignment: variable '=' expression ';' { printf("Assignment statement found\n"); }
          | variable '=' expression ';' assignment { printf("Assignment statement found\n"); }
          ;

expression: NUM
          | variable
          | function_name
          | expression '+' expression
          | expression '-' expression
          | expression '^' expression
          | expression '*' expression
          | expression '/' expression
          | '(' expression ')'
          ;
                    
variable: NAME
        | NAME ARRAY
        | NAME ',' variable
        | NAME ARRAY ',' variable
        ;

newline: NEWLINE { line++; }
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
  printf("Lines of code parsed: %i\n", line);
  return 0;
  }   
			
