#include "interpreteur.h"
#include <stdio.h>

// global variables:

int pc;
int mem[256];
int reg[5]; 
/* reg[0] = ebp
	 reg[1] = return
	 reg[2] = 
	 reg[3] = 
	 reg[4] = 
*/

void executeInstructions(tableInstruction *table){
    pc = 0;
    reg[0] = 0; // initialize ebp to 0 (bottom of the stack)
    while (pc < table->size){
        execLine(table->instructions[pc]);
        pc++;
    }
}

void execLine(int * line){
    int tmp;
    switch (line[0]){
        case 1: // ADD
            mem[reg[0] + line[1]] = mem[reg[0] + line[2]] + mem[reg[0] + line[3]];
            break;
        case 2: // MUL
            mem[reg[0] + line[1]] = mem[reg[0] + line[2]] * mem[reg[0] + line[3]];
            break;
        case 3: // SOU
            mem[reg[0] + line[1]] = mem[reg[0] + line[2]] - mem[reg[0] + line[3]];
            break;
        case 4: // DIV
            mem[reg[0] + line[1]] = mem[reg[0] + line[2]] / mem[reg[0] + line[3]];
            break;
        case 5: // COP
            mem[reg[0] + line[1]] = mem[reg[0] + line[2]];
            break;
        case 6: // AFC
            mem[reg[0] + line[1]] = line[2];
            break;
        case 7: // JMP
            pc = line[1];
            break;
        case 8: // JMF
            if (mem[reg[0] + line[1]] == 0)
                pc = line[2];
            break;
        case 9: // INF
            if (mem[reg[0] + line[2]] < mem[reg[0] + line[3]])
                mem[reg[0] + line[1]] = 1;
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
        case 12: // PRI
            printf("%d\n", mem[line[1]]);
            break;
        case 13: // CPA
            mem[mem[line[1]]] = mem[line[2]];
            break;
        case 14: // CPB
            mem[line[1]] = line[2];
            break;
        case 15: // CPC
            mem[line[1]] = mem[mem[line[2]]];
            break;
        case 16: // RCP
            mem[line[1]] = reg[line[2]];
            break;
        case 17: // RAF
            reg[line[1]] = mem[line[2]];
            break;
    }
}

void printMem(){
    int i;
    for (i = 0; i < 256; i++){
        printf("[inter] mem[%d] = %d\n", i, mem[i]);
    }
}
