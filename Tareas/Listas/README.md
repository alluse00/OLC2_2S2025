# Validador de Secuencias Alternadas

Este proyecto implementa un analizador léxico y sintáctico que valida secuencias de símbolos separados por comas, verificando que alternen correctamente entre dígitos (0-9) y letras (A-Z, a-z).

## Características

- Valida alternancia correcta: dígito → letra → dígito → letra...
- Detecta violaciones de la regla de alternancia
- Reporta la posición exacta (índice) donde ocurre el error
- Soporta tanto letras mayúsculas como minúsculas
- Interfaz interactiva de línea de comandos

## Reglas de validación

1. **Secuencia válida**: Debe comenzar con un dígito (0-9)
2. **Alternancia**: Después de cada dígito debe seguir una letra (A-Z, a-z)
3. **Continuidad**: Después de cada letra debe seguir un dígito
4. **Separación**: Los elementos deben estar separados por comas

## Ejemplos de uso

### Secuencia válida:
```
Entrada: 1,A,2,b,3,Z
Salida: Cadena válida
```

### Secuencia con error:
```
Entrada: 1,A,2,3,B
Salida: Error en el elemento 4
```

### Secuencia que empieza mal:
```
Entrada: A,1,B,2
Salida: Error en el elemento 1
```

## Estructura del proyecto

```
├── Makefile          # Sistema de construcción
├── src/
│   ├── lexer.l       # Analizador léxico (Flex)
│   ├── parser.y      # Analizador sintáctico (Bison)
│   └── main.c        # Programa principal
└── build/            # Archivos generados
    ├── sequence_validator
    ├── lex.yy.c
    ├── parser.tab.c
    └── parser.tab.h
```

## Compilación y ejecución

### Compilar el proyecto:
```bash
make
```

### Ejecutar el programa:
```bash
./build/sequence_validator
```

### Ejecutar pruebas automáticas:
```bash
make test
```

### Limpiar archivos generados:
```bash
make clean
```

## Algoritmo de validación

El algoritmo mantiene un estado interno que alterna entre "esperando dígito" y "esperando letra":

1. **Estado inicial**: Esperando dígito (posición 1)
2. **Al recibir dígito**: 
   - Si se esperaba dígito → continuar esperando letra
   - Si se esperaba letra → marcar error en posición actual
3. **Al recibir letra**: 
   - Si se esperaba letra → continuar esperando dígito  
   - Si se esperaba dígito → marcar error en posición actual
4. **Contador de posición**: Se incrementa con cada elemento procesado

### Casos de error comunes:

- **Dos dígitos consecutivos**: `1,A,2,3` → Error en elemento 4
- **Dos letras consecutivas**: `1,A,B,2` → Error en elemento 3  
- **Empezar con letra**: `A,1,2` → Error en elemento 1

## Tecnologías utilizadas

- **Flex**: Generador de analizadores léxicos
- **Bison**: Generador de analizadores sintácticos  
- **GCC**: Compilador de C
- **Make**: Sistema de construcción

## Tokens reconocidos

- `DIGIT_TOKEN`: Dígitos del 0 al 9
- `LETTER_TOKEN`: Letras de A-Z y a-z
- `COMMA`: Separador de elementos (,)
- `\n`: Terminador de línea

## Requisitos

- GCC
- Flex  
- Bison
- Make
