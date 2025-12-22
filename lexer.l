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
<TEXTMODE>"finalizar programa"      { printf("TOKEN: '%s'\n", yytext); return FINALIZAR; }

<TEXTMODE>"entera"|"entero"          { printf("TOKEN: '%s'\n", yytext); return TIPO_INT; }
<TEXTMODE>"flotante"                 { printf("TOKEN: '%s'\n", yytext); return TIPO_FLOAT; }

<TEXTMODE>"crear función principal"|"crea función principal"  { printf("TOKEN: '%s'\n", yytext); return PRINCIPAL; }

<TEXTMODE>"crear función"|"crea función"|"crea una función"        { printf("TOKEN: '%s'\n", yytext); return FUNCION; }

<TEXTMODE>"fin cuerpo"    {  printf("TOKEN: '%s'\n", yytext); return FIN_CUERPO; }
<TEXTMODE>"cuerpo"        {  printf("TOKEN: '%s'\n", yytext); return CUERPO; }

<TEXTMODE>"con parámetro"|"con parámetros"          { printf("TOKEN: '%s'\n", yytext); return PARAMETRO; }

<TEXTMODE>"con argumento"|"con argumentos"          { printf("TOKEN: '%s'\n", yytext); return ARGUMENTO; }

<TEXTMODE>"crear variable"|"crea variable"           { printf("TOKEN: '%s'\n", yytext); return CREAR_VARIABLE; }
<TEXTMODE>"asignar variable"         { printf("TOKEN: '%s'\n", yytext); return ASIGNAR_VARIABLE; }

<TEXTMODE>"con valor"|"con el valor de"|"el valor"                { printf("TOKEN: '%s'\n", yytext); return VALOR; }

<TEXTMODE>"desde"                    { printf("TOKEN: '%s'\n", yytext); return DESDE; }
<TEXTMODE>"hasta"                    { printf("TOKEN: '%s'\n", yytext); return HASTA; }

<TEXTMODE>"imprime"|"imprimir"                { printf("TOKEN: '%s'\n", yytext); return IMPRIMIR; }
<TEXTMODE>"imprimir texto"           { printf("TOKEN: '%s'\n", yytext); return IMPRIMIR_TEXTO; }
<TEXTMODE>"fin texto"                { return FIN_TEXTO; }

<TEXTMODE>"uno"   { printf("NUMERO: '%s'\n", yytext); yylval.num = 1; return NUMERO; }
<TEXTMODE>"dos"   { printf("NUMERO: '%s'\n", yytext); yylval.num = 2; return NUMERO; }
<TEXTMODE>"tres"  { printf("NUMERO: '%s'\n", yytext); yylval.num = 3; return NUMERO; }
<TEXTMODE>"cuatro"  { printf("NUMERO: '%s'\n", yytext); yylval.num = 4; return NUMERO; }
<TEXTMODE>"cinco"  { printf("NUMERO: '%s'\n", yytext); yylval.num = 5; return NUMERO; }
<TEXTMODE>"seis"  { printf("NUMERO: '%s'\n", yytext); yylval.num = 6; return NUMERO; }
<TEXTMODE>"siete"  { printf("NUMERO: '%s'\n", yytext); yylval.num = 7; return NUMERO; }
<TEXTMODE>"ocho"  { printf("NUMERO: '%s'\n", yytext); yylval.num = 8; return NUMERO; }
<TEXTMODE>"nueve"  { printf("NUMERO: '%s'\n", yytext); yylval.num = 9; return NUMERO; }

<TEXTMODE>"que"|"una"|"y"|"el"|"la"|"resultado"|"instrucciones"|"haz"|"en"                     { /* ignorar */ }

<TEXTMODE>[^ \t\r\n]+ {
    printf("IDENT: '%s'\n", yytext);
    yylval.str = strdup(yytext);
    return IDENT;
}

<TEXTMODE>[ \t\r\n]+      { /* ignorar */ }

<INITIAL>[ \t\r\n]+       { /* ignorar */ }
<INITIAL>.                { /* ignorar */ }

%%

int yywrap() { return 1; }

