#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "tableSymbols.h"


void initTable(tableSymbols *table){
    table->symbolArray = (data*) malloc(sizeof(data) * CAPACITY);
    table->actualDepth = 0;
    table->sizeData= 0;
    table->sizeTmp = 0;
    table->capacity = CAPACITY;
//  table->step = STEP;
}

void initTableCapacity(tableSymbols *table, int capacity){
    table->symbolArray = (data*) malloc(sizeof(data) * capacity);
    table->actualDepth = 0;
    table->sizeData = 0;
    table->sizeTmp = 0;
    table->capacity = capacity;
}

int addSymbol(tableSymbols *table, symbol symb){
    /* pour le moment on dit qu'on a pas besoin de redimensionner le tableau
    if (table->capacity == table->sizeData){ // if the array is full
        table->capacity += table->step;
        table->symbolArray = realloc(table->symbolArray, sizeDataof(data) * table->capacity);
    }
    */

    // if we have the space to append the symbol
    if (table->sizeData + table->sizeTmp < table->capacity){
        // append the symbol at the end of the array
        table->symbolArray[table->sizeData].symb = symb;
        table->symbolArray[table->sizeData].symb.address = table->sizeData;
        table->symbolArray[table->sizeData].depth = table->actualDepth;
        printf("symbol address: %d\n", table->symbolArray[table->sizeData].symb.address);
        table->sizeData++;
    }else{
        printf("no more place in the array to insert element");
    }
    return table->sizeData - 1;
}

void exitTable(tableSymbols *table){
    
    if (table->actualDepth > 0)
        table->actualDepth--;
    
    while (table->sizeData > 0 && table->symbolArray[table->sizeData - 1].depth > table->actualDepth){
        table->sizeData--; // les anciennes entrées ne sont pas vraiment effacées :p
    }
}

int containsSymbol(tableSymbols *table, char *name){
    int index = 0;
    bool found = false;

    while (!found && index < table->sizeData){
        if ((strcmp(table->symbolArray[index].symb.name, name) != 0) && (table->symbolArray[index].depth >= table->fctDepth || table->symbolArray[index].depth == 0))
            index++;
        else
            found = true;
    }

    return found ? index : -1;
}

symbol getSymbol(tableSymbols *table, int index){
    return table->symbolArray[index].symb;
}

int addTmp(tableSymbols *table, char type){
    symbol tmp;
    tmp.type = type;
    if (table->sizeData + table->sizeTmp < table->capacity){
        tmp.address = table->capacity - table->sizeTmp - 1;
        table->symbolArray[table->capacity - table->sizeTmp++ - 1].symb = tmp;
        printf("tmp address: %d\n", table->symbolArray[table->capacity - table->sizeTmp].symb.address);
    }else{
        printf("no more space for symbol");
    }

    return tmp.address;
}

symbol popTmp(tableSymbols *table){
    // peut être vérifier qu'on essaye pas de suprimer alors qu'il n'y a rien
   return table->symbolArray[table->capacity - table->sizeTmp--].symb;
}

symbol peekTmp(tableSymbols *table){
    // peut être vérifier qu'on essaye pas de suprimer alors qu'il n'y a rien
   return table->symbolArray[table->capacity - table->sizeTmp + 1].symb;
}

void printTable(tableSymbols *table){
    printf("sizeData: %d\n", table->sizeData);
}

void freeTable(tableSymbols *table){
    table->sizeData = table->actualDepth = table->sizeTmp = 0;
}

int increaseFctDepth(tableSymbols *table) {
		table->fctDepth = ++(table->actualDepth);
}

int increaseActualDepth(tableSymbols *table) {
		table->actualDepth++;
}
