#ifndef _TABLE_INSTRUCTIONS_
#define _TABLE_INSTRUCTIONS_

#include <stdio.h>
#include "tableLabels.h"

#define INSTRUCTION_CAPACITY 300

typedef struct{
    // capacité de 5 car 1 pour le code, 3 pour les paramètres et 1 pour le nombre de paramètres
    //int instructions[INSTRUCTION_CAPACITY][5];
    int **instructions;
    int size; // number of elements
    int capacity;
}tableInstruction;

void initInstructionTable(tableInstruction *table);
void freeInstructionTable(tableInstruction *table);
void resizeInstructionTable(tableInstruction *table);
void printInstructionTable(tableInstruction *table);
void printInstructionLine(tableInstruction *table, int index);

int addInstructParams0(tableInstruction *table, int action);
int addInstructParams1(tableInstruction *table, int action, int param1);
int addInstructParams2(tableInstruction *table, int action, int param1, int param2);
int addInstructParams3(tableInstruction *table, int action, int param1, int param2, int param3);

// complete the second arguments of the jump instruction
void completeFromLabel(tableInstruction *table, tableLabels *tableLbl);

void printInstructsToFile(tableInstruction *table, FILE *output);
#endif
