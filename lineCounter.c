#include <stdlib.h>
#include <stdio.h>
#include "lineCounter.h"

int nextLine() {
	lineNumber++;
	return lineNumber;
}

int getLine() {
	return lineNumber;
}
