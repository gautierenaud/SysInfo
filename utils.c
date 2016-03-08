#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

char intToHex(int i){
    char result[2];
    sprintf(result, "%X", i);
    return result[0];
}

int hexToInt(char c){
   return (int) strtol(&c, NULL, 16);
}
