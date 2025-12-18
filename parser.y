
%{
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iostream>

int yylex(void);

std::ofstream salida("resultado.cpp");

void yyerror(const char *s) {
    std::cerr << "Error de parseo: " << s << std::endl;
}
%}

%union {
    char* str;
}

%token INICIAR FINALIZAR
%token FUNCION PRINCIPAL
%token TIPO_FLOAT
%token SUMAR IMPRIMIR
%token <str> IDENT

%%

programa:
    INICIAR instrucciones FINALIZAR {
        salida.close();
        std::cout << "Archivo resultado.cpp generado\n";
    }
;

instrucciones:
    instruccion
  | instrucciones instruccion
;

instruccion:
    definicion_funcion
  | funcion_principal
;

/* -------- DEFINICIÓN DE FUNCIÓN -------- */

definicion_funcion:
    FUNCION TIPO_FLOAT SUMAR IDENT IDENT IDENT {
        salida << "#include <iostream>\n\n";
        salida << "float sumar(float "
               << $4 << ", float "
               << $5 << ", float "
               << $6 << ") {\n";
        salida << "    return " << $4
               << " + " << $5
               << " + " << $6 << ";\n";
        salida << "}\n\n";
    }
;

/* -------- FUNCIÓN PRINCIPAL -------- */

funcion_principal:
    FUNCION PRINCIPAL IMPRIMIR {
        salida << "int main() {\n";
        salida << "    float a = 1, b = 2, c = 3;\n";
        salida << "    std::cout << sumar(a, b, c) << std::endl;\n";
        salida << "    return 0;\n";
        salida << "}\n";
    }
;

%%

