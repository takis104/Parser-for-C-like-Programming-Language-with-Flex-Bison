
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(char *);
extern FILE *yyin;							
extern FILE *yyout;
int line = 0;
extern int yylineno;
#define YYERROR_VERBOSE 1
%}

%token PROGRAM NAME ARRAY NUM COMP_OPERATOR
%token VARS DATATYPE FUNCTION END_FUNCTION RETURN
%token WHILE ENDWHILE
%token FOR ASSIGN TO STEP ENDFOR
%token IF THEN ELSEIF ELSE ENDIF
%token SWITCH CASE DEFAULT ENDSWITCH
%token PRINT
%token BREAK
%token NEWLINE
%left ','
%left '+' '-'
%left '*' '/'
%right '^'

%start program

%%

program: program_declaration commands { printf("Code Parsed successfully!\n"); } /* Will be revised later */
       | program_declaration function commands { printf("Code Parsed successfully!\n"); }
       ;

program_declaration: PROGRAM NAME newline { printf("Program Statement found\n"); }
                   ;
                   
variable_declaration: VARS DATATYPE variable ';' newline { printf("Variable Statement found\n"); }
                    | VARS DATATYPE variable ';' newline variable_declaration { printf("Variable Statement found\n"); }
                    ;
                    
function: function_declaration commands function_end newline { printf("Function Statement found\n"); }
        | function_declaration variable_declaration commands function_end newline { printf("Function Statement found\n"); }
        | function_declaration commands newline function_end newline function { printf("Function Statement found\n"); }
        | function_declaration variable_declaration commands function_end newline function { printf("Function Statement found\n"); }
        ;
         
function_declaration: FUNCTION function_name newline { printf("Function Declared\n"); }
                    ;
                    
function_name: NAME '(' variable ')'
             ;
             
function_end: RETURN variable END_FUNCTION
            | RETURN NUM END_FUNCTION
            ;
            
command: assignment
       | loop_statement
       | break_command
       ;
       
commands: command newline
        | command newline commands
        ;
             
assignment: variable '=' expression ';' { printf("Assignment statement found\n"); }
          | variable '=' expression ';' assignment { printf("Assignment statement found\n"); }
          ;
          
loop_statement: while_statement
              | for_statement
              ;
              
break_command: BREAK ';' { printf("Break command found\n"); }
             ;
          
while_statement: WHILE '(' condition ')' newline commands ENDWHILE { printf("While Loop statement found\n"); }
               ;
               
condition: expression COMP_OPERATOR expression
         ;
               
for_statement: FOR NAME ASSIGN NUM TO NUM STEP NUM newline commands ENDFOR { printf("For Loop statement found\n"); }
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

void yyerror(char *s) 
{
    fprintf(stderr, "ERROR: %s in line %d\n", s, yylineno);
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
			
