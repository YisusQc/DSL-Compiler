%{
#include "parser.tab.h"
#include <cstring>
#include <cstdio>
%}

%x TEXTMODE

%%
\"text\"[ \t]*:[ \t]*\"   { BEGIN(TEXTMODE); }
<TEXTMODE>\"              { BEGIN(INITIAL); }

<TEXTMODE>"iniciar programa"        { printf("TOKEN: '%s'\n", yytext); return INICIAR; }
<TEXTMODE>"terminar programa"      { printf("TOKEN: '%s'\n", yytext); return FINALIZAR; }

<TEXTMODE>"entera"|"entero"          { printf("TOKEN: '%s'\n", yytext); return TIPO_INT; }
<TEXTMODE>"flotante"                 { printf("TOKEN: '%s'\n", yytext); return TIPO_FLOAT; }

<TEXTMODE>"crear función principal"|"crea función principal"  { printf("TOKEN: '%s'\n", yytext); return PRINCIPAL; }

<TEXTMODE>"crear función"|"crea función"|"crea una función"        { printf("TOKEN: '%s'\n", yytext); return FUNCION; }

<TEXTMODE>"con parámetro"|"con parámetros"          { printf("TOKEN: '%s'\n", yytext); return PARAMETRO; }

<TEXTMODE>"con argumento"|"con argumentos"          { printf("TOKEN: '%s'\n", yytext); return ARGUMENTO; }

<TEXTMODE>"crear variable"|"crea variable"           { printf("TOKEN: '%s'\n", yytext); return CREAR_VARIABLE; }

<TEXTMODE>"asignar variable"         { printf("TOKEN: '%s'\n", yytext); return ASIGNAR_VARIABLE; }

<TEXTMODE>"con valor"|"con el valor de"|"el valor"                { printf("TOKEN: '%s'\n", yytext); return VALOR; }

<TEXTMODE>"desde"                    { return DESDE; }
<TEXTMODE>"hasta"                    { return HASTA; }
<TEXTMODE>"iterador"                 { return I; }

<TEXTMODE>"imprime"|"imprimir"                { printf("TOKEN: '%s'\n", yytext); return IMPRIMIR; }

<TEXTMODE>"imprimir texto"           { return IMPRIMIR_TEXTO; }
<TEXTMODE>"fin texto"                { return FIN_TEXTO; }

<TEXTMODE>"que"|"una"|"y"|"el"|"la"|"resultado"|"instrucciones"|"haz"|"en"                     { /* ignorar */ }

<TEXTMODE>[a-zA-Z]+ {
    printf("IDENT: '%s'\n", yytext);
    yylval.str = strdup(yytext);
    return IDENT;
}

<TEXTMODE>[ \t\r\n]+      { /*printf("Ignorar: '%s'\n", yytext);/* ignorar */ }

<INITIAL>[ \t\r\n]+       { /* ignorar */ }
<INITIAL>.                { /* ignorar */ }

%%

int yywrap() { return 1; }

