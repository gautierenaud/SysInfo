#ifndef _TABLE_SYMBOLS_
#define _TABLE_SYMBOLS_

#include <string.h>
#include "symbols.h"

typedef struct{
    symbol symb;
    int depth;
}data;

typedef struct{
    data symbolArray[256];
    int size; // number of elements inside
    // int capacity; // number of element it can hold
    // int step;   // step by which we will increase the size of the array

    int actualDepth;

    int tmpNum; // number of temporary variables
} tableSymbols;

// initialise la table des symboles
void initTable(tableSymbols *table);

// ajoute un élément à la table
int addSymbol(tableSymbols *table, symbol symb);

// entre dans une nouvelle profondeur 
void enterTable(tableSymbols *table);

// sort d'une profondeur, et efface les variables de la profondeur sortante
void exitTable(tableSymbols *table);

// efface le tableau
void freeTable(tableSymbols *table);

// return -1 if absent and the index otherwise
int containsSymbol(tableSymbols *table, char* name);

symbol getSymbol(tableSymbols *table, int index);

void printTable(tableSymbols *table);

//int addTmp(tableSymbols *table, 

#endif
