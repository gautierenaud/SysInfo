%{
	#include <stdio.h>
	#include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include "tableSymbols.h"
    #include "tableLabels.h"
    #include "tableInstructions.h" 
    #include "tableFonctions.h"
    #include "tableParams.h"

%}


%{
	int paramNum; 
	int symbIndex;
    int tmpIndex;
	char tmpChar;
    char declType;
  	symbol varSymbol;
    symbol tmpSymbol;
    symbFct tmpFctSymbol;
	char* paramName;
	char** fctTab;
    tableSymbols tableVar;
    tableSymbFcts tableFct;
    tableLabels *tableLbl;
    tableInstruction tableInstruct;
    tableParams tablePar;
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

%token tINT tVOID tCONST tPO tPF tACO tACF tPOINTVIR tVIR tEGAL tINF tSUP tPLUS tMOINS tFOIS tDIV tRETURN tPRINTF tSTRING tGUIL tERROR tOR tAND tESP tCRO tCRF

%token <str> tID
%token <num> tINTVAL
%token <num> tIF
%token <num> tELSE
%token <num> tWHILE

%type <type> TType
%type <num> ExpAri
%type <num> SAffect
%type <num> Return
%type <num> If
%type <num> Cond
%type <num> SCond
%type <num> Condition
%type <num> ConnectLogi

//gerer les priorités
%right tEGAL
%left tPLUS tMOINS
%left tFOIS tDIV


%%

Prg: 		{ addInstructParams1(&tableInstruct, 7, -1); } DFct Prg 
			|
					
TType:  tVOID {$$ = 'v';}
			| tINT tFOIS {$$ = 'p'; }
			| tINT {$$ = 'i';}

DFct: {
				paramNum = 0;
				paramName = (char*) malloc(sizeof(char));
                tmpIndex = addTmp(&tableVar, 'i');
                tablePar = INIT_PARAMS_TABLE;
                //addInstructParams2(&tableInstruct, 16, tmpIndex, 0);
			} 
			TType { tmpFctSymbol.type = $2; } 
			tID { tmpFctSymbol.name = $4; } 
			tPO 
            Params { tmpFctSymbol.params = paramName; } 
			tPF { addSymbFct(&tableFct, tmpFctSymbol); /*fprintf(output, "%s:\n", tmpFctSymbol.name);*/}
            Bloc
			{
                // TO DO: vérifier si on a besoin d'une ligne return
				free(paramName);
				freeTable(&tableVar);
                printParamTable(&tablePar);
			}

Params:     Param
            |

Param: 		ParamVar tVIR Param
		 	| ParamVar

ParamVar:	TType tID 
            {
                tmpChar = $1; strncat(paramName, &tmpChar, 1);
                paramNum++;
                varSymbol.type = $1;
                strncpy(varSymbol.name, $2, strlen($2));
                addParam(&tablePar, varSymbol);
                memset(&(varSymbol.name), 0, sizeof(varSymbol.name));
            }
		 			
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
     
Decla:      tVOID tID { varSymbol.type = 'v'; strncpy(varSymbol.name, $2, strlen($2)); varSymbol.initialized = false; addSymbol(&tableVar, varSymbol); memset(&(varSymbol.name), 0, sizeof(varSymbol.name));  } SDecl
            | tVOID tID { varSymbol.type = 'v'; strncpy(varSymbol.name, $2, strlen($2)); varSymbol.initialized = false; } SAffect { varSymbol.initialized = true; symbIndex = addSymbol(&tableVar, varSymbol); addInstructParams2(&tableInstruct, 5, tableVar.symbolArray[symbIndex].symb.address, $4); popTmp(&tableVar); memset(&(varSymbol.name), 0, sizeof(varSymbol.name));  } SDecl
            | tINT tID { varSymbol.type = 'i'; strncpy(varSymbol.name, $2, strlen($2)); varSymbol.initialized = false; addSymbol(&tableVar, varSymbol); memset(&(varSymbol.name), 0, sizeof(varSymbol.name)); } SDecl
            | tINT tID { varSymbol.type = 'i'; strncpy(varSymbol.name, $2, strlen($2)); varSymbol.initialized = false; } SAffect { varSymbol.initialized = true; symbIndex = addSymbol(&tableVar, varSymbol); addInstructParams2(&tableInstruct, 5, tableVar.symbolArray[symbIndex].symb.address, $4); popTmp(&tableVar); memset(&(varSymbol.name), 0, sizeof(varSymbol.name));  } SDecl
            | tINT tFOIS tID { varSymbol.type = 'p'; strncpy(varSymbol.name, $3, strlen($3)); varSymbol.initialized = false; addSymbol(&tableVar, varSymbol); memset(&(varSymbol.name), 0, sizeof(varSymbol.name));  } SDecl
            | tINT tFOIS tID { varSymbol.type = 'p'; strncpy(varSymbol.name, $3, strlen($3)); varSymbol.initialized = false; } SAffect { varSymbol.initialized = true; symbIndex = addSymbol(&tableVar, varSymbol); addInstructParams2(&tableInstruct, 5, tableVar.symbolArray[symbIndex].symb.address, $5); popTmp(&tableVar); memset(&(varSymbol.name), 0, sizeof(varSymbol.name));  } SDecl
            | tINT tID tCRO tINTVAL 
                {
                    printTable(&tableVar);
                    varSymbol.type = 't';
                    strncpy(varSymbol.name, $2, strlen($2));
                    varSymbol.initialized = false;
                    addSymbolSize(&tableVar,varSymbol, $4);
                    memset(&(varSymbol.name), 0, sizeof(varSymbol.name));
                    printTable(&tableVar);
                }
                tCRF SDecl

SDecl: 		tVIR Decl SDecl 
		 	|

Decl: 		tID { strncpy(varSymbol.name, $1, strlen($1)); varSymbol.initialized = false; addSymbol(&tableVar, varSymbol); }
					| tID { strncpy(varSymbol.name, $1, strlen($1)); varSymbol.initialized = false;} SAffect { varSymbol.initialized = true; symbIndex = addSymbol(&tableVar, varSymbol); addInstructParams2(&tableInstruct, 5, tableVar.symbolArray[symbIndex].symb.address, $3); popTmp(&tableVar); }
					

Affect: 	 tID  SAffect 
                {
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
					| tFOIS tID SAffect 
                {
                    symbIndex = containsSymbol(&tableVar, $2); 
                    if (symbIndex > -1) { 
                        addInstructParams2(&tableInstruct, 13, tableVar.symbolArray[symbIndex].symb.address, $3); 
                        popTmp(&tableVar); 
                    } else {
                        printf("undef pointer\n");
                        compilationError = true;
                        popTmp(&tableVar);
                    } 
                }
					| tID tCRO ExpAri tCRF SAffect 
                        {
                            symbIndex = containsSymbol(&tableVar, $1);
                            if (symbIndex != -1){
                                tmpIndex = addTmp(&tableVar, 'i');
                                addInstructParams2(&tableInstruct, 6, tmpIndex, symbIndex);
                                addInstructParams3(&tableInstruct, 1, $3, $3, tmpIndex);
                                popTmp(&tableVar);
                                addInstructParams2(&tableInstruct, 13, $3, $5);
                            }else{
                                printf("undef array\n");
                                compilationError = true;
                            }
                            popTmp(&tableVar);  // ExprAri
                            popTmp(&tableVar);  // SAffect
                        }
                
SAffect:  tEGAL ExpAri { $$ = $2; }

ExpAri: 	tINTVAL { symbIndex = addTmp(&tableVar, 'i'); addInstructParams2(&tableInstruct, 6, symbIndex, $1); $$ = symbIndex; }
         | tID 
             { 
                  symbIndex = containsSymbol(&tableVar, $1); 
                  if (symbIndex == -1) 
                      printf("la variable %s n'existe pas dans ce contexte\n", $1);
                  else { 
                      tmpSymbol = getSymbol(&tableVar, symbIndex);
                      symbIndex = addTmp(&tableVar, tmpSymbol.type); 
                      addInstructParams2(&tableInstruct, 5, symbIndex, tmpSymbol.address);
                      $$ = symbIndex;
                 } 
             }
					| tID tCRO ExpAri tCRF 
                    { 
                        symbIndex = containsSymbol(&tableVar, $1); 
                        if (symbIndex == -1) {
                            printf("la variable %s n'existe pas dans ce contexte\n", $1);
                            compilationError = true;
                        }else { 
                            tmpIndex = addTmp(&tableVar, 'i');
                            addInstructParams2(&tableInstruct, 6,tmpIndex , symbIndex);
                            addInstructParams3(&tableInstruct, 1, $3, tmpIndex , $3);
                            popTmp(&tableVar);
                            addInstructParams2(&tableInstruct, 15, $3, $3);
                            $$ = $3;
                        } 

                    }
					| tFOIS tID { symbIndex = containsSymbol(&tableVar, $2); 
                        if (symbIndex == -1) 
                            printf("le pointeur n'existe pas dans ce contexte\n");
                        else {
                            tmpSymbol = getSymbol(&tableVar, symbIndex);
                            symbIndex = addTmp(&tableVar, 'p'); 
                            addInstructParams2(&tableInstruct, 15, symbIndex, tmpSymbol.address); 
                            $$ = symbIndex; 
                        } }
					| tESP tID { symbIndex = containsSymbol(&tableVar, $2); 
                        if (symbIndex == -1) 
                            printf("la variable n'existe pas dans ce contexte\n");
                        else {
                            tmpSymbol = getSymbol(&tableVar, symbIndex);
                            symbIndex = addTmp(&tableVar, 'i'); 
                            addInstructParams2(&tableInstruct, 14, symbIndex, tmpSymbol.address); 
                            $$ = symbIndex; 
                        } }

					| IFct { $$ = 1; /* on fait un saut dans la fonction, qui est sensé avoir mis le résultat dans une var temporaire */ } 
					| ExpAri tPLUS ExpAri { addInstructParams3(&tableInstruct, 1, $1, $1, $3); $$ = $1; popTmp(&tableVar);}
					| ExpAri tMOINS ExpAri { addInstructParams3(&tableInstruct, 3, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tFOIS ExpAri { addInstructParams3(&tableInstruct, 2, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tDIV ExpAri { addInstructParams3(&tableInstruct, 4, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| tPO ExpAri tPF { $$ = $2; }

Return: 	tRETURN ExpAri { $$ = $2; }

IFct: 		tID tPO IParam tPF { /*fprintf(output, "JMP %s\n", $1);*/}

IParam:   ExpAri IParams
					|

IParams:  tVIR ExpAri
					|					
					
If:			  tIF Condition { $1 = addInstructParams2(&tableInstruct, 8, $2, -1); popTmp(&tableVar); } Bloc {addLabel2(tableLbl , $1, tableInstruct.size); } SIf 				
					

SIf: 			tELSE { $1 = addInstructParams1(&tableInstruct, 7, -1); } Bloc { addLabel2(tableLbl, $1, tableInstruct.size - 1); }
					| 		

While: 		tWHILE { $1 = tableInstruct.size; } Condition { $3 = addInstructParams2(&tableInstruct, 8, $3, -1); popTmp(&tableVar); } Bloc { tmpIndex = addInstructParams1(&tableInstruct, 7, $1 -1); addLabel2(tableLbl , $3, tmpIndex); }


Condition: tPO SCond tPF { $$ = $2; } 

SCond:      Cond { $$ = $1; }
            | Cond ConnectLogi Cond 
							{symbIndex = addTmp(&tableVar, 'i'); if($2==0){addInstructParams3(&tableInstruct, 2, $1, $1, $3); addInstructParams2(&tableInstruct, 6, symbIndex, 1);
  addInstructParams3(&tableInstruct, 11, $1, $1, symbIndex); } 
							if($2==1){addInstructParams3(&tableInstruct, 1, $1, $1, $3); addInstructParams2(&tableInstruct, 6, symbIndex, 0); addInstructParams3(&tableInstruct, 10, $1, $1, symbIndex);} popTmp(&tableVar);}


Cond: 		ExpAri tEGAL tEGAL ExpAri { addInstructParams3(&tableInstruct, 11, $1, $1, $4); $$ = $1; popTmp(&tableVar); }
					| ExpAri { symbIndex = addTmp(&tableVar, 'i'); addInstructParams2(&tableInstruct, 6, symbIndex, 1); addInstructParams3(&tableInstruct, 11, $1,$1,symbIndex); popTmp(&tableVar); }
					| ExpAri tSUP ExpAri { addInstructParams3(&tableInstruct, 10, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tINF ExpAri { addInstructParams3(&tableInstruct, 9, $1, $1, $3); $$ = $1; popTmp(&tableVar); }

ConnectLogi:  tAND {$$ = 0;}
              | tOR	{$$ = 1;}

Print: 		tPRINTF tPO ExpAri tPF { addInstructParams1(&tableInstruct, 12, $3); popTmp(&tableVar); }

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
    tablePar = INIT_PARAMS_TABLE;
    printParamTable(&tablePar);  	

	yyparse();
	completeFromLabel(&tableInstruct, tableLbl);
    printInstructionTable(&tableInstruct);
    printLabelTable(tableLbl);
	output = fopen("source.asm", "w");
	printInstructsToFile(&tableInstruct, output);

	fclose(output);
    freeLabelTable(&tableLbl);
    //free(&tableLbl);
    //freeInstructionTable(&tableInstruct);
    return 0;
}
