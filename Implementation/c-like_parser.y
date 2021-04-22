
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYERROR_VERBOSE 1

void yyerror(char *);
extern FILE *yyin;							
extern FILE *yyout;
extern int yylineno;
int line = 0;
FILE *p;
%}

%union {
	char *str;
}

%token PROGRAM NAME ARRAY NUM COMP_OPERATOR AND OR STRLITERAL CHARLITERAL
%token VARS DATATYPE FUNCTION END_FUNCTION RETURN
%token STARTMAIN ENDMAIN
%token WHILE ENDWHILE
%token FOR ASSIGN_OPERATOR TO STEP ENDFOR
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

program: program_declaration main_statement newline { printf("Code Parsed successfully!\n"); fprintf(p, "Code Parsed successfully!\n"); }
       | program_declaration function main_statement newline { printf("Code Parsed successfully!\n"); fprintf(p, "Code Parsed successfully!\n"); }
       ;

program_declaration: PROGRAM NAME newline { printf("Program Statement found\n"); }
                   ;
                   
main_statement: STARTMAIN commands ENDMAIN { printf("MAIN Statement found\n"); }
              | STARTMAIN variable_declaration commands ENDMAIN { printf("MAIN Statement found\n"); }
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
             
function_end: RETURN NUM END_FUNCTION
            | RETURN CHARLITERAL END_FUNCTION
            | RETURN variable END_FUNCTION
            ;
            
command: assignment
       | print_statement
       | loop_statement
       | break_command
       | control_statement
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
             
control_statement: if_statement
                 | switch_statement
                 ;
          
while_statement: WHILE '(' condition ')' newline commands ENDWHILE { printf("While Loop statement found\n"); }
               ;
               
condition: expression COMP_OPERATOR expression
         | expression AND expression
         | expression OR expression
         ;
               
for_statement: FOR NAME ASSIGN_OPERATOR NUM TO NUM STEP NUM newline commands ENDFOR { printf("For Loop statement found\n"); }
             ;
             
if_statement: IF '(' condition ')' THEN newline commands ENDIF { printf("If statement found\n"); }
            | IF '(' condition ')' THEN newline commands else_if_statement ENDIF { printf("If statement found\n"); }
            | IF '(' condition ')' THEN newline commands else_statement ENDIF { printf("If statement found\n"); }
            | IF '(' condition ')' THEN newline commands else_if_statement else_statement ENDIF { printf("If statement found\n"); }
            ;
            
else_if_statement: ELSEIF '(' condition ')' newline commands
                 | ELSEIF '(' condition ')' newline commands else_if_statement
                 ;
                 
else_statement: ELSE newline commands
              ;
              
switch_statement: SWITCH '(' expression ')' newline case ENDSWITCH { printf("Switch statement found\n"); }
                | SWITCH '(' expression ')' newline case default ENDSWITCH { printf("Switch statement found\n"); }
                ;
                
case: CASE '(' expression ')' ':' newline commands
    | CASE '(' expression ')' ':' newline commands case
    ;
    
default: DEFAULT ':' newline commands
       ;
       
print_statement: PRINT '(' STRLITERAL ')' ';' { printf("Print Statement found\n"); }
               | PRINT '(' STRLITERAL ',' variable ')' ';' { printf("Print Statement found\n"); }
               ;

expression: literal
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
        
literal: NUM
       | STRLITERAL
       | CHARLITERAL
       ;

newline: NEWLINE { line++; }
       ;

%%

void yyerror(char *s) 
{
    fprintf(stderr, "ERROR: %s in line %d\n", s, yylineno);
    fprintf(p, "ERROR: %s in line %d\n", s, yylineno);
}									


int main ( int argc, char **argv  ) 
  {
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "output.c", "w" );
  
  p = fopen("diagnostics.txt", "w");
  fprintf(p, "**** START of Parsing Diagnostic Messages ****\n\n");
  
  yyparse ();
  
  printf("Lines of code parsed: %i\n", line);
  fprintf(p, "Lines of code parsed: %i\n", line);
  fprintf(p, "\n**** END of Parsing Diagnostic Messages ****\n");
  fclose(p);
  
  return 0;
  }   
			
