#ifndef _INTERPRETEUR_
#define _INTERPRETEUR_

#include "tableInstructions.h"

void executeInstructions(tableInstruction *table);
void execLine(int *line);
void printMem();
void printReg();

#endif
