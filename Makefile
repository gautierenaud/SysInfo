YSOURCE = source.yacc
FSOURCE = source.lex
OUTPUT = out

all: $(YSOURCE)
	yacc -d $(YSOURCE)
	flex $(FSOURCE)
	gcc y.tab.c lex.yy.c -ll -o $(OUTPUT)
