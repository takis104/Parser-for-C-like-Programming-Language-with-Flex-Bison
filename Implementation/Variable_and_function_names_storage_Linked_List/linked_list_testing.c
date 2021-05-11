/* Linked List implementation for variable names storage*/

#include <stdio.h>
#include <stdlib.h>

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

int main()
{
	/*Example Driver Program for testing Linked Lists*/
	struct variableEntity* head = NULL;
	struct functionEntity* head2 = NULL;
	
	variableListAppend(&head, "var1");
	variableListAppend(&head, "var2");
	variableListAppend(&head, "var3");
	functionListAppend(&head2, "funcName");
	
	if(variableSearch(head, "var4") == 0) 
	{
		variableListAppend(&head, "var4");
	}
	
	printf("Variable List Items: \n");
	printVariableList(head);
	
	printf("Function List Items: \n");
	printFunctionList(head2);
	
	if(variableSearch(head, "var2") == 1) 
	{
		printf("Variable Found\n");
	}
	else
	{
		printf("Variable NOT Found\n");
	}
	
	if(functionSearch(head2, "funcName") == 1)
	{
		printf("Function Found\n");
	}
	else
	{
		printf("Function NOT Found\n");
	}
	
	return 0;
}
