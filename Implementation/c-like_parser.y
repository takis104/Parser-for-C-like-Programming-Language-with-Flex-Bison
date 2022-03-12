
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define YYERROR_VERBOSE 1

int yylex(); /*this code line added to avoid the "implicit declaration of function ‘yylex’"*/
void yyerror(const char *); /*this code line added to avoid the "passing argument 1 of ‘yyerror’ discards ‘const’ qualifier from pointer target type" */
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;
int line = 0;
FILE *diagnostics;
char *progr;

struct variableEntity
{
	char *Name;
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
		printf("Variable Name: %s\n", node->Name);
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

void variableListAppend(struct variableEntity** head_rf, char *name)
{
	struct variableEntity* new_var = (struct variableEntity*) malloc(sizeof(struct variableEntity));
	struct variableEntity *end = *head_rf;
	
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
		if(strcmp(lookup->Name, key) == 0)
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
		if(strcmp(lookup->Name, key) == 0)
		{
			return 1;
		}
		lookup = lookup->next;
	}
	return 0;
}

struct variableEntity* variables = NULL;
struct functionEntity* functions = NULL;

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

variable_declaration: VARS datatype declared_variables ';' newline
                    | variable_declaration VARS datatype declared_variables ';' newline
                    ;

declared_variables: NAME { if(variableSearch(variables, $1) == 0){ variableListAppend(&variables, $1); } }
                  | NAME ARRAY { if(variableSearch(variables, $1) == 0){variableListAppend(&variables, $1); } }
                  | declared_variables ',' declared_variables
                  ;

struct_statement: STRUCT NAME newline struct_variable ENDSTRUCT
                | struct_statement STRUCT NAME newline struct_variable ENDSTRUCT
                | TYPEDEF STRUCT USERDATATYPE newline struct_variable USERDATATYPE ENDSTRUCT
                | struct_statement TYPEDEF STRUCT USERDATATYPE newline struct_variable USERDATATYPE ENDSTRUCT
                ;

struct_variable: VARS datatype NAME ';' newline { if(variableSearch(variables, $3) == 0){ variableListAppend(&variables, $3); } }
               | VARS datatype NAME ARRAY ';' newline { if(variableSearch(variables, $3) == 0) { variableListAppend(&variables, $3); } }
               | struct_variable VARS datatype NAME ';' newline { if(variableSearch(variables, $4) == 0) { variableListAppend(&variables, $4); } }
               | struct_variable VARS datatype NAME ARRAY ';' newline { if(variableSearch(variables, $4) == 0) { variableListAppend(&variables, $4); } }
               ;

function: function_declaration commands function_end newline /*{ printf("Function Statement found\n"); }*/
        | function_declaration variable_declaration commands function_end newline /*{ printf("Function Statement found\n"); }*/
        | function function_declaration commands newline function_end newline /*{ printf("Function Statement found\n"); }*/
        | function function_declaration variable_declaration commands function_end newline /*{ printf("Function Statement found\n"); }*/
        ;

function_declaration: FUNCTION function_name newline /*{ printf("Function Declared\n"); }*/
                    ;

function_name: NAME '(' function_arguments ')' { if(functionSearch(functions, $1) == 0) { functionListAppend(&functions, $1); } }
             ;

function_statement: NAME '(' variable ')' { if(functionSearch(functions, $1) == 0) { printf("\nERROR: Function %s is NOT declared, in line %d\n",$1,yylineno); fprintf(diagnostics,"ERROR: Function %s is NOT declared, in line %d\n",$1,yylineno); YYABORT; } }
                  ;
             
function_arguments: NAME { if(variableSearch(variables, $1) == 0) { variableListAppend(&variables, $1); } }
                  | function_arguments ',' function_arguments
                  ;

function_end: RETURN NUM END_FUNCTION
            | RETURN CHARLITERAL END_FUNCTION
            | RETURN variable END_FUNCTION
            ;

main_statement: STARTMAIN commands ENDMAIN /*{ printf("MAIN Statement found\n"); }*/
              | STARTMAIN variable_declaration commands ENDMAIN /*{ printf("MAIN Statement found\n"); }*/
              ;

command: assignment
       | print_statement
       | loop_statement
       | break_command
       | control_statement
       ;
       
commands: command newline
        | commands command newline
        ;

assignment: variable '=' expression ';'
          | assignment variable '=' expression ';'
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

