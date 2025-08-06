# Convertidor de Notación Postfija a Infija

Este proyecto implementa un analizador que convierte expresiones aritméticas de **notación postfija** (polaca inversa) a **notación infija**, respetando automáticamente la precedencia de operadores y añadiendo paréntesis solo cuando es necesario.

## Características

- Convierte expresiones postfijas a infijas manteniendo precedencia
- Soporta los cuatro operadores básicos: `+`, `-`, `*`, `/`
- Gestión inteligente de paréntesis (solo cuando es necesario)
- Números enteros positivos
- Validación de expresiones postfijas correctas
- Manejo de errores con ubicación precisa
- Interfaz interactiva de línea de comandos

## Ejemplos de uso

### Ejemplo básico:
```
Entrada: 3 4 + 5 *
Salida: = (3 + 4) * 5
```

### Precedencia automática:
```
Entrada: 3 4 * 5 +
Salida: = 3 * 4 + 5
```

### Expresiones complejas:
```
Entrada: 2 3 + 4 5 + *
Salida: = (2 + 3) * (4 + 5)

Entrada: 15 7 1 1 + - / 3 * 2 1 1 + + -
Salida: = 15 / (7 - (1 + 1)) * 3 - (2 + 1 + 1)
```

## Estructura del proyecto

```
├── Makefile          # Sistema de construcción
├── src/
│   ├── lexer.l       # Analizador léxico (Flex)
│   ├── parser.y      # Analizador sintáctico (Bison)
│   └── main.c        # Programa principal
└── build/            # Archivos generados
    ├── postfix_converter
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

### Ejecutar el convertidor:
```bash
./build/postfix_converter
```

### Ejecutar pruebas automáticas:
```bash
make test
```

### Limpiar archivos generados:
```bash
make clean
```

## Algoritmo de conversión

El convertidor utiliza una **pila de expresiones** con información de precedencia:

### Estructura de datos:
```c
typedef struct {
    char *expr;      // Expresión en formato string
    int precedence;  // Precedencia del operador principal
} ExprNode;
```

### Proceso de conversión:

1. **Números**: Se apilan directamente con precedencia máxima (999)
2. **Operadores**: 
   - Se extraen dos operandos de la pila
   - Se evalúa si necesitan paréntesis según precedencia
   - Se construye la expresión infija
   - Se apila el resultado con la precedencia del operador

### Precedencias definidas:
- **Multiplicación (`*`) y División (`/`)**: Precedencia 2 (alta)
- **Suma (`+`) y Resta (`-`)**: Precedencia 1 (baja)
- **Números**: Precedencia 999 (máxima)

### Reglas para paréntesis:

1. **Operando izquierdo**: Requiere paréntesis si su precedencia es menor que la del operador actual
2. **Operando derecho**: Requiere paréntesis si:
   - Su precedencia es menor que la del operador actual, O
   - Su precedencia es igual y el operador es `-` o `/` (no asociativos)

## Tokens reconocidos

- **NUMBER**: Números enteros positivos
- **PLUS**: Operador suma (`+`)
- **MINUS**: Operador resta (`-`)
- **MULTIPLY**: Operador multiplicación (`*`)
- **DIVIDE**: Operador división (`/`)

## Validación de entrada

### Expresión válida:
- El número de operadores debe ser exactamente `n-1` donde `n` es el número de operandos
- Al final debe quedar exactamente un elemento en la pila

### Errores detectados:
```
Entrada: 3 4 + +
Salida: Error: Operador + requiere dos operandos

Entrada: 3 4 5 +
Salida: Error: expresión postfija inválida
```

## Ejemplos paso a paso

### Conversión de `3 4 + 5 *`:

| Paso | Token | Pila | Acción |
|------|-------|------|--------|
| 1 | `3` | `[3]` | Apilar número |
| 2 | `4` | `[3, 4]` | Apilar número |
| 3 | `+` | `[3 + 4]` | Crear expresión infija |
| 4 | `5` | `[3 + 4, 5]` | Apilar número |
| 5 | `*` | `[(3 + 4) * 5]` | Crear expresión con paréntesis |

**Resultado**: `(3 + 4) * 5`

### Conversión de `3 4 * 5 +`:

| Paso | Token | Pila | Acción |
|------|-------|------|--------|
| 1 | `3` | `[3]` | Apilar número |
| 2 | `4` | `[3, 4]` | Apilar número |
| 3 | `*` | `[3 * 4]` | Crear expresión infija |
| 4 | `5` | `[3 * 4, 5]` | Apilar número |
| 5 | `+` | `[3 * 4 + 5]` | Sin paréntesis (precedencia) |

**Resultado**: `3 * 4 + 5`

## Tecnologías utilizadas

- **Flex**: Generador de analizadores léxicos
- **Bison**: Generador de analizadores sintácticos
- **GCC**: Compilador de C
- **Make**: Sistema de construcción

## Manejo de memoria

- Asignación dinámica para expresiones de longitud variable
- Liberación automática de memoria al finalizar conversiones
- Limpieza de pila en caso de errores

## Limitaciones

- Solo números enteros positivos
- Máximo 100 elementos en la pila
- Expresiones de hasta 500 caracteres por resultado
- No soporta operadores unarios
- Sin funciones matemáticas

## Extensiones posibles

1. **Números decimales**: Soporte para punto flotante
2. **Números negativos**: Operador unario menos
3. **Funciones**: sin, cos, sqrt, log, etc.
4. **Variables**: Soporte para identificadores
5. **Optimización**: Eliminación de paréntesis redundantes adicionales
6. **Validación**: Verificación más robusta de expresiones

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
