%{
    #include "y.tab.h"
%}

INT -?[0-9]+

%%

^1 return tADD;
^2 return tMUL;
^3 return tSOU;
^4 return tDIV;
^5 return tCOP;
^6 return tAFC;
^7 return tJMP;
^8 return tJMF;
^9 return tINF;
^A return tSUP;
^B return tEQU;
^C return tPRI;
^D return tCPA;
^E return tCPB;
^F return tCPC;
^10 return tRCP;
^11 return tRAF;
^12 return tRET;
{INT} {yylval.num=atoi(yytext); return tINT;}

[ \n]
