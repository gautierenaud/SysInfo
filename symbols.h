#ifndef _SYMBOLS_
#define _SYMBOLS_

#include <stdbool.h>

typedef struct {
    char name[256];
    char type;
    int address;
    bool initialized;
    bool constant;
}symbol;

#endif
