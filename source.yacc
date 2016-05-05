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
		#include "lineCounter.h"
%}


%{
	int paramNum;
	int instructNum; 
	int symbIndex;
    int tmpIndex;
    int mainIndex;
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
    bool returnValue; // if a function returns a value or not
    bool returningObligation; // if a functions has to returrn a value
    bool mainPresent = false;
%}

// l'union permet d'utiliser les types sans avoir à les caster
// quand on veut utiliser un $i, yacc connait le type
%union 
{
   	int num;
   	char type;
    char str[16];
}

%token tINT tVOID tCONST tPO tACO tACF tPOINTVIR tVIR tEGAL tINF tSUP tPLUS tMOINS tFOIS tDIV tRETURN tPRINTF tSTRING tGUIL tERROR tOR tAND tESP tCRO tCRF

%token <str> tID
%token <num> tINTVAL
%token <num> tIF
%token <num> tELSE
%token <num> tWHILE
%token <num> tPF

%type <type> TType
%type <num> TTab
%type <num> InitVar
%type <num> ExpAri
%type <num> SAffect
%type <num> Return
%type <num> If
%type <num> Cond
%type <num> SCond
%type <num> Condition
%type <num> ConnectLogi
%type <num> IFct

//gerer les priorités
%right tEGAL
%left tPLUS tMOINS
%left tFOIS tDIV


%%

Prg: 		{
                // jump to the end
                addInstructParams1(&tableInstruct, 7, -1);
            }
            DFct SPrg 

SPrg:       DFct SPrg
            |
            {
                // jump goal is here
                addLabel2(tableLbl, 0, tableInstruct.size - 1);
                // prepare to call the main function
                // Ctxt value
                tmpIndex = addTmp(&tableVar, 'i');
                addInstructParams2(&tableInstruct, 16, tmpIndex, 0); 

                // @ return
                tmpIndex = addTmp(&tableVar, 'i');
                addInstructParams2(&tableInstruct, 6, tmpIndex, tableInstruct.size + 4);

                // nombre de var locales à prendre en compte
                tmpIndex = addTmp(&tableVar, 'i');
                addInstructParams2(&tableInstruct, 6, tmpIndex, tableVar.sizeData - 1);
                addInstructParams3(&tableInstruct, 1, tmpIndex, tmpIndex, tmpIndex - 2);

                addInstructParams2(&tableInstruct, 17, 0, tmpIndex);

                // jump to the main
                addInstructParams1(&tableInstruct, 7, mainIndex);
                popTmp(&tableVar);
                popTmp(&tableVar);
                popTmp(&tableVar);
            }
					
TType:  tVOID {$$ = 'v';}
			| tINT tFOIS {$$ = 'p'; }
			| tINT {$$ = 'i';}

