%{
    #include <stdio.h>
    #include <stdlib.h>
%}

%union{
    int num;
    char letter;
}

%token tADD tMUL tSOU tDIV tCOP tAFC tJMP tJMF tINF tSUP tEQU tPRI
%token <num> tINT

%%

Prg:    Line Lines
Lines:  Line Lines
        |

Line:   tADD tINT tINT tINT
        | tMUL tINT tINT tINT
        | tSOU tINT tINT tINT
        | tDIV tINT tINT tINT
        | tCOP tINT tINT
        | tAFC tINT tINT
        | tJMP tINT
        | tJMF tINT tINT
        | tINF tINT tINT tINT
        | tSUP tINT tINT tINT
        | tEQU tINT tINT tINT
        | tPRI tINT {printf("%d\n", $2);}

%%

yyerror(char *s){
	fprintf(stderr,"%s\n",s);
	exit(0);
}

void main (void) {
	yyparse();
}
