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
    int num;
    char* str;
    ASTNode* node;
    StatementNode* stmt;
    std::vector<ASTNode*>* nodelist;
    std::vector<std::string>* strlist;
}

%type <node> instruccion definicion_funcion funcion_principal
%type <nodelist> instrucciones
%type <strlist> parametros
%type <str> tipo
%type <strlist> texto_imprimible
%type <node> sentencia
%type <node> lista_sentencias

%token INICIAR FINALIZAR
%token TIPO_INT TIPO_FLOAT
%token FUNCION PRINCIPAL
%token PARAMETRO ARGUMENTO
%token VALOR
%token <num> NUMERO
%token CUERPO FIN_CUERPO
%token CREAR_VARIABLE ASIGNAR_VARIABLE
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

texto_imprimible:
    IDENT {
        $$ = new std::vector<std::string>();
        $$->push_back($1);
    }
  | texto_imprimible IDENT {
        $$ = $1;
        $$->push_back($2);
    }
;

tipo:
    TIPO_INT    { $$ = strdup("int"); }
  | TIPO_FLOAT  { $$ = strdup("float"); }
;

sentencia:
    CREAR_VARIABLE tipo IDENT {
        auto v = new VarDeclNode();
        v->type = $2;
        v->name = $3;
        $$ = v;
    }
  | ASIGNAR_VARIABLE IDENT VALOR IDENT {
        auto a = new AssignNode();
        a->name = $2;
        a->value = $4;
        $$ = a;
    }
  | IMPRIMIR_TEXTO texto_imprimible {
        auto p = new PrintNode();
        for (auto& w : *$2) {
            p->text += w + " ";
        }
        delete $2;
        $$ = p;
    }
  | DESDE NUMERO HASTA NUMERO CUERPO lista_sentencias FIN_CUERPO {
        auto f = new ForNode();
        f->start = $2;
        f->end   = $4;
        f->body.reset(static_cast<BlockNode*>($6));
        $$ = f;
    }
;

lista_sentencias:
    sentencia {
        auto block = new BlockNode();
        block->statements.emplace_back(
            std::unique_ptr<StatementNode>(
                static_cast<StatementNode*>($1)
            )
        );
        $$ = block;
    }
  | lista_sentencias sentencia {
        auto block = static_cast<BlockNode*>($1);
        block->statements.emplace_back(
            std::unique_ptr<StatementNode>(
                static_cast<StatementNode*>($2)
            )
        );
        $$ = block;
    }
;

definicion_funcion:
    FUNCION tipo IDENT PARAMETRO parametros CUERPO lista_sentencias FIN_CUERPO {
        auto fn = new FunctionNode();
        fn->returnType = $2;
        fn->name = $3;
        fn->params = *$5;
        delete $5;
        fn->body.reset(static_cast<BlockNode*>($7));
        $$ = fn;
    }
;

funcion_principal:
    PRINCIPAL CUERPO lista_sentencias FIN_CUERPO {
        auto m = new MainFunctionNode();
        m->body.reset(static_cast<BlockNode*>($3));
        $$ = m;
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

