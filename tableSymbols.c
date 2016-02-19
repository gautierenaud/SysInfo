#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "tableSymbols.h"

#define STEP 10;

void initTable(tableSymbols *table, int capacity){
    table->symbolArray = (data*) malloc(sizeof(data) * capacity);
    table->actualDepth = 0;
    table->size = 0;
    table->capacity = capacity;
    table->step = STEP;
}

void addSymbol(tableSymbols *table, symbol symb){
    if (table->capacity == table->size){ // if the array is full
        table->capacity += table->step;
        table->symbolArray = realloc(table->symbolArray, sizeof(data) * table->capacity);
    }

    // append the symbol at the end of the array
    table->symbolArray[table->size++].symb = symb;
    table->symbolArray[table->size - 1].depth = table->actualDepth;
}

void enterTable(tableSymbols *table){
    table->actualDepth++;
}

void exitTable(tableSymbols *table){
    
    if (table->actualDepth > 0)
        table->actualDepth--;
    
    while (table->size > 0 && table->symbolArray[table->size - 1].depth > table->actualDepth){
        table->size--; // les anciennes entrées ne sont pas vraiment effacées :p
    }
}

int containsSymbol(tableSymbols *table, char *name){
    int index = 0;
    bool found = false;

    while (!found && index < table->size){
        if (strcmp(table->symbolArray[index].symb.name, name) != 0)
            index++;
        else
            found = true;
    }

    return found ? index : -1;
}

symbol getSymbol(tableSymbols *table, int index){
    return table->symbolArray[index].symb;
}

void freeTable(tableSymbols *table){
    free(table->symbolArray);
    table->size = table->actualDepth = table->capacity = 0;
}
