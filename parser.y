%code requires {
    #include <vector>
    #include <string>
    #include "ast.hpp"
}

%{
#include <iostream>
#include <memory>
#include <cstring>
#include "ast.hpp"

int yylex(void);

void yyerror(const char *s) {
  std::cerr << "Error de parseo: " << s << std::endl;
}

std::unique_ptr<ProgramNode> root;
%}

%union {
    char* str;
    ASTNode* node;
    std::vector<ASTNode*>* nodelist;
    std::vector<std::string>* strlist;
}

%type <node> instruccion definicion_funcion funcion_principal
%type <nodelist> instrucciones
%type <strlist> parametros
%type <str> tipo

%token INICIAR FINALIZAR
%token TIPO_INT TIPO_FLOAT
%token FUNCION PRINCIPAL
%token PARAMETRO ARGUMENTO
%token CREAR_VARIABLE ASIGNAR_VARIABLE VALOR
%token DESDE HASTA I
%token IMPRIMIR IMPRIMIR_TEXTO FIN_TEXTO
%token <str> IDENT
%token <str> TEXTO

%%

programa:
    INICIAR instrucciones FINALIZAR {
        root = std::make_unique<ProgramNode>();
        for (auto n : *$2)
            root->instructions.emplace_back(n);
        delete $2;
    }
;

instrucciones:
    instruccion {
        $$ = new std::vector<ASTNode*>();
        $$->push_back($1);
    }
  | instrucciones instruccion {
        $$ = $1;
        $$->push_back($2);
    }
;

instruccion:
    definicion_funcion
  | funcion_principal
;

tipo:
    TIPO_INT    { $$ = strdup("int"); }
  | TIPO_FLOAT  { $$ = strdup("float"); }
;

definicion_funcion:
    FUNCION tipo IDENT PARAMETRO parametros {
        auto fn = new FunctionNode();
        fn->returnType = $2;
        fn->name = $3;
        fn->params = *$5;
        delete $5;
        $$ = fn;
    }
;

funcion_principal:
    PRINCIPAL {
        $$ = new MainFunctionNode();
    }
;

parametros:
    IDENT {
        $$ = new std::vector<std::string>();
        $$->push_back($1);
    }
  | parametros IDENT {
        $$ = $1;
        $$->push_back($2);
    }
;

%%

