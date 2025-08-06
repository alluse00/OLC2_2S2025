%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declaraciones de funciones */
extern int yylex(void);
void yyerror(const char *s);

/* Variable global para contar las letras 'a' */
int count_a = 0;

%}

%locations

%union {
    int count;
}

%token LETTER_A_TOKEN LETTER_OTHER_TOKEN

%type <count> string_content letters string

%start program

%%

program:
    /* vacío */ {
        /* Al inicio del programa */
        printf("Contador de letras 'a' en cadenas\n");
        printf("Ingrese una cadena de letras minúsculas (Ctrl+D para terminar)\n");
        printf("Ejemplo: abracadabra\n> ");
        count_a = 0;
    }
    | program string '\n' {
        printf("Resultado: %d\n> ", count_a);
        count_a = 0;  /* Reiniciar contador para la siguiente cadena */
    }
    | program '\n' {
        printf("> ");
    }
    ;

string:
    string_content {
        /* El conteo se realiza durante el análisis */
        $$ = $1;
    }
    | /* cadena vacía */ {
        $$ = 0;
    }
    ;

string_content:
    letters {
        $$ = $1;
    }
    ;

letters:
    LETTER_A_TOKEN {
        count_a++;
        $$ = 1;
    }
    | LETTER_OTHER_TOKEN {
        $$ = 0;
    }
    | letters LETTER_A_TOKEN {
        count_a++;
        $$ = $1 + 1;
    }
    | letters LETTER_OTHER_TOKEN {
        $$ = $1;
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error en línea %d, columna %d: %s\n", 
            yylloc.first_line, yylloc.first_column, s);
}
