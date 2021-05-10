
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
FILE *diagnostics;
char *progr;
struct variableEntity
{
	char *Name;
	char *DataType;
	struct variableEntity *next;
};
struct functionEntity
{
	char *Name;
	struct functionEntity *next;
};
void printVariableList(struct variableEntity *node)
{
	while(node != NULL)
	{
		printf("Variable Name: %s, Variable Type: %s\n", node->Name, node->DataType);
		node = node->next;
	}
}
void printFunctionList(struct functionEntity *node)
{
	while(node != NULL)
	{
		printf("Function Name: %s\n", node->Name);
		node = node->next;
	}
}
void variableListAppend(struct variableEntity** head_rf, char *name, char *type)
{
	struct variableEntity* new_var = (struct variableEntity*) malloc(sizeof(struct variableEntity));
	struct variableEntity *end = *head_rf;
	
	new_var->Name = name;
	new_var->DataType = type;
	new_var->next = NULL;
	
	if(*head_rf == NULL)
	{
		*head_rf = new_var;
		return;
	}
	
	while(end->next != NULL)
	{
		end = end->next;
	}
	
	end->next = new_var;
	
	return;
}
void functionListAppend(struct functionEntity** head_rf, char *name)
{
	struct functionEntity* new_var = (struct functionEntity*) malloc(sizeof(struct functionEntity));
	struct functionEntity *end = *head_rf;
	
	new_var->Name = name;
	new_var->next = NULL;
	
	if(*head_rf == NULL)
	{
		*head_rf = new_var;
		return;
	}
	
	while(end->next != NULL)
	{
		end = end->next;
	}
	
	end->next = new_var;
	
	return;
}
int variableSearch(struct variableEntity* head, char *key)
{
	struct variableEntity* lookup = head;
	
	while(lookup != NULL)
	{
		if(lookup->Name == key)
		{
			return 1;
		}
		lookup = lookup->next;
	}
	return 0;
}
int functionSearch(struct functionEntity* head, char *key)
{
	struct functionEntity* lookup = head;
	
	while(lookup != NULL)
	{
		if(lookup->Name == key)
		{
			return 1;
		}
		lookup = lookup->next;
	}
	return 0;
}

%}

%union {
	char *str;
}

%token PROGRAM <str>NAME ARRAY NUM COMP_OPERATOR AND OR STRLITERAL CHARLITERAL
%token TYPEDEF STRUCT ENDSTRUCT
%token VARS DATATYPE USERDATATYPE FUNCTION END_FUNCTION RETURN
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

program: program_declaration main_statement newline { printf("Code Parsed successfully!\n"); fprintf(diagnostics, "Code Parsed successfully!\n"); }
       | program_declaration function main_statement newline { printf("Code Parsed successfully!\n"); fprintf(diagnostics, "Code Parsed successfully!\n"); }
       | program_declaration struct_statement main_statement newline { printf("Code Parsed successfully!\n"); fprintf(diagnostics, "Code Parsed successfully!\n"); }
       | program_declaration struct_statement function main_statement newline { printf("Code Parsed successfully!\n"); fprintf(diagnostics, "Code Parsed successfully!\n"); }
       ;

program_declaration: PROGRAM NAME newline { progr = $2; }
                   ;
                   
struct_statement: STRUCT NAME newline struct_variable ENDSTRUCT
                | STRUCT NAME newline struct_variable ENDSTRUCT struct_statement
                | TYPEDEF STRUCT USERDATATYPE newline struct_variable USERDATATYPE ENDSTRUCT
                | TYPEDEF STRUCT USERDATATYPE newline struct_variable USERDATATYPE ENDSTRUCT struct_statement
                ;
                
struct_variable: VARS datatype NAME ';' newline
               | VARS datatype NAME ARRAY ';' newline
               | VARS datatype NAME ';' newline variable_declaration
               | VARS datatype NAME ARRAY ';' newline variable_declaration
               ;

main_statement: STARTMAIN commands ENDMAIN /*{ printf("MAIN Statement found\n"); }*/
              | STARTMAIN variable_declaration commands ENDMAIN /*{ printf("MAIN Statement found\n"); }*/
              ;
                   
