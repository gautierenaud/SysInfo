#ifndef _PARAM_TABLE_
#define _PARAM_TABLE_

#include "symbols.h"

#define PARAM_SIZE 10

// table to handle the parameters
typedef struct{
    symbol paramList[PARAM_SIZE];
    int size; // number of elements
    int startAddress; // start of the addressing
}tableParams;

const tableParams INIT_PARAMS_TABLE;

// add a symbol and update the address of all previously added symbols
void addParam(tableParams *table, symbol symb);

// return the index of the param, -1 otherwise
int getParam(tableParams *table, char *name);

void printParamTable(tableParams *table);

#endif
