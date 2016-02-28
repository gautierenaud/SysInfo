#ifndef _TABLE_symbFctS_
#define _TABLE_symbFctS_

#include <string.h>

#define CAPACITY 256

typedef struct{
    char *name;
    char type;
    char *params;
}symbFct;

// append declared variables at the beginning of the array 
typedef struct{
    symbFct *symbFctArray;
    int sizeData; // number of elements inside
    int capacity; // number of element it can hold
} tableSymbFcts;

// initialise la table des symbFctes
void initFctTable(tableSymbFcts *table);
void initFctTableCapacity(tableSymbFcts *table, int capacity);

// add an element in the table
int addSymbFct(tableSymbFcts *table, symbFct symb);

// efface le tableau
void freeFctTable(tableSymbFcts *table);

// return -1 if absent and the index otherwise
int containsSymbFct(tableSymbFcts *table, char* name, char *params);

symbFct getSymbFct(tableSymbFcts *table, int index);

void printFctTable(tableSymbFcts *table);

#endif
