#include <stdio.h>

/* Declaraciones generadas por Bison/Flex */
int yyparse(void);

int main(void) {
    printf("Convertidor de notación postfija a infija (Ctrl+D para salir)\n");
    printf("Ingrese expresiones en notación postfija separadas por espacios\n");
    printf("Ejemplo: 3 4 + 5 *\n> ");
    if (yyparse() != 0) {
        fprintf(stderr, "Fallo en el parseo\n");
        return 1;
    }
    printf("\nPrograma terminado.\n");
    return 0;
}
