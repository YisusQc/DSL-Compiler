all: bison flex parser.tab.o lex.yy.o codegen.o main.o main

bison: parser.y
	bison -d parser.y

flex: parser.tab.h
	flex lexer.l

parser.tab.o: parser.tab.c
	g++ -c parser.tab.c

lex.yy.o: lex.yy.c
	g++ -Wno-register -c lex.yy.c

codegen.o: ast.hpp
	g++ -c codegen.cpp

main.o: ast.hpp parser.tab.h
	g++ -c main.cpp

main: main.o codegen.o parser.tab.o lex.yy.o
	g++ -o main codegen.o main.o parser.tab.o lex.yy.o

clean:
	rm -f parser.tab.* lex.yy.* *.o main

