/* Created by Christos-Panagiotis Balatsouras, StudentID = 1054335
   CEID - University of Patras */
/*Program declaration*/
PROGRAM Sorting_Algorithms %This is a test program for lexer and parser development purposes
/*Struct declaration*/
TYPEDEF STRUCT Node
	VARS INTEGER value;
	VARS Node prev;
	VARS Node next;
Node ENDSTRUCT 
/*Function declaration*/ 
FUNCTION BubbleSort(K, m)
	VARS INTEGER i,j,head,head2,temp;
	VARS INTEGER K_i,K_i_plus_1,K_m;
	i = 0;
	j = 0;
	head = m;
	WHILE (head > 1)
		j = 0;
		head2 = head - 1;
		PRINT("Sorting elements 0 --> %d, ", head2);
		FOR i:=0 TO 20 STEP 1
			IF (K_i > K_i_plus_1) THEN
				temp = K_i_plus_1;
				K_i_plus_1 = K_i;
				K_i = temp;
				j = j + 1;
			ENDIF
		ENDFOR
		PRINT("Element swaps in the current table scan: %d\n", j);
		IF (j == 0) THEN
			PRINT("No swap during last table scan. The table sorting completed successfully\n");
			BREAK;
		ENDIF
		head = head - 1;
	ENDWHILE
RETURN K_m END_FUNCTION
FUNCTION InsertionSort(K, m)
	VARS INTEGER i,j,k,K_i,K_i_plus_1,K_j,K_m;
	i = 0;
	j = 0;
	k = 0;
	FOR j:=2 TO 20 STEP 1
		PRINT("Sorting elements 0 --> %d\n", j);
		k = K_j;
		i = j - 1;
		WHILE ((i > 0) AND (k < K_i))
			K_i_plus_1 = K_i;
			i = i - 1;
		ENDWHILE
		K_i_plus_1 = k;
	ENDFOR
RETURN K_m END_FUNCTION
/*Main part of program*/
STARTMAIN VARS INTEGER n,i,c,A[20];
	VARS INTEGER values[20];
	VARS INTEGER option;
	VARS INTEGER A_n,A_i;
	n = 20;
	A[20] = values;
	PRINT("Initial Table: \n");
	FOR i:=0 TO 20 STEP 1
		PRINT("%d ", A_i);
	ENDFOR
	PRINT("\nOptions: \n");
	PRINT("1. Bubble-Sort:\n");
	PRINT("2. Insertion-Sort:\n");
	PRINT("Select Algorithm >> "); %scanf an option from keyboard
	SWITCH (option)
	CASE (1):
		A_n = BubbleSort(A,n);
		PRINT("Results: \n");
		FOR i:=0 TO 20 STEP 1
			PRINT("%d ", A_i);
		ENDFOR
		PRINT("\n");
	CASE (2):
		A_n = InsertionSort(A,n);
		PRINT("Results: \n");
		FOR i:=0 TO 20 STEP 1
			PRINT("%d ", A_i);
		ENDFOR
		PRINT("\n");
	DEFAULT:
		PRINT("No option selected\n");
	ENDSWITCH
ENDMAIN
