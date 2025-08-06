# Analizador de Declaraciones de Variables

Este proyecto implementa un analizador sintáctico que procesa declaraciones de variables con sus tipos, utilizando **atributos heredados** para propagar el tipo a cada identificador. Al final de la evaluación, genera una lista de pares (ID, Type) que representa todas las declaraciones del bloque.

## Características

- Procesamiento de declaraciones de variables múltiples en una línea
- Soporte para tipos: `int`, `char`, `float`, `double`
- Propagación de tipos usando atributos heredados
- Validación sintáctica de declaraciones
- Generación de lista de pares (identificador, tipo)
- Manejo de errores con ubicación precisa
- Interfaz interactiva de línea de comandos

## Ejemplos de uso

### Ejemplo básico:
```
Entrada: int x, y; char a; int b;
Salida: [(x,int), (y,int), (a,char), (b,int)]
```

### Ejemplo con múltiples tipos:
```
Entrada: float pi, e; int count, total; char ch;
Salida: [(pi,float), (e,float), (count,int), (total,int), (ch,char)]
```

### Ejemplo con double:
```
Entrada: double precision; char letter; float value;
Salida: [(precision,double), (letter,char), (value,float)]
```

## Estructura del proyecto

```
├── Makefile          # Sistema de construcción
├── src/
│   ├── lexer.l       # Analizador léxico (Flex)
│   ├── parser.y      # Analizador sintáctico (Bison)
│   └── main.c        # Programa principal
└── build/            # Archivos generados
    ├── declaration_parser
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

### Ejecutar el analizador:
```bash
./build/declaration_parser
```

### Ejecutar pruebas automáticas:
```bash
make test
```

### Limpiar archivos generados:
```bash
make clean
```

## Gramática

### Gramática libre de contexto:

```
program → program declaration
        | program '\n'
        | ε

declaration → type identifier_list ';'

type → 'int' | 'char' | 'float' | 'double'

identifier_list → IDENTIFIER
                | identifier_list ',' IDENTIFIER
```

### Atributos heredados:

- **type.value**: El tipo se hereda desde la regla `declaration` hacia `identifier_list`
- **identifier_list.type**: Cada identificador en la lista recibe el tipo heredado

## Algoritmo de procesamiento

### Estructura de datos:
```c
typedef struct Declaration {
    char *identifier;  // Nombre del identificador
    char *type;        // Tipo de la variable
    struct Declaration *next;  // Siguiente en la lista
} Declaration;
```

### Proceso de análisis:

1. **Análisis léxico**: Reconoce tokens (tipos, identificadores, comas, punto y coma)
2. **Análisis sintáctico**: Construye el árbol de sintaxis usando la gramática
3. **Propagación de atributos**: El tipo se propaga a todos los identificadores
4. **Construcción de lista**: Se genera una lista de declaraciones
5. **Salida formateada**: Se imprime la lista en el formato requerido

### Atributos heredados en acción:

```
declaration → type identifier_list ';'
{
    // El tipo se hereda hacia identifier_list
    identifier_list.inherited_type = type.value;
}

identifier_list → IDENTIFIER
{
    // Se crea declaración con tipo heredado
    add_declaration(IDENTIFIER.value, inherited_type);
}

identifier_list → identifier_list ',' IDENTIFIER
{
    // El tipo se propaga a toda la lista
    add_declaration(IDENTIFIER.value, inherited_type);
}
```

## Tokens reconocidos

- **TYPE**: Palabras clave de tipos (`int`, `char`, `float`, `double`)
- **IDENTIFIER**: Identificadores válidos (letras, dígitos, guión bajo)
- **COMMA**: Separador de identificadores (`,`)
- **SEMICOLON**: Terminador de declaración (`;`)

## Validación de entrada

### Declaración válida:
- Debe comenzar con un tipo válido
- Los identificadores deben ser válidos (empezar con letra o `_`)
- Debe terminar con punto y coma
- Los identificadores se separan con comas

### Errores detectados:
```
Entrada: int 123invalid;
Salida: Error léxico: identificador inválido

Entrada: invalid_type x;
Salida: Error sintáctico: tipo no reconocido

Entrada: int x y;
Salida: Error sintáctico: falta coma entre identificadores
```

## Ejemplo paso a paso

### Procesamiento de `int x, y; char a;`:

| Paso | Token | Acción | Atributo heredado |
|------|-------|--------|-------------------|
| 1 | `int` | Reconocer tipo | type = "int" |
| 2 | `x` | Agregar identificador | (x, int) |
| 3 | `,` | Continuar lista | type = "int" |
| 4 | `y` | Agregar identificador | (y, int) |
| 5 | `;` | Finalizar declaración | - |
| 6 | `char` | Reconocer tipo | type = "char" |
| 7 | `a` | Agregar identificador | (a, char) |
| 8 | `;` | Finalizar declaración | - |

**Resultado**: `[(x,int), (y,int), (a,char)]`

## Características técnicas

### Atributos heredados:
- El tipo se propaga desde la regla padre hacia las reglas hijas
- Cada identificador recibe el tipo de su declaración
- La propagación es automática en el analizador sintáctico

### Manejo de memoria:
- Asignación dinámica para identificadores y tipos
- Lista enlazada para almacenar declaraciones
- Liberación automática al finalizar

### Manejo de errores:
- Errores léxicos con ubicación precisa
- Errores sintácticos con contexto
- Recuperación de errores para continuar análisis

## Tecnologías utilizadas

- **Flex**: Generador de analizadores léxicos
- **Bison**: Generador de analizadores sintácticos con soporte para atributos
- **GCC**: Compilador de C
- **Make**: Sistema de construcción

## Limitaciones

- Solo tipos básicos predefinidos
- Identificadores simples (sin arrays ni punteros)
- Una declaración por línea de comando
- Sin inicialización de variables
- Sin validación de identificadores duplicados

## Extensiones posibles

1. **Tipos complejos**: Arrays, punteros, estructuras
2. **Inicialización**: Soporte para valores iniciales
3. **Constantes**: Declaraciones con `const`
4. **Ámbitos**: Manejo de diferentes contextos
5. **Validación semántica**: Verificar identificadores duplicados
6. **Más tipos**: `bool`, `long`, tipos definidos por usuario

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
