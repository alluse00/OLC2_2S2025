%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/* Declaraciones de funciones */
extern int yylex(void);
void yyerror(const char *s);
double binary_to_decimal(const char *binary_str);

/* Variable para almacenar el resultado */
double result = 0.0;
%}

%locations

%union {
    char *str;
    double num;
}

%token <str> BINARY_NUMBER BINARY_INTEGER_ONLY
%type <num> expression

%start program

%%

program:
    expression '\n' {
        printf("= %.3f\n> ", $1);
    }
    | program expression '\n' {
        printf("= %.3f\n> ", $2);
    }
    | program '\n' {
        printf("> ");
    }
    | /* vacío */ {
        /* Al inicio del programa */
    }
    ;

expression:
    BINARY_NUMBER {
        $$ = binary_to_decimal($1);
        free($1);
    }
    | BINARY_INTEGER_ONLY {
        $$ = binary_to_decimal($1);
        free($1);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error en línea %d, columna %d: %s\n", 
            yylloc.first_line, yylloc.first_column, s);
}

/* Función para convertir número binario a decimal */
double binary_to_decimal(const char *binary_str) {
    int len = strlen(binary_str);
    double result = 0.0;
    int dot_pos = -1;
    
    /* Encontrar la posición del punto decimal */
    for (int i = 0; i < len; i++) {
        if (binary_str[i] == '.') {
            dot_pos = i;
            break;
        }
    }
    
    /* Si no hay punto, es solo parte entera */
    if (dot_pos == -1) {
        dot_pos = len;
    }
    
    /* Convertir parte entera */
    for (int i = 0; i < dot_pos; i++) {
        if (binary_str[i] == '1') {
            result += pow(2, dot_pos - 1 - i);
        }
    }
    
    /* Convertir parte fraccionaria */
    for (int i = dot_pos + 1; i < len; i++) {
        if (binary_str[i] == '1') {
            result += pow(2, dot_pos - i);
        }
    }
    
    return result;
}
