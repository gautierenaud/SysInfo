%{
	#include <stdio.h>
	#include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "tableSymbols.h"
    #include "tableLabels.h"
    #include "tableInstructions.h" 
    #include "tableFonctions.h"

%}


%{
	int paramNum; 
	int symbIndex;
	char tmpChar;
  	symbol varSymbol;
    symbol tmpSymbol;
    symbFct tmpFctSymbol;
	char* paramName;
	char** fctTab;
    tableSymbols tableVar;
    tableSymbFcts tableFct;
    tableLabels *tableLbl;
    tableInstruction tableInstruct;
    FILE *output;
    bool compilationError;
	
%}

// l'union permet d'utiliser les types sans avoir à les caster
// quand on veut utiliser un $i, yacc connait le type
%union 
{
   	int num;
   	char type;
    char str[16];
}

%token tINT tVOID tCONST tPO tPF tACO tACF tPOINTVIR tVIR tEGAL tPLUS tMOINS tFOIS tDIV tRETURN tPRINTF tSTRING tGUIL tELSE tWHILE tERROR tOR tAND

%token <str> tID
%token <num> tINTVAL
%token <num> tIF

%type <num> Condition
%type <num> Cond
%type <num> SCond
%type <type> TType
%type <num> ExpAri
%type <num> SAffect
%type <num> Return


//gerer les priorités
%right tEGAL
%left tPLUS tMOINS
%left tFOIS tDIV


%%

Prg: 		DFct Prg 
			| DFct
					
TType: 		tINT {$$ = 'i';}
			| tVOID {$$ = 'v';}

DFct: 		{
				paramNum = 0;
				paramName = (char*) malloc(sizeof(char));
			} 
			TType { tmpFctSymbol.type = $2; } 
			tID { tmpFctSymbol.name = $4; } 
			tPO 
            Params { tmpFctSymbol.params = paramName; } 
			tPF { addSymbFct(&tableFct, tmpFctSymbol); fprintf(output, "%s:\n", tmpFctSymbol.name);}
            Bloc
			{
                // TO DO: vérifier si on a besoin d'une ligne return
				free(paramName);
				freeTable(&tableVar);
			}

Params:     Param
            |

Param: 		ParamVar tVIR Param
		 	| ParamVar

ParamVar:	TType { tmpChar = $1; strncat(paramName, &tmpChar, 1);} tID { paramNum++;}
		 			
Bloc: 		tACO Expr tACF

Expr: 		Ligne Expr 
			| 
					
Ligne: 		Return tPOINTVIR 
     			| Decla tPOINTVIR
     			| IFct tPOINTVIR
     			| If
     			| While
     			| Affect tPOINTVIR
     			| Print tPOINTVIR
     
Decla: 		TType { varSymbol.type = $1; } SDecl 

SDecl: 		Decl tVIR SDecl 
		 			| Decl

Decl: 		        tID { strncpy(varSymbol.name, $1, strlen($1)); varSymbol.initialized = false; addSymbol(&tableVar, varSymbol); }
					| tID { strncpy(varSymbol.name, $1, strlen($1)); varSymbol.initialized = false;} SAffect { varSymbol.initialized = true; symbIndex = addSymbol(&tableVar, varSymbol); addInstructParams2(&tableInstruct, 5, tableVar.symbolArray[symbIndex].symb.address, $3); popTmp(&tableVar); }
					

Affect: 	 tID  SAffect 
                {
                    printTable(&tableVar); 
                    symbIndex = containsSymbol(&tableVar, $1); 
                    if (symbIndex > -1) { 
                        addInstructParams2(&tableInstruct, 5, tableVar.symbolArray[symbIndex].symb.address, $2); 
                        popTmp(&tableVar); 
                    } else {
                        printf("undef variable\n");
                        compilationError = true;
                        popTmp(&tableVar);
                    } 
                }


SAffect:  tEGAL ExpAri { $$ = $2; }

ExpAri: 	tINTVAL { symbIndex = addTmp(&tableVar, 'i'); addInstructParams2(&tableInstruct, 6, symbIndex, $1); $$ = symbIndex; }
                    | tID { symbIndex = containsSymbol(&tableVar, $1); if (symbIndex == -1) printf("la variable n'existe pas dans ce contexte\n"); else { tmpSymbol = getSymbol(&tableVar, symbIndex); symbIndex = addTmp(&tableVar, tmpSymbol.type); addInstructParams2(&tableInstruct, 5, symbIndex, tmpSymbol.address); } }
					| IFct { $$ = 1; /* on fait un saut dans la fonction, qui est sensé avoir mis le résultat dans une var temporaire */ } 
					| ExpAri tPLUS ExpAri { addInstructParams3(&tableInstruct, 1, $1, $1, $3); $$ = $1; popTmp(&tableVar);}
					| ExpAri tMOINS ExpAri { addInstructParams3(&tableInstruct, 3, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tFOIS ExpAri { addInstructParams3(&tableInstruct, 2, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tDIV ExpAri { addInstructParams3(&tableInstruct, 4, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| tPO ExpAri tPF { $$ = $2; }

Return: 	tRETURN ExpAri { $$ = $2; }

IFct: 		tID tPO IParam tPF { fprintf(output, "JMP %s\n", $1);}

IParam:   ExpAri IParams
					|

IParams:  tVIR ExpAri
					|					
					
If:			  tIF Condition { $1 = addInstructParams2(&tableInstruct, 8, $2, -1); } Bloc SIf {addLabel2(tableLbl , $1, tableInstruct.size); }				
					
SIf: 			tELSE  Bloc 
					| 		

While: 		tWHILE Condition {fprintf(output, "JMF\n");} Bloc

Condition: tPO SCond tPF {$$ = $2;}

SCond:      Cond {$$ = $1;} 
            | Cond ConnectLogi Cond {$$ = $1;}

Cond: 		ExpAri tEGAL tEGAL ExpAri { symbIndex = addTmp(&tableVar, 'i'); addInstructParams3(&tableInstruct, 11, symbIndex,$1,$4);  }
					| ExpAri { symbIndex = addTmp(&tableVar, 'i'); fprintf(output, "AFC %d 1",symbIndex); fprintf(output, "EQU %d %d %d\n",symbIndex,$1,symbIndex); }

ConnectLogi:    tAND
                | tOR

Print: 		tPRINTF tPO ExpAri tPF { fprintf(output, "PRI %d\n", $3);}

%%

yyerror(char *s){
	fprintf(stderr,"%s\n",s);
	exit(0);
}

int main (void) {
    compilationError = false;
    initLabelTable(&tableLbl);
    initInstructionTable(&tableInstruct);
    initSymbTable(&tableVar);
    initFctTable(&tableFct);
   	output = fopen("source.asm", "w");

	yyparse();

    printInstructionTable(&tableInstruct);
    printLabelTable(tableLbl);

	fclose(output);
    freeLabelTable(&tableLbl);
    //free(&tableLbl);
    //freeInstructionTable(&tableInstruct);
    return 0;
}
