%{
#include "parser.tab.h"  /* trae YYSTYPE, YYLTYPE, yylval, yylloc */
#include <stdlib.h>
#include <string.h>

/* Contadores de línea y columna */
int yycolumn = 1;

/* antes de cada token actualiza yylloc y columna */
#define YY_USER_ACTION                                   \
    yylloc.first_line   = yylineno;                      \
    yylloc.first_column = yycolumn;                      \
    yylloc.last_line    = yylineno;                      \
    yylloc.last_column  = yycolumn + yyleng - 1;         \
    yycolumn           += yyleng;
%}

/* Opciones de Flex */
%option noyywrap yylineno

/* Definiciones */
LETTER  [a-zA-Z_]
DIGIT   [0-9]
ID      {LETTER}({LETTER}|{DIGIT})*

%%

"\n" {
    ++yylineno;
    yycolumn = 1;
    /* Ubicación al inicio de la nueva línea */
    yylloc.first_line   = yylineno;
    yylloc.first_column = 1;
    yylloc.last_line    = yylineno;
    yylloc.last_column  = 1;
    return '\n';
}

"print" {
    return PRINT;
}

"if" {
    return IF;
}

"then" {
    return THEN;
}

"else" {
    return ELSE;
}

{ID} {
    yylval.str = strdup(yytext);
    return IDENTIFIER;
}

{DIGIT}+ {
    yylval.str = strdup(yytext);
    return NUMBER;
}

"(" {
    return LPAREN;
}

")" {
    return RPAREN;
}

";" {
    return SEMICOLON;
}

">" {
    return GT;
}

"<" {
    return LT;
}

"=" {
    return EQ;
}

">=" {
    return GTE;
}

"<=" {
    return LTE;
}

"==" {
    return EQUAL;
}

"!=" {
    return NOTEQUAL;
}

[ \t]+ {
    /* avanzamos columna en YY_USER_ACTION */
}

. {
    /* Error léxico: usamos yylloc.first_column */
    fprintf(stderr,
            "Error léxico: carácter inválido '%c' en %d:%d\n",
            yytext[0],
            yylloc.first_line,
            yylloc.first_column);
    return yytext[0];
}

%%
