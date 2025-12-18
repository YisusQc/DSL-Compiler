
%{
#include "parser.tab.h"
#include <cstring>
%}

%%
\"text\"[ \t]*:[ \t]*\"   { /* inicio del texto */ }
\"                        { /* fin del texto */ }

"iniciar"                 { return INICIAR; }
"finalizar"               { return FINALIZAR; }

"funcion"                 { return FUNCION; }
"principal"               { return PRINCIPAL; }

"flotante"                { return TIPO_FLOAT; }

"sume"|"sumar"            { return SUMAR; }

"imprima"|"imprimir"      { return IMPRIMIR; }

"que"|"una"|"y"|"el"|"la"|"resultado"|"instrucciones"|"haz" {
    /* palabras de relleno */
}

[a-zA-Z]+ {
    yylval.str = strdup(yytext);
    return IDENT;
}

[ \t\n]+                  { /* ignorar */ }

.                          { /* ignorar */ }
%%

int yywrap() { return 1; }

