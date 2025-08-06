%{
#include <stdio.h>
#include <stdlib.h>

/* Declaraciones de funciones */
extern int yylex(void);
void yyerror(const char *s);

/* Variables para el control de alternancia */
int element_count = 1;  /* Contador de elementos (1-indexed) */
int expecting_digit = 1; /* 1 si esperamos dígito, 0 si esperamos letra */
int validation_error = 0; /* Flag para indicar error de validación */
int error_position = 0;   /* Posición donde ocurrió el error */
%}

%locations

%union {
    char character;
}

%token <character> DIGIT_TOKEN LETTER_TOKEN
%token COMMA

%start program

%%

program:
    sequence '\n' {
        if (!validation_error) {
            printf("Cadena válida\n> ");
        }
        /* Reiniciar variables para la siguiente entrada */
        element_count = 1;
        expecting_digit = 1;
        validation_error = 0;
        error_position = 0;
    }
    | program sequence '\n' {
        if (!validation_error) {
            printf("Cadena válida\n> ");
        }
        /* Reiniciar variables para la siguiente entrada */
        element_count = 1;
        expecting_digit = 1;
        validation_error = 0;
        error_position = 0;
    }
    | program '\n' {
        printf("> ");
    }
    | /* vacío */ {
        /* Al inicio del programa */
    }
    ;

sequence:
    element
    | sequence COMMA element
    ;

element:
    DIGIT_TOKEN {
        if (!expecting_digit && !validation_error) {
            validation_error = 1;
            error_position = element_count;
            printf("Error en el elemento %d\n> ", error_position);
        } else if (!validation_error) {
            expecting_digit = 0; /* Ahora esperamos letra */
            element_count++;
        }
    }
    | LETTER_TOKEN {
        if (expecting_digit && !validation_error) {
            validation_error = 1;
            error_position = element_count;
            printf("Error en el elemento %d\n> ", error_position);
        } else if (!validation_error) {
            expecting_digit = 1; /* Ahora esperamos dígito */
            element_count++;
        }
    }
    ;

%%

void yyerror(const char *s) {
    if (!validation_error) {
        fprintf(stderr, "Error de sintaxis en línea %d, columna %d: %s\n", 
                yylloc.first_line, yylloc.first_column, s);
    }
}
