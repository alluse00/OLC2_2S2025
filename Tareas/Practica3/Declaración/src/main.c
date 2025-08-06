#include <stdio.h>

/* Declaraciones generadas por Bison/Flex */
int yyparse(void);

/* Declaraciones externas */
extern void print_declarations();
extern void free_declarations();

int main(void) {
    if (yyparse() != 0) {
        fprintf(stderr, "Fallo en el parseo\n");
        return 1;
    }
    
    printf("\nDeclaraciones procesadas:\n");
    print_declarations();
    
    /* Limpiar memoria */
    free_declarations();
    
    printf("Programa terminado.\n");
    return 0;
}