DFct:       TType 
            {
                initSymbTable(&tableVar);

                tmpFctSymbol.type = $1;
                // we will test if we need to return something
                if ($1 == 'i' || $1 == 'p')
                    returningObligation = true;
                else
                    returningObligation = false;
                returnValue = false;
            } 
			tID 
            { 
                tmpFctSymbol.name = (char*) malloc(sizeof(char) * getLength($3));
                strncat(tmpFctSymbol.name, $3, getLength($3));
                // on teste si c'est la fonction main
                if (strcmp("main", $3) == 0){
                    if (!mainPresent){
                        mainPresent = true;
                        // TO DO: vérifier la destination
                        //addLabel2(tableLbl, 0, tableInstruct.size - 1);
                        mainIndex = tableInstruct.size - 1;
                    }else{
                        printf("main already declared\n");
                        compilationError = true;
                    }
                }
            } 
			tPO
            {
				paramNum = 0;
				paramName = (char*) malloc(sizeof(char));
                tablePar = INIT_PARAMS_TABLE;
			}  
            Params 
            {
                tmpFctSymbol.params = (char*) malloc(sizeof(char) * paramNum);
                strncat(tmpFctSymbol.params, paramName, paramNum);
                tmpFctSymbol.startIndex = tableInstruct.size;
                addSymbFct(&tableFct, tmpFctSymbol);
				free(paramName);
            } 
			tPF 
            Bloc
			{
                // TO DO: vérifier si on a besoin d'une ligne return
				freeTable(&tableVar);
                printParamTable(&tablePar);
                // charge l'addresse de retour dans le registre 2
                addInstructParams2(&tableInstruct, 17, 2, -1);
                // charge la valeur sauvegardée de ebp dans le registre 0
                addInstructParams2(&tableInstruct, 17, 0, -2);
                // charge l'addresse de retour dans pc
                addInstructParams0(&tableInstruct, 18);
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
                | error tPOINTVIR {compilationError = true;}
     
Decla:      TType tID TTab
            {
                // copy the name of the variable to a local representation
                strncpy(varSymbol.name, $2, strlen($2));
                
                varSymbol.initialized = false;

                // if it is an array
                if ($3 != -1){
                    varSymbol.type = 't';
                    $3 = addSymbolSize(&tableVar, varSymbol, $3);
                }else{
                    varSymbol.type = $1;
                    $3 = addSymbol(&tableVar, varSymbol);
                }

                // erase the name of the varSymbol
                memset(&(varSymbol.name), 0, sizeof(varSymbol.name));
            }
            InitVar
            {
                // si on a une affectation
                if ($5 != -1){
                    tableVar.symbolArray[$3].symb.initialized = true;
                    addInstructParams2(&tableInstruct, 5, $3, $5);
                    popTmp(&tableVar);
                }
            }
            SDecl

TTab:       tCRO tINTVAL tCRF  { $$ = $2; }
            |               { $$ = -1; }

InitVar:    SAffect         { $$ = $1; }
            |               { $$ = -1; }

SDecl: 		tVIR Decl SDecl 
		 	|

Decl:       tID
            {
                strncpy(varSymbol.name, $1, strlen($1));
                varSymbol.initialized = false;
                symbIndex = addSymbol(&tableVar, varSymbol);
                memset(&(varSymbol.name), 0, sizeof(varSymbol.name));
            }
            InitVar
            {
                symbIndex = containsSymbol(&tableVar, $1);
                if ($3 != -1){
                    tableVar.symbolArray[symbIndex].symb.initialized = true;
                    addInstructParams2(&tableInstruct, 5, symbIndex, $3);
                    popTmp(&tableVar);
                }
            }

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
                  bool found = false;
                  if (symbIndex != -1){
                      tmpSymbol = getSymbol(&tableVar, symbIndex);
                      found = true;
                  }else{
                    symbIndex = containsParam(&tablePar, $1);
                    if (symbIndex != -1){
                        tmpSymbol = getParam(&tablePar, symbIndex);
                        found = true;
                    }
                  }

                  if (!found){
                      compilationError = true;
                      printf("la variable %s n'existe pas dans ce contexte\n", $1);
                  }else { 
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
                        if (symbIndex == -1) {
                            printf("le pointeur n'existe pas dans ce contexte\n");
                            compilationError = true;
                        }
                        else {
                            tmpSymbol = getSymbol(&tableVar, symbIndex);
                            symbIndex = addTmp(&tableVar, 'p'); 
                            addInstructParams2(&tableInstruct, 15, symbIndex, tmpSymbol.address); 
                            $$ = symbIndex; 
                        } }
					| tESP tID { symbIndex = containsSymbol(&tableVar, $2); 
                        if (symbIndex == -1) {
                            printf("la variable n'existe pas dans ce contexte\n");
                            compilationError = true;
                        }
                        else {
                            tmpSymbol = getSymbol(&tableVar, symbIndex);
                            symbIndex = addTmp(&tableVar, 'i'); 
                            addInstructParams2(&tableInstruct, 14, symbIndex, tmpSymbol.address); 
                            $$ = symbIndex; 
                        } }

					| IFct {  /* on fait un saut dans la fonction, qui est sensé avoir mis le résultat dans une var temporaire */
              tmpIndex = addTmp(&tableVar, 'i');
              addInstructParams2(&tableInstruct, 16, tmpIndex, 1); 
              $$ = tmpIndex; 
             } 
					| ExpAri tPLUS ExpAri { addInstructParams3(&tableInstruct, 1, $1, $1, $3); $$ = $1; popTmp(&tableVar);}
					| ExpAri tMOINS ExpAri { addInstructParams3(&tableInstruct, 3, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tFOIS ExpAri { addInstructParams3(&tableInstruct, 2, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| ExpAri tDIV ExpAri { addInstructParams3(&tableInstruct, 4, $1, $1, $3); $$ = $1; popTmp(&tableVar); }
					| tPO ExpAri tPF { $$ = $2; }

Return: 	tRETURN ExpAri 
            {
                // $$ = $2;
                returnValue = true;
                /* maybe check the type of the returning expression */
                addInstructParams2(&tableInstruct, 17, 1, $2);

                /* Prepare the jump to the calling function */
                // charge l'addresse de retour dans le registre 2
                addInstructParams2(&tableInstruct, 17, 2, -1);
                // charge la valeur sauvegardée de ebp dans le registre 0
                addInstructParams2(&tableInstruct, 17, 0, -2);
                // charge l'addresse de retour dans pc
                addInstructParams0(&tableInstruct, 18);
            }

/**********************************************************************/

IFct: 		tID tPO IParam tPF 
            {
                // version Paul
                /*instructNum = tableInstrcut.size + 3;*/
                /*
                symbIndex = addSymbol(&tableVar, varSymbol);
                addInstructParams2(&tableInstruct, 6, symbIndex, instructNum + 3);
                symbIndex = addSymbol(&tableVar, varSymbol);
                addInstructParams2(&tableInstruct, 16, symbIndex, 0);
                $4 = addInstructParams1(&tableInstruct, 7, -1);
                addLabel2(tableLbl , $4, tableInstruct.size);
                */
                /*ajouter un label dans la table des label char**/

                // version Renaud

                /* ajouter les paramètres */

                // prepare to call the function
                // Ctxt value
                tmpIndex = addTmp(&tableVar, 'i');
                addInstructParams2(&tableInstruct, 16, tmpIndex, 0); 

                // @ return
                tmpIndex = addTmp(&tableVar, 'i');
                addInstructParams2(&tableInstruct, 6, tmpIndex, tableInstruct.size + 4);

                // nombre de var locales à prendre en compte
                tmpIndex = addTmp(&tableVar, 'i');
                addInstructParams2(&tableInstruct, 6, tmpIndex, tableVar.sizeData - 1);
                addInstructParams3(&tableInstruct, 1, tmpIndex, tmpIndex, tmpIndex - 2);

                addInstructParams2(&tableInstruct, 17, 0, tmpIndex);

                // jump to the function
                // get by proto
                // int funcIndex = containsSymbFct(&tableFct, $1, $3);
                int funcIndex = containsFctName(&tableFct, $1);
                if (funcIndex != -1)
                    addInstructParams1(&tableInstruct, 7, tableFct.symbFctArray[funcIndex].startIndex - 1);
                else {
                    // printf("function %s missing. params: %s\n", $1, $3);
                    printf("function %s missing\n", $1);
                    compilationError = true;
                }
                popTmp(&tableVar);
                popTmp(&tableVar);
                popTmp(&tableVar);
            } 

IParam:     ExpAri 
            {
                symbIndex = addSymbol(&tableVar, varSymbol);
                instructNum = addInstructParams2(&tableInstruct, 5, symbIndex, $1);
                popTmp(&tableVar);
                char c = tableVar.symbolArray[$1].symb.type;
            }
            IParams
            { /*$$ = instructNum;*/ }
			|

IParams:  tVIR ExpAri { symbIndex = addSymbol(&tableVar, varSymbol); instructNum = addInstructParams2(&tableInstruct, 5, symbIndex, $2); popTmp(&tableVar);}
					|	

/**********************************************************************/				
					
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


Cond: 		ExpAri tEGAL tEGAL ExpAri 
            {
                addInstructParams3(&tableInstruct, 11, $1, $1, $4);
                $$ = $1;
                popTmp(&tableVar);
            }
			| ExpAri
            {
                symbIndex = addTmp(&tableVar, 'i');
                addInstructParams2(&tableInstruct, 6, symbIndex, 1);
                addInstructParams3(&tableInstruct, 11, $1, $1, symbIndex);
                popTmp(&tableVar);
            }
			| ExpAri tSUP ExpAri 
            {
                addInstructParams3(&tableInstruct, 10, $1, $1, $3);
                $$ = $1;
                popTmp(&tableVar);
            }
            | ExpAri tINF ExpAri
            {
                addInstructParams3(&tableInstruct, 9, $1, $1, $3);
                $$ = $1;
                popTmp(&tableVar);
            }

ConnectLogi:  tAND {$$ = 0;}
              | tOR	{$$ = 1;}

Print: 		tPRINTF tPO ExpAri tPF { addInstructParams1(&tableInstruct, 12, $3); popTmp(&tableVar); }

%%

yyerror(char *s){
  printf("line %d : ",getLine());
	fprintf(stderr,"%s\n", s);
	//exit(0);
}

int main (void) {
    compilationError = false;
    initLabelTable(&tableLbl);
    initInstructionTable(&tableInstruct);
    initSymbTable(&tableVar);
    initFctTable(&tableFct);
    tablePar = INIT_PARAMS_TABLE;

	yyparse();
	completeFromLabel(&tableInstruct, tableLbl);
    printInstructionTable(&tableInstruct);
	if (!mainPresent){
        printf("main function not present\n");
        exit(-1);
    }else if (compilationError){
        printf("compilation error, no assembly file\n");
        exit(-1);
    }else{
        output = fopen("source.asm", "w");
	    printInstructsToFile(&tableInstruct, output);
	    fclose(output);
    }
    freeLabelTable(&tableLbl);
    //free(&tableLbl);
    //freeInstructionTable(&tableInstruct);
    return 0;
}
