#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "tableSymbols.h"


void initSymbTable(tableSymbols *table){
    table->symbolArray = (data*) malloc(sizeof(data) * CAPACITY);
    table->actualDepth = 0;
    table->sizeData= 0;
    table->capacity = CAPACITY;
}

int addSymbol(tableSymbols *table, symbol symb){
    // if we have the space to append the symbol
    if (table->sizeData < table->capacity){
        // append the symbol at the end of the array
        table->symbolArray[table->sizeData].symb = symb;
        table->symbolArray[table->sizeData].symb.address = table->sizeData;
        table->symbolArray[table->sizeData].depth = table->actualDepth;
        table->sizeData++;
        return table->sizeData - 1;
    }else{
        printf("[symbols] no more place in the array to insert element\n");
        return -1;
    }
}

// for symbols that will take several places in the memory
int addSymbolSize(tableSymbols *table, symbol symb, int size){
    // if we have the space to append the symbol
    if (table->sizeData + size - 1 < table->capacity){
        // append the symbol at the end of the array
        table->symbolArray[table->sizeData].symb = symb;
        table->symbolArray[table->sizeData].symb.address = table->sizeData;
        table->symbolArray[table->sizeData].depth = table->actualDepth;
        table->sizeData += size;
        return table->sizeData - size;
    }else{
        printf("[symbols] no more place in the array to insert element\n");
        return -1;
    }
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
    return addSymbol(table, tmp);
}

symbol popTmp(tableSymbols *table){
    // peut être vérifier qu'on essaye pas de suprimer alors qu'il n'y a rien
   return table->symbolArray[table->sizeData--].symb;
}

symbol peekTmp(tableSymbols *table){
    // peut être vérifier qu'on essaye pas de suprimer alors qu'il n'y a rien
   return table->symbolArray[table->sizeData - 1].symb;
}

void printTable(tableSymbols *table){
    int index = 0;
    symbol tmpSymb;
    printf("print Table, sizeData: %d\n ", table->sizeData);
    while (index < table->sizeData){
        tmpSymb = table->symbolArray[index].symb;
        printf("\tname: %s; addr: %d;\n", tmpSymb.name, index);
        index++;
    }
    printf("\n");
}

void freeTable(tableSymbols *table){
    table->sizeData = table->actualDepth = 0;
}

int increaseFctDepth(tableSymbols *table) {
		table->fctDepth = ++(table->actualDepth);
}

int increaseActualDepth(tableSymbols *table) {
		table->actualDepth++;
}
