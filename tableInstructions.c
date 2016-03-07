#include <stdlib.h>
#include <stdio.h>
#include "tableInstructions.h"
#include "utils.h"


// multiply the size by 2
void resizeInstructionTable(tableInstruction *table){
    table = realloc(table, sizeof(*table) * 2);
    table->capacity *= 2;
}

void printInstructionTable(tableInstruction *table){
    printf("size of the table: %d\n", table->size);
    /*
    int i, j;
    for (i = 0; i < table->size; i++){
        for (j = 0; j < 4; j++){
            if (j == 0)
                printf("%c ", intToHex(table->instructions[i][j]));
            else
                printf("%d ", table->instructions[i][j]);
        }
        printf("\n");
    }*/
}

void initInstructionTable(tableInstruction *table){
    table = (tableInstruction*) malloc(sizeof(tableInstruction));
    table->size = 0;
    table->capacity = INSTRUCTION_CAPACITY;
}

void freeInstructionTable(tableInstruction *table){
    free(table->instructions);
    free(table);
}

int addInstructParams1(tableInstruction *table, int action, int param1){
    if (table->size == table->capacity)
        resizeInstructionTable(table);
    table->instructions[table->size][0] = action;
    table->instructions[table->size][1] = param1;
    table->instructions[table->size][2] = 0;
    table->instructions[table->size][3] = 0;
    table->instructions[table->size][4] = 1;

    return table->size++;
}

int addInstructParams2(tableInstruction *table, int action, int param1, int param2){
    if (table->size == table->capacity)
        resizeInstructionTable(table);
    table->instructions[table->size][0] = action;
    table->instructions[table->size][1] = param1;
    table->instructions[table->size][2] = param2;
    table->instructions[table->size][3] = 0;
    table->instructions[table->size][4] = 2;

    return table->size++;
}

int addInstructParams3(tableInstruction *table, int action, int param1, int param2, int param3){
    if (table->size == table->capacity)
        resizeInstructionTable(table);
    table->instructions[table->size][0] = action;
    table->instructions[table->size][1] = param1;
    table->instructions[table->size][2] = param2;
    table->instructions[table->size][3] = param3;
    table->instructions[table->size][4] = 3;

    return table->size++;
}

void printInstructsToFile(tableInstruction *table, FILE *output){
    int i, j;
    for (i = 0; i < table->size; i++){
        fprintf(output, "%c", intToHex(table->instructions[i][0]));
        for(j = 1; j <= table->instructions[i][4]; j++){
            fprintf(output, " %d", table->instructions[i][j]);
        }
    }
}
