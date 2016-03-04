%{
    #include <stdio.h>
    #include <stdlib.h>
%}

%union{
    int num;
    char letter;
}

%token <num> tINT
%token <letter> tLETTER

%%

Prg:    Line Lines
Lines:  Line Lines
        |

Line:   tINT tINT tINT tINT

%%

yyerror(char *s){
	fprintf(stderr,"%s\n",s);
	exit(0);
}

void main (void) {
	yyparse();
}
