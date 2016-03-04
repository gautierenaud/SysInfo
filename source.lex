%{
	#include "y.tab.h" 
%}

NAME [a-z|_|A-Z][a-z|_|A-Z|0-9]*
SEP [\t| |,]
EOL \n
EOI ;
OP \-|\+|\*|\/
STRING \".*\"
INT [0-9]+(^[0-9]+)?

%%

const  {return tCONST;}
int {return tINT;}
void {return tVOID;}
\if {return tIF;}
\else {return tELSE;}
\while {return tWHILE;}
\return {return tRETURN;} 
\" {return tGUIL;}
\+ {return tPLUS;}
\- {return tMOINS;}
\/ {return tDIV;}
\* {return tFOIS;}
= {return tEGAL;}
\( {return tPO;}
\) {return tPF;}
\{ {return tACO;}
\} {return tACF;}
, {return tVIR;}
; {return tPOINTVIR;}
printf {return tPRINTF;}
{INT} {yylval.num=atoi(yytext);return tINTVAL;}
{NAME} {strcpy(yylval.str, yytext);return tID;}
{STRING} {return tSTRING;}
" "
"\n"
