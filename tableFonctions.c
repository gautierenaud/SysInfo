#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "tableFonctions.h"

void initFctTable(tableSymbFcts *table){
    table->symbFctArray = (symbFct*) malloc(sizeof(symbFct) * CAPACITY);
    table->sizeData = 0;
    table->capacity = CAPACITY;
}

void initFctTableCapacity(tableSymbFcts *table, int capacity){
    table->symbFctArray = (symbFct*) malloc(sizeof(symbFct) * capacity);
    table->sizeData = 0;
    table->capacity = capacity;
}

int addSymbFct(tableSymbFcts *table, symbFct symb){

    if (table->sizeData < table->capacity){
        // append the symbol at the end of the array
        table->symbFctArray[table->sizeData++] = symb;
    }else{
        printf("no more place in the array to insert element");
    }
    return table->sizeData - 1;

}

int containsSymbFct(tableSymbFcts *table, char *name, char *params){
    int index = 0;
    bool found = false;
    symbFct tmpSymb;

    while (index < table->sizeData && !found){
        tmpSymb = table->symbFctArray[index];
        if (strcmp(tmpSymb.name, name) != 0 && strcmp(tmpSymb.params, params) != 0)
            index++;
        else
            found = true;
    }

    return found ? index : -1;
}

symbFct getSymbFct(tableSymbFcts *table, int index){
    return table->symbFctArray[index];
}

void printFctTable(tableSymbFcts *table){
    printf("[function table] elements: %d\n", table->sizeData);
    int i;
    for (i = 0; i < table->sizeData; i++){
        printf("\t @%d name: %s \t\tparams: %s\n", i, table->symbFctArray[i].name, table->symbFctArray[i].params);
    }
}


void freeFctTable(tableSymbFcts *table){
    table->sizeData = 0;
    free(table->symbFctArray);
}
