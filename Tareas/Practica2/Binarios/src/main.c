#include <stdio.h>

/* Declaraciones generadas por Bison/Flex */
int yyparse(void);

int main(void) {
    printf("Convertidor de números binarios a decimal (Ctrl+D para salir)\n");
    printf("Ingrese números binarios (ej: 101.101)\n> ");
    if (yyparse() != 0) {
        fprintf(stderr, "Fallo en el parseo\n");
        return 1;
    }
    printf("\nPrograma terminado.\n");
    return 0;
}
