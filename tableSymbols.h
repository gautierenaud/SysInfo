#ifndef _TABLE_SYMBOLS_
#define _TABLE_SYMBOLS_

#include <string.h>
#include "symbols.h"

typedef struct{
    symbol *symbolArray;
    int size; // number of elements inside


    int actualDepth;
} tableSymbols;

// initialise la table des symboles
void initTable(tableSymbols *table, int length);

// ajoute un élément à la table
void addSymbol(tableSymbols *table, symbol symb);

// entre dans une nouvelle profondeur 
void enter(tableSymbols *table);


// sort d'une profondeur
void exit();

#endif
