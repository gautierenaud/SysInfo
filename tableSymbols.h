#ifndef _TABLE_SYMBOLS_
#define _TABLE_SYMBOLS_

#include <string.h>
#include "symbols.h"

#define CAPACITY 256

typedef struct{
    symbol symb;
    int depth;
}data;

// append declared variables at the beginning of the array, temporary variables at the end
typedef struct{
    data *symbolArray;
    int sizeData; // number of elements inside
    int sizeTmp; // number of temporary variables
    int actualDepth;
    int capacity; // number of element it can hold

    // int step;   // step by which we will increase the size of the array

} tableSymbols;

// initialise la table des symboles
void initTable(tableSymbols *table);
void initTableCapacity(tableSymbols *table, int capacity);

// add an element in the table
int addSymbol(tableSymbols *table, symbol symb);

// we must go deeper
void enterTable(tableSymbols *table);

// sort d'une profondeur, et efface les variables de la profondeur sortante
void exitTable(tableSymbols *table);

// efface le tableau
void freeTable(tableSymbols *table);

// return -1 if absent and the index otherwise
int containsSymbol(tableSymbols *table, char* name);

symbol getSymbol(tableSymbols *table, int index);

void printTable(tableSymbols *table);

// ajoute un symbole temporaire à la fin de la liste
int addTmp(tableSymbols *table, char type);

// remove the last temporary variable
symbol popTmp(tableSymbols *table);

// return the last tmp variable
symbol peekTmp(tableSymbols *table);

#endif
