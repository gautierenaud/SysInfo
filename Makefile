YSOURCE = source.yacc
YINTESRC= inter.yacc
FSOURCE = source.lex
FINTESRC= inter.lex
INCSRC	= symbols.h tableSymbols.h tableFonctions.h tableInstructions.h tableLabels.h utils.h tableParams.h labelFonctions.h lineCounter.h
INCINTE = tableInstructions.h utils.h interpreteur.h 
CSRC	= y.tab.c lex.yy.c tableSymbols.c tableFonctions.c tableInstructions.c tableLabels.c utils.c tableParams.c labelFonctions.c lineCounter.c
CINTESRC= y.tab.c lex.yy.c tableInstructions.c utils.c interpreteur.c
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

itest:
	./$(INTEOUT) < source.asm

alltest:
	cat test.pr | ./$(OUTPUT)
	./$(INTEOUT) < source.asm

allall:
	yacc -v -d $(YSOURCE)
	flex $(FSOURCE)
	gcc $(CSRC) $(INCSRC) $(OPTIONS) -ll -o $(OUTPUT)
	yacc -v -d $(YINTESRC)
	flex $(FINTESRC)
	gcc $(CINTESRC) $(INCINTE) -ll -o $(INTEOUT)
	cat test.pr | ./$(OUTPUT)
	./$(INTEOUT) < source.asm
