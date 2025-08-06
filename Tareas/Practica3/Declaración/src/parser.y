%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declaraciones de funciones */
extern int yylex(void);
void yyerror(const char *s);

/* Estructura para representar una declaración */
typedef struct Declaration {
    char *identifier;
    char *type;
    struct Declaration *next;
} Declaration;

/* Lista global de declaraciones */
Declaration *declarations_list = NULL;

/* Funciones para manejo de declaraciones */
void add_declaration(const char *id, const char *type);
void print_declarations();
void free_declarations();
Declaration* create_declaration_node(const char *id, const char *type);

%}

%locations

%union {
    char *str;
    struct Declaration *decl_list;
}

%token <str> TYPE IDENTIFIER
%token COMMA SEMICOLON

%type <str> type
%type <decl_list> identifier_list

%start program

%%

program:
    /* vacío */ {
        /* Al inicio del programa */
        printf("Analizador de declaraciones de variables\n");
        printf("Ingrese declaraciones (Ctrl+D para terminar)\n");
        printf("Ejemplo: int x, y; char a; int b;\n> ");
    }
    | program declaration {
        printf("> ");
    }
    | program '\n' {
        printf("> ");
    }
    ;

declaration:
    type identifier_list SEMICOLON {
        /* Propagamos el tipo heredado a todos los identificadores */
        /* Primero invertimos la lista para mantener el orden original */
        Declaration *reversed = NULL;
        Declaration *current = $2;
        while (current != NULL) {
            Declaration *next = current->next;
            current->next = reversed;
            reversed = current;
            current = next;
        }
        
        /* Ahora procesamos la lista invertida */
        current = reversed;
        while (current != NULL) {
            add_declaration(current->identifier, $1);
            Declaration *temp = current;
            current = current->next;
            free(temp->identifier);
            free(temp);
        }
        free($1);
    }
    ;

type:
    TYPE {
        $$ = strdup($1);
        free($1);
    }
    ;

identifier_list:
    IDENTIFIER {
        /* Crear el primer nodo de la lista */
        $$ = create_declaration_node($1, NULL);
        free($1);
    }
    | identifier_list COMMA IDENTIFIER {
        /* Agregar un nuevo nodo a la lista */
        Declaration *new_node = create_declaration_node($3, NULL);
        new_node->next = $1;
        $$ = new_node;
        free($3);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error en línea %d, columna %d: %s\n", 
            yylloc.first_line, yylloc.first_column, s);
}

/* Función para crear un nuevo nodo de declaración */
Declaration* create_declaration_node(const char *id, const char *type) {
    Declaration *node = malloc(sizeof(Declaration));
    if (!node) {
        fprintf(stderr, "Error: no se pudo asignar memoria\n");
        exit(1);
    }
    node->identifier = strdup(id);
    node->type = type ? strdup(type) : NULL;
    node->next = NULL;
    return node;
}

/* Función para agregar una declaración a la lista global */
void add_declaration(const char *id, const char *type) {
    Declaration *new_decl = create_declaration_node(id, type);
    
    /* Agregar al final de la lista para mantener el orden */
    if (!declarations_list) {
        declarations_list = new_decl;
    } else {
        Declaration *current = declarations_list;
        while (current->next) {
            current = current->next;
        }
        current->next = new_decl;
    }
}

/* Función para imprimir todas las declaraciones */
void print_declarations() {
    if (!declarations_list) {
        printf("[]\n");
        return;
    }
    
    printf("[");
    Declaration *current = declarations_list;
    int first = 1;
    
    /* Recorremos la lista en orden directo */
    while (current) {
        if (!first) printf(", ");
        printf("(%s,%s)", current->identifier, current->type);
        first = 0;
        current = current->next;
    }
    
    printf("]\n");
}

/* Función para liberar la memoria de las declaraciones */
void free_declarations() {
    Declaration *current = declarations_list;
    while (current) {
        Declaration *temp = current;
        current = current->next;
        free(temp->identifier);
        free(temp->type);
        free(temp);
    }
    declarations_list = NULL;
}
