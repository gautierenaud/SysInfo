#include <stdlib.h>
#include <stdio.h>
#include "tableInstructions.h"
#include "utils.h"


// multiply the size by 2
void resizeInstructionTable(tableInstruction *table){
    table->capacity *= 2;

    table->instructions = (int **) realloc(table->instructions, table->capacity * sizeof(*table->instructions));
}

void printInstructionTable(tableInstruction *table){
    printf("size of the instruct table: %d\n", table->size);
    int i, j, lim = table->size;
    for (i = 0; i < lim; i++){
        printf("[%d] \t%s", i, intToCode(table->instructions[i][0]));
        for (j = 1; j <= table->instructions[i][4]; j++){
            printf(" %d", table->instructions[i][j]);
        }
        printf("\n");
    }
}

void printInstructionLine(tableInstruction *table, int index){
    int i;
    printf("\t%s", intToCode(table->instructions[index][0]));
    for (i = 1; i <= table->instructions[index][4]; i++){
         printf(" %d", table->instructions[index][i]);
    }
    printf("\n");
}

void initInstructionTable(tableInstruction *table){
    table->size = 0;
    table->capacity = INSTRUCTION_CAPACITY;
    table->instructions = (int **) malloc(table->capacity * sizeof(int));
}

void freeInstructionTable(tableInstruction *table){
    int i;
    for (i = 0; i < table->size; i++){
        free(table->instructions[i]);
    }
    free(table->instructions);
    free(table);
}

int addInstructParams0(tableInstruction *table, int action){
    if (table->size == table->capacity)
        resizeInstructionTable(table);
    int tmpInstruct[5] = {action, 0, 0, 0, 0};

    return addInstructLine(table, tmpInstruct);
}

int addInstructParams1(tableInstruction *table, int action, int param1){
    if (table->size == table->capacity)
        resizeInstructionTable(table);
    int tmpInstruct[5] = {action, param1, 0, 0, 1};

    return addInstructLine(table, tmpInstruct);
}

int addInstructParams2(tableInstruction *table, int action, int param1, int param2){
    if (table->size == table->capacity)
        resizeInstructionTable(table);
    int tmpInstruct[5] = {action, param1, param2, 0, 2};

    return addInstructLine(table, tmpInstruct);
}

int addInstructParams3(tableInstruction *table, int action, int param1, int param2, int param3){
    if (table->size == table->capacity)
        resizeInstructionTable(table);
    int tmpInstruct[5] = {action, param1, param2, param3, 3};

    return addInstructLine(table, tmpInstruct);
}

int addInstructLine(tableInstruction *table, int instruct[5]){
    table->instructions[table->size] = (int *) malloc(5 * sizeof(int));
    int i;
    for (i = 0; i < 5; i++){
        table->instructions[table->size][i] = instruct[i];
    }
    return table->size++;
}

void completeFromLabel(tableInstruction *table, tableLabels *tableLbl){
   int i;
   for (i = 0; i < tableLbl->size; i++){
       if (table->instructions[tableLbl->labels[i][0]][0] == 8)
           table->instructions[tableLbl->labels[i][0]][2] = tableLbl->labels[i][1];
       else
           table->instructions[tableLbl->labels[i][0]][1] = tableLbl->labels[i][1];

   }
}

void printInstructsToFile(tableInstruction *table, FILE *output){
    int i, j;
    for (i = 0; i < table->size; i++){
        fprintf(output, "%c", intToHex(table->instructions[i][0]));
        for(j = 1; j <= table->instructions[i][4]; j++){
            fprintf(output, " %d", table->instructions[i][j]);
        }
        fprintf(output, "\n");
    }
}
