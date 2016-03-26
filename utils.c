#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

char* intToHex(int i){
    char *result = malloc(sizeof(char) * 3);
    sprintf(result, "%X", i);
    return result;
}

int hexToInt(char* c){
   return (int) strtol(c, NULL, 16);
}

const char * intToCode(int i){
    switch (i){
        case 1:
            return "ADD";
            break;
        case 2:
            return "MUL";
            break;
        case 3:
            return "SOU";
            break;
        case 4:
            return "DIV";
            break;
        case 5:
            return "COP";
            break;
        case 6:
            return "AFC";
            break;
        case 7:
            return "JMP";
            break;
        case 8:
            return "JMF";
            break;
        case 9:
            return "INF";
            break;
        case 10:
            return "SUP";
            break;
        case 11:
            return "EQU";
            break;
        case 12:
            return "PRI";
            break;
		case 13:
            return "CPA";
            break;
		case 14:
            return "CPB";
            break;
        case 15:
            return "CPC";
            break;
        case 16:
            return "RCP";
            break;
        case 17:
            return "RAF";
            break;
        default:
            return "NOP";
            break;
    }
}
