all: bison flex parser.tab.o lex.yy.o main.o main

bison: parser.y
	bison -d parser.y

flex: parser.tab.h
	flex lexer.l

parser.tab.o: parser.tab.c
	g++ -c parser.tab.c

lex.yy.o: lex.yy.c
	g++ -Wno-register -c lex.yy.c

main.o: main.cpp parser.tab.h
	g++ -c main.cpp

main: main.o parser.tab.o lex.yy.o
	g++ -o main main.o parser.tab.o lex.yy.o

clean:
	rm -f parser.tab.* lex.yy.* *.o main
