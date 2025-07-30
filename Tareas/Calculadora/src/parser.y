%{
#include <stdio.h>
#include <stdlib.h>

/* Prototipo del scanner */
extern int yylex(void);
/* yyerror con firma estándar */
void yyerror(const char *s);
%}

/* Seguimiento de ubicaciones */
%locations
/* Mensajes de error más detallados */
//%define parse.error verbose

/* Unión de tipos semánticos */
%union {
  int num;
}

/* Tokens tipados */
%token <num> NUMBER
/* Tipo de los no-terminales que llevan valor */
%type  <num> expr

/* Precedencias */
%left '+' '-'
%left '*' '/'
%right UMINUS    /* Precedencia del menos unario */

%%

input:
    /* vacío */
  | input line
  ;

line:
    '\n'
  | expr '\n'   { printf("= %d\n", $1); }
  | error '\n'  { yyerrok; }
  ;

expr:
    expr '+' expr   { $$ = $1 + $3; }
  | expr '-' expr   { $$ = $1 - $3; }
  | expr '*' expr   { $$ = $1 * $3; }
  | expr '/' expr   { 
      if ($3 == 0) {
          fprintf(stderr, "Error: División por cero en %d:%d\n", 
                  @3.first_line, @3.first_column);
          YYERROR;
      }
      $$ = $1 / $3; 
  }
  | '-' expr %prec UMINUS { $$ = -$2; }
  | '(' expr ')'    { $$ = $2; }
  | NUMBER          { $$ = $1; }
  ;
%%

/* definición de yyerror, usa el yylloc global para ubicación */
void yyerror(const char *s) {
    fprintf(stderr,
            "%s en %d:%d\n",
            s,
            yylloc.first_line,
            yylloc.first_column);
}