# Convertidor de Números Binarios a Decimal

Este proyecto implementa un analizador léxico y sintáctico que reconoce literales de números binarios con parte entera y fraccionaria, convirtiendo automáticamente su equivalente en base decimal.

## Características

- Reconoce números binarios con dígitos {0,1}
- Soporta parte entera y fraccionaria separadas por un punto (.)
- Realiza conversión automática a base decimal
- Manejo de errores léxicos y sintácticos
- Interfaz interactiva de línea de comandos

## Ejemplos de uso

```
Entrada: 101.101
Salida: = 5.625

Entrada: 1010
Salida: = 10.000

Entrada: 11.11
Salida: = 3.750
```

## Estructura del proyecto

```
├── Makefile          # Sistema de construcción
├── src/
│   ├── lexer.l       # Analizador léxico (Flex)
│   ├── parser.y      # Analizador sintáctico (Bison)
│   └── main.c        # Programa principal
└── build/            # Archivos generados
    ├── binary_converter
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
./build/binary_converter
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

El algoritmo implementa la conversión estándar de binario a decimal:

- **Parte entera**: Cada dígito binario se multiplica por 2^posición (de derecha a izquierda)
- **Parte fraccionaria**: Cada dígito binario se multiplica por 2^(-posición) (de izquierda a derecha después del punto)

### Ejemplo de conversión para 101.101:
```
Parte entera: 101₂
1×2² + 0×2¹ + 1×2⁰ = 4 + 0 + 1 = 5

Parte fraccionaria: .101₂
1×2⁻¹ + 0×2⁻² + 1×2⁻³ = 0.5 + 0 + 0.125 = 0.625

Resultado: 5 + 0.625 = 5.625
```

## Tecnologías utilizadas

- **Flex**: Generador de analizadores léxicos
- **Bison**: Generador de analizadores sintácticos
- **GCC**: Compilador de C
- **Make**: Sistema de construcción

## Requisitos

- GCC
- Flex
- Bison
- Make
- Librería matemática (libm)
