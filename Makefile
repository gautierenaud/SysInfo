YSOURCE = source.yacc
YINTESRC= inter.yacc
FSOURCE = source.lex
FINTESRC= inter.lex
INCSRC	= symbols.h tableSymbols.h tableFonctions.h tableInstructions.h tableLabels.h utils.h
INCINTE = symbols.h tableSymbols.h tableFonctions.h exprTree.h
CSRC	= y.tab.c lex.yy.c tableSymbols.c tableFonctions.c tableInstructions.c tableLabels.c utils.c
CINTESRC= y.tab.c lex.yy.c tableSymbols.c tableFonctions.c exprTree.c
OUTPUT 	= out
INTEOUT = interpret

OPTIONS = 

all: $(YSOURCE)
	yacc -v -d $(YSOURCE)
	flex $(FSOURCE)
	gcc $(CSRC) $(INCSRC) $(OPTIONS) -ll -o $(OUTPUT)

inter: $(YINTESRC)
	yacc -v -d $(YINTESRC)
	flex $(FINTESRC)
	gcc $(CINTESRC) $(INCINTE) -ll -o $(INTEOUT)

test:
	cat test.pr | ./$(OUTPUT)
