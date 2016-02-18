YSOURCE = source.yacc
FSOURCE = source.lex
INCLUDE = tableSymboles.h
OUTPUT = out

all: $(YSOURCE)
	yacc -d $(YSOURCE)
	flex $(FSOURCE)
	gcc y.tab.c lex.yy.c $(INCLUDE) -ll -o $(OUTPUT)
