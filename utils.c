#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

char intToHex(int i){
    char result;
    sprintf(&result, "%X", i);
    return result;
}

int hexToInt(char c){
   return (int) strtol(&c, NULL, 16);
}
