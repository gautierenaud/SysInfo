%{
    #include "y.tab.h"
%}

INT [0-9]+(^[0-9]+)?
CHAR [A-C]

%%

{INT} {yylval.num=atoi(yytext); return tINT;}
{CHAR} {yylval.letter = (char) atoi(yytext); return tLETTER;}
