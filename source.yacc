%{
	#include <stdio.h>
	#include <stdlib.h>
  #include <string.h>
  #include "tableSymbols.h"
%}


%{
	int paramNum;
	char tmpChar;
    symbol tmpSymbol;
	char* paramName;
	char** fctTab;
    tableSymbols tableVar;
%}

// l'union permet d'utiliser les types sans avoir à les caster
// quand on veut utiliser un $i, yacc connait le type
%union 
{
        int num;
        char type;
        char str[16];
}

%{
 FILE *output;
%}

%token tINT tVOID tCONST tPO tPF tACO tACF tPOINTVIR tVIR tEGAL tPLUS tMOINS tFOIS tDIV tRETURN tPRINTF tSTRING tGUIL tIF tWHILE tERROR

%token <str> tID
%token <num> tINTVAL

%type <type> Type

//gerer les priorités
%right tEGAL
%left tPLUS tMOINS
%left tFOIS tDIV


%%

Prg: 			DFct Prg 
					| DFct
					
Type: 		tINT {$$ = 'i';}
					| tVOID {$$ = 'v';}

DFct: 		{
						paramNum = 0;
						paramName = (char*) malloc(sizeof(char));
					} 
					Type { tmpChar = $2; printf("function type: %c ", tmpChar); } 
					tID { printf("%s ", $4); fputs($4, output); fputs(":\n", output);} 
					tPO Param { printf("param num: %d, params: %s\n", paramNum, paramName); } 
					tPF Bloc
					{
						free(paramName);
					}

Param: 		ParamVar tVIR Param
		 			| ParamVar
		 			|

ParamVar:	Type { tmpChar = $1; strncat(paramName, &tmpChar, 1);} tID { paramNum++;}
		 			
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
     
Decla: 		Type { tmpSymbol.type = $1; } SDecl 

SDecl: 		Decl tVIR SDecl 
		 			| Decl
		 			
Decl: 		tID { strncpy(tmpSymbol.name, $1, strlen($1)); printf("id: %s \n", tmpSymbol.name);}
					| Affect

ExpAri: 	tINTVAL { printf("%d!!!\n", $1);}
					| tID
					| IFct 
					| ExpAri tPLUS ExpAri
					| ExpAri tMOINS ExpAri
					| ExpAri tFOIS ExpAri
					| ExpAri tDIV ExpAri
					| tPO ExpAri tPF

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
					
Affect: 	tID tEGAL ExpAri { printf(">>> %s\n", $1); }

Print: 		tPRINTF tPO tSTRING tPF

%%

yyerror(char *s){
	fprintf(stderr,"%s\n",s);
	exit(0);
}

void main (void) {
	output = fopen("source.asm", "w");
    fputs("# made by Paul and Renaud\n", output);
    initTable(&tableVar, 10);
    printTable(&tableVar);
	yyparse();
	fclose(output);
}
