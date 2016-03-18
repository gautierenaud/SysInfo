#include "interpreteur.h"
#include <stdio.h>

// global variables:

int pc;
int mem[256];

void executeInstructions(tableInstruction *table){
    pc = 0;
    while (pc < table->size){
        execLine(table->instructions[pc]);
        pc++;
    }
}

void execLine(int * line){
    int tmp;
    switch (line[0]){
        case 1: // ADD
            mem[line[1]] = mem[line[2]] + mem[line[3]];
            break;
        case 2: // MUL
            mem[line[1]] = mem[line[2]] * mem[line[3]];
            break;
        case 3: // SOU
            mem[line[1]] = mem[line[2]] - mem[line[3]];
            break;
        case 4: // DIV
            mem[line[1]] = mem[line[2]] / mem[line[3]];
            break;
        case 5: // COP
            mem[line[1]] = mem[line[2]];
            break;
        case 6: // AFC
            mem[line[1]] = line[2];
            break;
        case 7: // JMP
            pc = line[1];
            break;
        case 8: // JMF
            if (mem[line[1]] == 0)
                pc = line[2];
            break;
        case 9: // INF
            if (mem[line[2]] < mem[line[3]])
                mem[line[1]] = 1;
            else
                mem[line[1]] = 0;
            break;
        case 10: // SUP
            if (mem[line[2]] > mem[line[3]])
                mem[line[1]] = 1;
            else
                mem[line[1]] = 0;
            break;
        case 11: // EQU
            if (mem[line[2]] == mem[line[3]])
                mem[line[1]] = 1;
            else
                mem[line[1]] = 0;
            break;
        case 12:
            printf("%d\n", mem[line[1]]);
            break;
    }
}

void printMem(){
    int i;
    for (i = 0; i < 256; i++){
        printf("[inter] mem[%d] = %d\n", i, mem[i]);
    }
}
