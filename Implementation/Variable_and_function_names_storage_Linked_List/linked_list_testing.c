/* Linked List implementation for variable names storage*/

#include <stdio.h>
#include <stdlib.h>

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

int main()
{
	/*Example Driver Program for testing Linked Lists*/
	struct variableEntity* head = NULL;
	struct functionEntity* head2 = NULL;
	
	variableListAppend(&head, "var1", "INTEGER");
	variableListAppend(&head, "var2", "INTEGER");
	variableListAppend(&head, "var3", "CHAR");
	functionListAppend(&head2, "funcName");
	
	printf("Variable List Items: \n");
	printVariableList(head);
	
	printf("Function List Items: \n");
	printFunctionList(head2);
	
	return 0;
}
