%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "tableInstructions.h"
%}

%union{
    int num;
    char letter;
}

%{
    // mémoire où on stocke la valeur des variables
    int mem[256];
    int pc;
    tableInstruction tableInstruct;
%}

%token tADD tMUL tSOU tDIV tCOP tAFC tJMP tJMF tINF tSUP tEQU tPRI tCPA tCPB tCPC
%token <num> tINT

%%

Prg:    Line Lines
Lines:  Line Lines
        |

Line:   tADD tINT tINT tINT { addInstructParams3(&tableInstruct, 1, $2, $3, $4);}
        | tMUL tINT tINT tINT { addInstructParams3(&tableInstruct, 2, $2, $3, $4);}
        | tSOU tINT tINT tINT { addInstructParams3(&tableInstruct, 3, $2, $3, $4);}
        | tDIV tINT tINT tINT { addInstructParams3(&tableInstruct, 4, $2, $3, $4);} 
        | tCOP tINT tINT { addInstructParams2(&tableInstruct, 5, $2, $3); }
        | tAFC tINT tINT { addInstructParams2(&tableInstruct, 6, $2, $3); }
        | tJMP tINT { addInstructParams1(&tableInstruct, 7, $2); }
        | tJMF tINT tINT { addInstructParams2(&tableInstruct, 8, $2, $3); }
        | tINF tINT tINT tINT { addInstructParams3(&tableInstruct, 9, $2, $3, $4);}
        | tSUP tINT tINT tINT { addInstructParams3(&tableInstruct, 10, $2, $3, $4);}
        | tEQU tINT tINT tINT { addInstructParams3(&tableInstruct, 11, $2, $3, $4);}
        | tPRI tINT { addInstructParams1(&tableInstruct, 12, $2); }
        | tCPA tINT tINT { addInstructParams2(&tableInstruct, 13, $2, $3); }
        | tCPB tINT tINT { addInstructParams2(&tableInstruct, 14, $2, $3); }
        | tCPC tINT tINT { addInstructParams2(&tableInstruct, 15, $2, $3); }

%%

yyerror(char *s){
	fprintf(stderr,"%s\n",s);
	exit(0);
}

int main (void) {
    initInstructionTable(&tableInstruct);
	yyparse();
    executeInstructions(&tableInstruct);
    printInstructionTable(&tableInstruct);
    return 0;
}
