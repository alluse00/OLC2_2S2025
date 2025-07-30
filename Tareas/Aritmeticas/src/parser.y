%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declaraciones de funciones */
extern int yylex(void);
void yyerror(const char *s);

/* Estructura para la pila de expresiones */
typedef struct {
    char *expr;      /* Expresión en formato string */
    int precedence;  /* Precedencia del operador principal */
} ExprNode;

/* Pila de expresiones */
#define MAX_STACK_SIZE 100
ExprNode stack[MAX_STACK_SIZE];
int stack_top = -1;

/* Funciones para manejo de pila */
void push_number(int num);
void push_expression(char *expr, int prec);
ExprNode pop_expression();
int is_empty();
char* create_infix_expression(ExprNode left, ExprNode right, char op, int op_prec);

/* Precedencias de operadores */
#define PREC_ADD_SUB 1
#define PREC_MUL_DIV 2
%}

%locations

%union {
    int num;
    char *str;
}

%token <num> NUMBER
%token PLUS MINUS MULTIPLY DIVIDE

%start program

%%

program:
    expression '\n' {
        if (stack_top == 0) {
            printf("= %s\n> ", stack[0].expr);
            free(stack[0].expr);
            stack_top = -1;
        } else {
            fprintf(stderr, "Error: expresión postfija inválida\n> ");
            /* Limpiar pila */
            while (stack_top >= 0) {
                free(stack[stack_top].expr);
                stack_top--;
            }
        }
    }
    | program expression '\n' {
        if (stack_top == 0) {
            printf("= %s\n> ", stack[0].expr);
            free(stack[0].expr);
            stack_top = -1;
        } else {
            fprintf(stderr, "Error: expresión postfija inválida\n> ");
            /* Limpiar pila */
            while (stack_top >= 0) {
                free(stack[stack_top].expr);
                stack_top--;
            }
        }
    }
    | program '\n' {
        printf("> ");
    }
    | /* vacío */ {
        /* Al inicio del programa */
    }
    ;

expression:
    /* vacío */
    | expression NUMBER {
        push_number($2);
    }
    | expression PLUS {
        if (stack_top < 1) {
            yyerror("Operador + requiere dos operandos");
            YYERROR;
        }
        ExprNode right = pop_expression();
        ExprNode left = pop_expression();
        char *result = create_infix_expression(left, right, '+', PREC_ADD_SUB);
        push_expression(result, PREC_ADD_SUB);
        free(left.expr);
        free(right.expr);
    }
    | expression MINUS {
        if (stack_top < 1) {
            yyerror("Operador - requiere dos operandos");
            YYERROR;
        }
        ExprNode right = pop_expression();
        ExprNode left = pop_expression();
        char *result = create_infix_expression(left, right, '-', PREC_ADD_SUB);
        push_expression(result, PREC_ADD_SUB);
        free(left.expr);
        free(right.expr);
    }
    | expression MULTIPLY {
        if (stack_top < 1) {
            yyerror("Operador * requiere dos operandos");
            YYERROR;
        }
        ExprNode right = pop_expression();
        ExprNode left = pop_expression();
        char *result = create_infix_expression(left, right, '*', PREC_MUL_DIV);
        push_expression(result, PREC_MUL_DIV);
        free(left.expr);
        free(right.expr);
    }
    | expression DIVIDE {
        if (stack_top < 1) {
            yyerror("Operador / requiere dos operandos");
            YYERROR;
        }
        ExprNode right = pop_expression();
        ExprNode left = pop_expression();
        char *result = create_infix_expression(left, right, '/', PREC_MUL_DIV);
        push_expression(result, PREC_MUL_DIV);
        free(left.expr);
        free(right.expr);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error en línea %d, columna %d: %s\n", 
            yylloc.first_line, yylloc.first_column, s);
}

/* Función para empujar un número a la pila */
void push_number(int num) {
    if (stack_top >= MAX_STACK_SIZE - 1) {
        fprintf(stderr, "Error: desbordamiento de pila\n");
        exit(1);
    }
    stack_top++;
    stack[stack_top].expr = malloc(20);
    sprintf(stack[stack_top].expr, "%d", num);
    stack[stack_top].precedence = 999; /* Los números tienen precedencia máxima */
}

/* Función para empujar una expresión a la pila */
void push_expression(char *expr, int prec) {
    if (stack_top >= MAX_STACK_SIZE - 1) {
        fprintf(stderr, "Error: desbordamiento de pila\n");
        exit(1);
    }
    stack_top++;
    stack[stack_top].expr = expr;
    stack[stack_top].precedence = prec;
}

/* Función para sacar una expresión de la pila */
ExprNode pop_expression() {
    if (stack_top < 0) {
        fprintf(stderr, "Error: pila vacía\n");
        exit(1);
    }
    return stack[stack_top--];
}

/* Función para verificar si la pila está vacía */
int is_empty() {
    return stack_top < 0;
}

/* Función para crear expresión infija con paréntesis según precedencia */
char* create_infix_expression(ExprNode left, ExprNode right, char op, int op_prec) {
    char *result = malloc(500);
    char left_expr[250], right_expr[250];
    
    /* Determinar si necesitamos paréntesis para el operando izquierdo */
    if (left.precedence < op_prec) {
        sprintf(left_expr, "(%s)", left.expr);
    } else {
        strcpy(left_expr, left.expr);
    }
    
    /* Determinar si necesitamos paréntesis para el operando derecho */
    if (right.precedence < op_prec || 
        (right.precedence == op_prec && (op == '-' || op == '/'))) {
        sprintf(right_expr, "(%s)", right.expr);
    } else {
        strcpy(right_expr, right.expr);
    }
    
    sprintf(result, "%s %c %s", left_expr, op, right_expr);
    return result;
}
