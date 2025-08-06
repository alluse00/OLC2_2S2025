#include <stdio.h>

/* Declaraciones generadas por Bison/Flex */
int yyparse(void);

/* Variable externa para el conteo */
extern int count_a;

int main(void) {
    if (yyparse() != 0) {
        fprintf(stderr, "Fallo en el parseo\n");
        return 1;
    }
    
    printf("Programa terminado.\n");
    return 0;
}
