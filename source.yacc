%{
	#include <stdio.h>
	#include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "tableSymbols.h"

%}


%{
	int paramNum; 
	int symbIndex;
	char tmpChar;
  	symbol tmpSymbol;
	char* paramName;
	char** fctTab;
    tableSymbols tableVar;
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

%token tINT tVOID tCONST tPO tPF tACO tACF tPOINTVIR tVIR tEGAL tPLUS tMOINS tFOIS tDIV tRETURN tPRINTF tSTRING tGUIL tIF tWHILE tERROR

%token <str> tID
%token <num> tINTVAL

%type <type> TType
%type <num> ExpAri
%type <num> SAffect


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
			TType { tmpChar = $2; printf("function type: %c ", tmpChar); } 
			tID { printf("%s ", $4); fputs($4, output); fputs(":\n", output);} 
			tPO Param { printf("param num: %d, params: %s\n", paramNum, paramName); } 
			tPF Bloc
			{
				free(paramName);
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
     
Decla: 		TType { tmpSymbol.type = $1; } SDecl 

SDecl: 		Decl tVIR SDecl 
		 			| Decl
		 			
Decl: 		        tID { strncpy(tmpSymbol.name, $1, strlen($1)); tmpSymbol.initialized = false; addSymbol(&tableVar, tmpSymbol); }
					| tID { strncpy(tmpSymbol.name, $1, strlen($1)); tmpSymbol.initialized = false;} SAffect { /*tmpSymbol.initialized = true;*/ symbIndex = addSymbol(&tableVar, tmpSymbol); fprintf(output, "AFC %d %d\n", tableVar.symbolArray[symbIndex].symb.address, 3); }
					
Affect: 	        tID SAffect

SAffect:            tEGAL ExpAri { $$ = 1; } 

ExpAri: 	tINTVAL
                    | tID { $$ = 1;}
					| IFct { $$ = 1; } 
					| ExpAri tPLUS ExpAri
					| ExpAri tMOINS ExpAri
					| ExpAri tFOIS ExpAri
					| ExpAri tDIV ExpAri
					| tPO ExpAri tPF { $$ = $2; }

Return: 	tRETURN ExpAri

IFct: 		tID tPO IParam tPF

IParam:   ExpAri IParams
					|

IParams:  tVIR ExpAri
					|					
					
If:				tIF Condition

While: 		tWHILE Condition

Condition: tPO Cond tPF Bloc

Cond: 		ExpAri tEGAL tEGAL ExpAri
					| ExpAri
Print: 		tPRINTF tPO tSTRING tPF

%%

yyerror(char *s){
	fprintf(stderr,"%s\n",s);
	exit(0);
}

void main (void) {
	output = fopen("source.asm", "w");
    fputs("# made by Paul and Renaud\n", output);
    initTable(&tableVar);
    printTable(&tableVar);
	yyparse();
	fclose(output);
}
