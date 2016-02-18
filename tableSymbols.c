#include <stdio.h>
#include <stdlib.h>
#include "tableSymbols.h"

void initTable(tableSymbols *table, int length){
    table->symbolArray = (symbol*) malloc(sizeof(symbol) * length);
    table->actualDepth = 0;
    table->size = 0;
    
}

void addSymbol(tableSymbols *table, symbol symb){

}

void enter(tableSymbols *table){
    table->actualDepth++;
}
