YSOURCE = source.yacc
FSOURCE = source.lex
INCSRC	= symbols.h tableSymbols.h
CSRC	= y.tab.c lex.yy.c tableSymbols.c
OUTPUT = out

all: $(YSOURCE)
	yacc -v -d $(YSOURCE)
	flex $(FSOURCE)
	gcc $(CSRC) $(INCSRC) -ll -o $(OUTPUT)

test:
	cat test.pr | ./out