for_statement: FOR NAME ASSIGN_OPERATOR NUM TO NUM STEP NUM newline commands ENDFOR { if(variableSearch(variables, $<str>2) == 0) { printf("\nERROR: Variable %s is NOT declared, in line %d\n",$<str>2,yylineno); fprintf(diagnostics,"ERROR: Variable %s is NOT declared, in line %d\n",$<str>2,yylineno); YYABORT; } }
             ;

if_statement: IF '(' condition ')' THEN newline commands ENDIF /*{ printf("If statement found\n"); }*/
            | IF '(' condition ')' THEN newline commands else_if_statement ENDIF /*{ printf("If statement found\n"); }*/
            | IF '(' condition ')' THEN newline commands else_statement ENDIF /*{ printf("If statement found\n"); }*/
            | IF '(' condition ')' THEN newline commands else_if_statement else_statement ENDIF /*{ printf("If statement found\n"); }*/
            ;
            
else_if_statement: ELSEIF '(' condition ')' newline commands
                 | else_if_statement ELSEIF '(' condition ')' newline commands
                 ;

else_statement: ELSE newline commands
              ;

switch_statement: SWITCH '(' expression ')' newline case ENDSWITCH /*{ printf("Switch statement found\n"); }*/
                | SWITCH '(' expression ')' newline case default ENDSWITCH /*{ printf("Switch statement found\n"); }*/
                ;

case: CASE '(' expression ')' ':' newline commands
    | case CASE '(' expression ')' ':' newline commands
    ;

default: DEFAULT ':' newline commands
       ;

print_statement: PRINT '(' STRLITERAL ')' ';' /*{ printf("Print Statement found\n"); }*/
               | PRINT '(' STRLITERAL ',' variable ')' ';' /*{ printf("Print Statement found\n"); }*/
               ;

expression: literal
          | variable
          | function_statement
          | expression '+' expression
          | expression '-' expression
          | expression '^' expression
          | expression '*' expression
          | expression '/' expression
          | '(' expression ')'
          ;

variable: NAME { if(variableSearch(variables, $<str>1) == 0) { printf("\nERROR: Variable %s is NOT declared, in line %d\n",$<str>1,yylineno); fprintf(diagnostics,"ERROR: Variable %s is NOT declared, in line %d\n",$<str>1,yylineno); YYABORT; } }
        | NAME ARRAY { if(variableSearch(variables, $<str>1) == 0) { printf("\nERROR: Variable %s is NOT declared, in line %d\n",$<str>1,yylineno); fprintf(diagnostics,"ERROR: Variable %s is NOT declared, in line %d\n",$<str>1,yylineno); YYABORT; } }
        | variable ',' variable
        ;

datatype: DATATYPE
        | USERDATATYPE
        ;

literal: NUM
       | STRLITERAL
       | CHARLITERAL
       ;

newline: NEWLINE /*{ line++; }*/
       ;

%%

void yyerror(const char *s)
{
    fprintf(stderr, "ERROR: %s in line %d\n", s, yylineno);
    fprintf(diagnostics, "ERROR: %s in line %d\n", s, yylineno);
}									

int main (int argc, char **argv) 
{
	++argv;
	--argc;
	if ( argc > 0 )
	{
		yyin = fopen( argv[0], "r" );
	}
	else
	{
		yyin = stdin; 
	}
	yyout = fopen ( "output.c", "w" );
	
	printf("C-like parser, implemented by Christos-Panagiotis Mpalatsouras, Student ID = 1054335\n");
	printf("Program source code from parser input is following: \n\n");
	
	diagnostics = fopen("diagnostics.txt", "w");
	fprintf(diagnostics, "**** START of Diagnostic Messages ****\n\n");
  
	yyparse();
	
	printf("Program Name: %s\n", progr);
	fprintf(diagnostics, "Program: %s\n\n", progr);
	printf("Lines of code scanned and parsed: %i\n", yylineno);
	fprintf(diagnostics, "Lines of code scanned and parsed: %i\n", yylineno);
	fprintf(diagnostics, "\n**** END of Diagnostic Messages ****\n");
	fclose(diagnostics);
	
	printf("\nVariable List Items: \n");
	printVariableList(variables);
	
	printf("\nFunction List Items: \n");
	printFunctionList(functions);
	
	free(variables);
	free(functions);
  
	return 0;
}
