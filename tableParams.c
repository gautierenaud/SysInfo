#include <stdio.h>
#include <stdlib.h>
#include "tableParams.h"

const tableParams INIT_PARAMS_TABLE = {
    .size = 0, .startAddress = -3
};

void addParam(tableParams *table, symbol symb){
    // if we have enough space
    if (table->size < PARAM_SIZE){
        table->paramList[table->size] = symb;
        table->size++;
        int i;
        for (i = 0; i < table->size; i++){
            table->paramList[i].address = table->startAddress - (table->size - i - 1);
        }
    }else{
        printf("Too much parameters!\n");
        exit(-1);
    }
}

int getParam(tableParams *table, char *name){
    int index = 0;
    bool found = false;

    while (!found && index < table->size){
        if ((strcmp(table->paramList[index].name, name) != 0))
            index++;
        else
            found = true;
    }

    return found ? index : -1;
}

void printParamTable(tableParams *table){
    printf("paramTable; size : %d, startAddress : %d\n", table->size, table->startAddress);
    int i;
    for (i = 0; i < table->size; i++){
        printf("\tname: %s, addr: %d\n", table->paramList[i].name, table->paramList[i].address);
    }
}
