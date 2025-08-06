# Formateador de Código con Indentación

Este proyecto implementa un formateador de código que procesa programas compuestos por secuencias de sentencias `print` e instrucciones condicionales `if...then...else`, añadiendo espacios al inicio de cada línea según el nivel de anidación. El nivel de indentación se incrementa en 1 unidad cada vez que se entra al bloque `then` o al bloque `else`.

## Características

- Formateo automático de código con indentación apropiada
- Soporte para sentencias `print(expresión)`
- Soporte para estructuras condicionales `if(condición) then ... else ...`
- Manejo de anidación múltiple de estructuras de control
- Indentación con 4 espacios por nivel
- Operadores de comparación: `>`, `<`, `=`, `>=`, `<=`, `==`, `!=`
- Validación sintáctica del código de entrada

## Ejemplos de uso

### Ejemplo básico:
```
Entrada: print(a); if(a>0) then print(b); else print(c);
Salida:
print(a);
if(a>0) then
    print(b);
else
    print(c);
```

### Ejemplo con anidación:
```
Entrada: if(x>0) then if(y>0) then print(z); else print(w); else print(v);
Salida:
if(x>0) then
    if(y>0) then
        print(z);
    else
        print(w);
else
    print(v);
```

### Ejemplo con múltiples sentencias:
```
Entrada: print(start); if(a>b) then print(greater); print(end); else print(smaller); print(done);
Salida:
print(start);
if(a>b) then
    print(greater);
    print(end);
else
    print(smaller);
    print(done);
```

## Estructura del proyecto

```
├── Makefile          # Sistema de construcción
├── src/
│   ├── lexer.l       # Analizador léxico (Flex)
│   ├── parser.y      # Analizador sintáctico (Bison)
│   └── main.c        # Programa principal
└── build/            # Archivos generados
    ├── formatter
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

### Ejecutar el formateador:
```bash
./build/formatter
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
program → program statement_sequence '\n'
        | program '\n'
        | ε

statement_sequence → statement
                   | statement_sequence statement

statement → print_statement
          | if_statement

print_statement → 'print' '(' expression ')' ';'

if_statement → 'if' '(' condition ')' 'then' statement_sequence 'else' statement_sequence

condition → expression comparison_op expression
          | expression

comparison_op → '>' | '<' | '=' | '>=' | '<=' | '==' | '!='

expression → IDENTIFIER | NUMBER
```

### Atributos sintetizados:

- **condition.value**: Contiene la condición formateada como string
- **expression.value**: Contiene el valor de la expresión como string
- **comparison_op.value**: Contiene el operador de comparación como string

## Algoritmo de formateo

### Variables globales:
```c
int indent_level = 0;  // Nivel actual de indentación
```

### Funciones de indentación:
```c
void print_indent();    // Imprime espacios según el nivel actual
void increase_indent(); // Incrementa el nivel de indentación
void decrease_indent(); // Decrementa el nivel de indentación
```

### Proceso de formateo:

1. **Sentencias print**: Se imprimen con la indentación actual
2. **Estructuras if-then-else**:
   - Se imprime `if(condición) then` con indentación actual
   - Se incrementa la indentación para el bloque `then`
   - Se procesan las sentencias del bloque `then`
   - Se decrementa la indentación y se imprime `else`
   - Se incrementa la indentación para el bloque `else`
   - Se procesan las sentencias del bloque `else`
   - Se decrementa la indentación al final

### Reglas de indentación:

- **Nivel 0**: Sin indentación (código principal)
- **Nivel 1**: 4 espacios (primer nivel de anidación)
- **Nivel 2**: 8 espacios (segundo nivel de anidación)
- **Nivel n**: n * 4 espacios

## Tokens reconocidos

- **PRINT**: Palabra clave `print`
- **IF**: Palabra clave `if`
- **THEN**: Palabra clave `then`
- **ELSE**: Palabra clave `else`
- **IDENTIFIER**: Identificadores (variables)
- **NUMBER**: Números enteros
- **LPAREN**: Paréntesis izquierdo `(`
- **RPAREN**: Paréntesis derecho `)`
- **SEMICOLON**: Punto y coma `;`
- **GT, LT, EQ, GTE, LTE, EQUAL, NOTEQUAL**: Operadores de comparación

## Validación de entrada

### Código válido:
- Las sentencias print deben tener la forma `print(expresión);`
- Las estructuras if deben tener la forma `if(condición) then ... else ...`
- Los identificadores deben comenzar con letra o guión bajo
- Las expresiones pueden ser identificadores o números

### Errores detectados:
```
Entrada: print(x
Salida: Error sintáctico: se esperaba ')'

Entrada: if x>0 then print(y);
Salida: Error sintáctico: se esperaba '('

Entrada: if(x>0) then print(y);
Salida: Error sintáctico: falta 'else'
```

## Ejemplo paso a paso

### Formateo de `print(a); if(a>0) then print(b); else print(c);`:

| Paso | Token/Acción | Nivel | Salida |
|------|--------------|-------|--------|
| 1 | `print(a);` | 0 | `print(a);` |
| 2 | `if(a>0) then` | 0 | `if(a>0) then` |
| 3 | Incrementar nivel | 1 | - |
| 4 | `print(b);` | 1 | `    print(b);` |
| 5 | Decrementar nivel | 0 | - |
| 6 | `else` | 0 | `else` |
| 7 | Incrementar nivel | 1 | - |
| 8 | `print(c);` | 1 | `    print(c);` |
| 9 | Decrementar nivel | 0 | - |

**Resultado final**:
```
print(a);
if(a>0) then
    print(b);
else
    print(c);
```

## Características técnicas

### Manejo de indentación:
- Cada nivel de anidación añade 4 espacios
- La indentación se gestiona automáticamente durante el análisis sintáctico
- Se garantiza la correcta alineación de bloques `then` y `else`

### Manejo de memoria:
- Asignación dinámica para strings de condiciones y expresiones
- Liberación automática de memoria después del procesamiento
- Gestión eficiente de cadenas de caracteres

### Análisis sintáctico:
- Gramática LL(1) con conflictos shift/reduce resueltos
- Precedencia implícita en las reglas gramaticales
- Recuperación de errores básica

## Tecnologías utilizadas

- **Flex**: Generador de analizadores léxicos
- **Bison**: Generador de analizadores sintácticos
- **GCC**: Compilador de C
- **Make**: Sistema de construcción

## Limitaciones

- Solo soporta estructuras `if-then-else` completas (no `if` sin `else`)
- Expresiones simples (identificadores y números únicamente)
- Sin soporte para operadores aritméticos en condiciones complejas
- Sin soporte para bloques de sentencias con llaves `{}`
- Una secuencia de sentencias por entrada

## Extensiones posibles

1. **Bloques con llaves**: Soporte para `{ sentencia1; sentencia2; }`
2. **If sin else**: Soporte para `if` condicionales sin rama `else`
3. **Bucles**: Añadir `while` y `for`
4. **Expresiones complejas**: Operadores aritméticos y lógicos
5. **Funciones**: Definición y llamada de funciones
6. **Comentarios**: Preservar comentarios en el código formateado
7. **Configuración**: Nivel de indentación personalizable

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

## Casos de uso

### Desarrollo de software:
- Formateo automático de código pseudocódigo
- Herramienta educativa para enseñar estructuras de control
- Preprocesador para lenguajes de programación simples

### Análisis de código:
- Visualización de la estructura lógica del código
- Detección de niveles de anidación excesivos
- Análisis de complejidad estructural

### Documentación:
- Generación de código formateado para documentación
- Presentación clara de algoritmos
- Ejemplos didácticos en materiales educativos
