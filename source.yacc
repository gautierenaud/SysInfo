%{
	#include <stdio.h>
	#include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "tableSymbols.h"
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
    FILE *output;
	
%}

// l'union permet d'utiliser les types sans avoir à les caster
// quand on veut utiliser un $i, yacc connait le type
%union 
{
   	int num;
   	char type;
    char str[16];
}

%token tINT tVOID tCONST tPO tPF tACO tACF tPOINTVIR tVIR tEGAL tPLUS tMOINS tFOIS tDIV tRETURN tPRINTF tSTRING tGUIL tIF tELSE tWHILE tERROR tOR tAND

%token <str> tID
%token <num> tINTVAL

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
            Param { tmpFctSymbol.params = paramName; } 
			tPF { addSymbFct(&tableFct, tmpFctSymbol); printFctTable(&tableFct); fprintf(output, "%s:\n", tmpFctSymbol.name);}
            Bloc
			{
                // TO DO: vérifier si on a besoin d'une ligne return
				free(paramName);
				freeTable(&tableVar);
			}

Param: 		ParamVar tVIR Param
		 	| ParamVar
		 	|

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
					| tID { strncpy(varSymbol.name, $1, strlen($1)); varSymbol.initialized = false;} SAffect { varSymbol.initialized = true; symbIndex = addSymbol(&tableVar, varSymbol); fprintf(output, "COP %d %d\n", tableVar.symbolArray[symbIndex].symb.address, $3); popTmp(&tableVar); }
					
Affect: 	tID  SAffect {printf("ID : %s\n",$1); if (symbIndex = containsSymbol(&tableVar, $1)>-1) { printf("name : %s; index: %d\n",tableVar.symbolArray[symbIndex].symb.name, symbIndex); fprintf(output, "COP %d %d\n", tableVar.symbolArray[symbIndex].symb.address, $2); } else {printf("undef variable\n"); } }

SAffect:  tEGAL ExpAri { $$ = $2; }

ExpAri: 	tINTVAL { symbIndex = addTmp(&tableVar, 'i'); fprintf(output, "AFC %d %d\n", symbIndex, $1); $$ = symbIndex; }
                    | tID { symbIndex = containsSymbol(&tableVar, $1); if (symbIndex == -1) printf("la variable n'existe pas dans ce contexte\n"); else { tmpSymbol = getSymbol(&tableVar, symbIndex); symbIndex = addTmp(&tableVar, tmpSymbol.type); fprintf(output, "COP %d %d\n", symbIndex, tmpSymbol.address); $$ = symbIndex; } }
					| IFct { $$ = 1; /* on fait un saut dans la fonction, qui est sensé avoir mis le résultat dans une var temporaire */ } 
					| ExpAri tPLUS ExpAri { fprintf(output, "ADD %d %d %d\n", $1, $1, $3); $$ = $1; popTmp(&tableVar);}
					| ExpAri tMOINS ExpAri { fprintf(output, "SOU %d %d %d\n", $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tFOIS ExpAri { fprintf(output, "MUL %d %d %d\n", $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tDIV ExpAri { fprintf(output, "DIV %d %d %d\n", $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| tPO ExpAri tPF { $$ = $2; }

Return: 	tRETURN ExpAri { $$ = $2; }

IFct: 		tID tPO IParam tPF { fprintf(output, "JMP %s\n", $1);}

IParam:   ExpAri IParams
					|

IParams:  tVIR ExpAri
					|					
					
If:			  tIF { fprintf(output, "if:\n");} Condition Bloc SIf { fprintf(output, "fi:\n");}				

					
SIf: 			tELSE { fprintf(output, "else:\n");} Bloc 
					| 		

While: 		tWHILE Condition Bloc

Condition: tPO SCond tPF  

SCond:      Cond
            | Cond ConnectLogi Cond

Cond: 		ExpAri tEGAL tEGAL ExpAri {  }
					| ExpAri

ConnectLogi:    tAND
                | tOR

Print: 		tPRINTF tPO ExpAri tPF { fprintf(output, "PRI %d\n", $3);}

%%

yyerror(char *s){
	fprintf(stderr,"%s\n",s);
	exit(0);
}

void main (void) {
	output = fopen("source.asm", "w");
    fputs("# made by Paul and Renaud\n", output);
    initTable(&tableVar);
    initFctTable(&tableFct);
	yyparse();
	fclose(output);
}
