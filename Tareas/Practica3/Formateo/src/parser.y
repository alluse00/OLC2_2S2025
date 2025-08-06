%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declaraciones de funciones */
extern int yylex(void);
void yyerror(const char *s);

/* Variable global para el nivel de indentación */
int indent_level = 0;

/* Funciones para manejo de indentación */
void print_indent();
void increase_indent();
void decrease_indent();

%}

%locations

%union {
    char *str;
}

%token <str> IDENTIFIER NUMBER
%token PRINT IF THEN ELSE
%token LPAREN RPAREN SEMICOLON
%token GT LT EQ GTE LTE EQUAL NOTEQUAL

%type <str> condition expression comparison_op

%start program

%%

program:
    /* vacío */ {
        /* Al inicio del programa */
        printf("Formateador de código con indentación\n");
        printf("Ingrese código (Ctrl+D para terminar)\n");
        printf("Ejemplo: print(a); if(a>0) then print(b); else print(c);\n");
        printf("Código formateado:\n");
    }
    | program statement_sequence '\n' {
        printf("\n");
    }
    | program '\n' {
        /* Línea vacía */
    }
    ;

statement_sequence:
    statement
    | statement_sequence statement
    ;

statement:
    print_statement
    | if_statement
    ;

print_statement:
    PRINT LPAREN expression RPAREN SEMICOLON {
        print_indent();
        printf("print(%s);\n", $3);
        free($3);
    }
    ;

if_statement:
    IF LPAREN condition RPAREN THEN {
        print_indent();
        printf("if(%s) then\n", $3);
        free($3);
        increase_indent();
    } statement_sequence ELSE {
        decrease_indent();
        print_indent();
        printf("else\n");
        increase_indent();
    } statement_sequence {
        decrease_indent();
    }
    ;

condition:
    expression comparison_op expression {
        char *result = malloc(strlen($1) + strlen($2) + strlen($3) + 1);
        sprintf(result, "%s%s%s", $1, $2, $3);
        free($1);
        free($2);
        free($3);
        $$ = result;
    }
    | expression {
        $$ = $1;
    }
    ;

comparison_op:
    GT { $$ = strdup(">"); }
    | LT { $$ = strdup("<"); }
    | EQ { $$ = strdup("="); }
    | GTE { $$ = strdup(">="); }
    | LTE { $$ = strdup("<="); }
    | EQUAL { $$ = strdup("=="); }
    | NOTEQUAL { $$ = strdup("!="); }
    ;

expression:
    IDENTIFIER { $$ = $1; }
    | NUMBER { $$ = $1; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error en línea %d, columna %d: %s\n", 
            yylloc.first_line, yylloc.first_column, s);
}

/* Función para imprimir la indentación actual */
void print_indent() {
    for (int i = 0; i < indent_level; i++) {
        printf("    "); /* 4 espacios por nivel */
    }
}

/* Función para incrementar el nivel de indentación */
void increase_indent() {
    indent_level++;
}

/* Función para decrementar el nivel de indentación */
void decrease_indent() {
    if (indent_level > 0) {
        indent_level--;
    }
}
