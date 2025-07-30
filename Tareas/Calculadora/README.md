# Calculadora Simple

Este proyecto implementa una calculadora básica usando Flex (analizador léxico) y Bison (analizador sintáctico) que puede evaluar expresiones aritméticas simples con números enteros.

## Características

- Operaciones aritméticas básicas: suma (+), multiplicación (*)
- Soporte para paréntesis para cambiar precedencia
- Números enteros positivos
- Evaluación inmediata con resultado en pantalla
- Manejo de errores léxicos y sintácticos con ubicación precisa
- Interfaz interactiva de línea de comandos

## Ejemplos de uso

```
Entrada: 5+5
Salida: = 10

Entrada: 3*4
Salida: = 12

Entrada: (2+3)*4
Salida: = 20

Entrada: 10+5*2
Salida: = 20  (precedencia: multiplicación antes que suma)
```

## Estructura del proyecto

```
├── Makefile          # Sistema de construcción
├── src/
│   ├── lexer.l       # Analizador léxico (Flex)
│   ├── parser.y      # Analizador sintáctico (Bison)
│   └── main.c        # Programa principal
└── build/            # Archivos generados
    ├── calc
    ├── lex.yy.c
    ├── parser.tab.c
    ├── parser.tab.h
    └── parser.output
```

## Compilación y ejecución

### Compilar el proyecto:
```bash
make
```

### Ejecutar la calculadora:
```bash
./build/calc
```

### Limpiar archivos generados:
```bash
make clean
```

## Gramática soportada

La calculadora reconoce la siguiente gramática:

```
input → ε | input line
line  → '\n' | expr '\n' | error '\n'
expr  → expr '+' expr
      | expr '*' expr  
      | '(' expr ')'
      | NUMBER
```

### Precedencia de operadores:
1. **Paréntesis** `()` - Mayor precedencia
2. **Multiplicación** `*` - Precedencia media
3. **Suma** `+` - Menor precedencia

### Asociatividad:
- Todos los operadores son **asociativos por la izquierda**

## Tokens reconocidos

- **NUMBER**: Secuencia de dígitos (0-9)
- **Operadores**: `+` (suma), `*` (multiplicación)
- **Paréntesis**: `(` y `)`
- **Salto de línea**: `\n` (para ejecutar la expresión)

## Manejo de errores

### Error léxico:
```bash
Entrada: 5+a
Salida: Error léxico: carácter inválido 'a' en 1:3
```

### Error sintáctico:
```bash
Entrada: 5++3
Salida: syntax error en 1:3
```

### Recuperación de errores:
- El parser puede recuperarse de errores sintácticos
- Continúa procesando la siguiente línea después de un error

## Algoritmo de evaluación

La calculadora usa **evaluación dirigida por sintaxis** (Syntax-Directed Translation):

1. **Análisis léxico**: Convierte la entrada en tokens
2. **Análisis sintáctico**: Construye el árbol de derivación
3. **Evaluación**: Cada regla gramatical tiene una acción semántica asociada

### Acciones semánticas:

```c
expr '+' expr   { $$ = $1 + $3; }    // Suma los operandos
expr '*' expr   { $$ = $1 * $3; }    // Multiplica los operandos  
'(' expr ')'    { $$ = $2; }         // Retorna el valor de la expresión
NUMBER          { $$ = $1; }         // Retorna el valor del número
```

## Tecnologías utilizadas

- **Flex 2.6+**: Generador de analizadores léxicos
- **Bison 3.0+**: Generador de analizadores sintácticos
- **GCC**: Compilador de C
- **Make**: Sistema de construcción

## Características técnicas

### Seguimiento de ubicaciones:
- Usa `%locations` en Bison para rastrear posición de tokens
- Macro `YY_USER_ACTION` en Flex para actualizar ubicaciones
- Reporta errores con línea y columna precisas

### Gestión de memoria:
- No requiere liberación manual de memoria
- Los valores semánticos son tipos simples (int)

### Recuperación de errores:
- Usa `error` en la gramática para recuperación
- `yyerrok` permite continuar después de errores

## Limitaciones

- Solo soporta números enteros positivos
- No incluye resta (-) ni división (/)
- No maneja números negativos
- No soporta números decimales
- Sin variables o asignaciones

## Extensiones posibles

1. **Más operadores**: resta (-), división (/), módulo (%)
2. **Números negativos**: soporte para operador unario menos
3. **Números decimales**: punto flotante
4. **Variables**: asignación y uso de variables
5. **Funciones**: sin, cos, sqrt, etc.
6. **Expresiones booleanas**: comparaciones y operadores lógicos

## Requisitos del sistema

- Linux/Unix con bash
- GCC (GNU Compiler Collection)
- Flex (Fast Lexical Analyzer)
- Bison (GNU Parser Generator)
- Make

## Instalación de dependencias

### Ubuntu/Debian:
```bash
sudo apt-get install gcc flex bison make
```

### CentOS/RHEL:
```bash
sudo yum install gcc flex bison make
```

### Arch Linux:
```bash
sudo pacman -S gcc flex bison make
```
