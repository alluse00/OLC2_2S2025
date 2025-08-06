#include <stdio.h>

/* Declaraciones generadas por Bison/Flex */
int yyparse(void);

int main(void) {
    printf("Validador de secuencias alternadas (dígito,letra,dígito,...)\n");
    printf("Ingrese secuencias separadas por comas (Ctrl+D para salir)\n");
    printf("Ejemplo: 1,A,2,b,3,Z\n> ");
    if (yyparse() != 0) {
        fprintf(stderr, "Fallo en el parseo\n");
        return 1;
    }
    printf("\nPrograma terminado.\n");
    return 0;
}