variable_declaration: VARS datatype variable ';' newline /*{ printf("Variable Statement found\n"); }*/
                    | VARS datatype variable ';' newline variable_declaration /*{ printf("Variable Statement found\n"); }*/
                    ;
                    
function: function_declaration commands function_end newline /*{ printf("Function Statement found\n"); }*/
        | function_declaration variable_declaration commands function_end newline /*{ printf("Function Statement found\n"); }*/
        | function_declaration commands newline function_end newline function /*{ printf("Function Statement found\n"); }*/
        | function_declaration variable_declaration commands function_end newline function /*{ printf("Function Statement found\n"); }*/
        ;
         
function_declaration: FUNCTION function_name newline /*{ printf("Function Declared\n"); }*/
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
             
assignment: variable '=' expression ';' /*{ printf("Assignment statement found\n"); }*/
          | variable '=' expression ';' assignment /*{ printf("Assignment statement found\n"); }*/
          ;
          
loop_statement: while_statement
              | for_statement
              ;
              
break_command: BREAK ';' /*{ printf("Break command found\n"); }*/
             ;
             
control_statement: if_statement
                 | switch_statement
                 ;
          
while_statement: WHILE '(' condition ')' newline commands ENDWHILE /*{ printf("While Loop statement found\n"); }*/
               ;
               
condition: expression COMP_OPERATOR expression
         | expression AND expression
         | expression OR expression
         | '(' condition ')' COMP_OPERATOR '(' condition ')'
         | '(' condition ')' AND '(' condition ')'
         | '(' condition ')' OR '(' condition ')'
         ;
               
for_statement: FOR NAME ASSIGN_OPERATOR NUM TO NUM STEP NUM newline commands ENDFOR /*{ printf("For Loop statement found\n"); }*/
             ;
             
if_statement: IF '(' condition ')' THEN newline commands ENDIF /*{ printf("If statement found\n"); }*/
            | IF '(' condition ')' THEN newline commands else_if_statement ENDIF /*{ printf("If statement found\n"); }*/
            | IF '(' condition ')' THEN newline commands else_statement ENDIF /*{ printf("If statement found\n"); }*/
            | IF '(' condition ')' THEN newline commands else_if_statement else_statement ENDIF /*{ printf("If statement found\n"); }*/
            ;
            
else_if_statement: ELSEIF '(' condition ')' newline commands
                 | ELSEIF '(' condition ')' newline commands else_if_statement
                 ;
                 
else_statement: ELSE newline commands
              ;
              
switch_statement: SWITCH '(' expression ')' newline case ENDSWITCH /*{ printf("Switch statement found\n"); }*/
                | SWITCH '(' expression ')' newline case default ENDSWITCH /*{ printf("Switch statement found\n"); }*/
                ;
                
case: CASE '(' expression ')' ':' newline commands
    | CASE '(' expression ')' ':' newline commands case
    ;
    
default: DEFAULT ':' newline commands
       ;
       
print_statement: PRINT '(' STRLITERAL ')' ';' /*{ printf("Print Statement found\n"); }*/
               | PRINT '(' STRLITERAL ',' variable ')' ';' /*{ printf("Print Statement found\n"); }*/
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
          
datatype: DATATYPE
        | USERDATATYPE
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
    fprintf(diagnostics, "ERROR: %s in line %d\n", s, yylineno);
}									


int main (int argc, char **argv) 
{
	++argv; --argc;
	if ( argc > 0 )
	        yyin = fopen( argv[0], "r" );
	else
	        yyin = stdin;
	yyout = fopen ( "output.c", "w" );
	
	printf("C-like parser, implemented by Christos-Panagiotis Mpalatsouras, Student ID = 1054335\n");
	printf("Program source code from parser input is following: \n\n");
	
	diagnostics = fopen("diagnostics.txt", "w");
	fprintf(diagnostics, "**** START of Diagnostic Messages ****\n\n");
  
	yyparse ();
	
	printf("Program Name: %s\n", progr);
	fprintf(diagnostics, "Program: %s\n\n", progr);
	printf("Lines of code parsed: %i\n", line);
	fprintf(diagnostics, "Lines of code parsed: %i\n", line);
	fprintf(diagnostics, "\n**** END of Diagnostic Messages ****\n");
	fclose(diagnostics);
  
	return 0;
}
