# Contador de Letras 'a' en Cadenas

Este proyecto implementa un analizador que cuenta cuántas veces aparece la letra 'a' en una cadena de caracteres compuesta por letras minúsculas (a–z). Utiliza técnicas de análisis léxico y sintáctico para procesar la entrada y generar el conteo correspondiente.

## Características

- Conteo automático de letras 'a' en cadenas de texto
- Soporte para letras minúsculas (a-z) únicamente
- Validación de entrada con detección de caracteres inválidos
- Interfaz interactiva de línea de comandos
- Procesamiento eficiente usando autómatas finitos
- Manejo de errores con ubicación precisa

## Ejemplos de uso

### Ejemplo básico:
```
Entrada: abracadabra
Salida: 5
```

### Ejemplo sin letras 'a':
```
Entrada: hello
Salida: 0
```

### Ejemplo con solo letras 'a':
```
Entrada: aaaaaa
Salida: 6
```

### Ejemplo con diferentes casos:
```
Entrada: banana
Salida: 3

Entrada: programming
Salida: 1

Entrada: xyz
Salida: 0
```

## Estructura del proyecto

```
├── Makefile          # Sistema de construcción
├── src/
│   ├── lexer.l       # Analizador léxico (Flex)
│   ├── parser.y      # Analizador sintáctico (Bison)
│   └── main.c        # Programa principal
└── build/            # Archivos generados
    ├── counter
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

### Ejecutar el contador:
```bash
./build/counter
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
program → program string '\n'
        | program '\n'
        | ε

string → string_content
       | ε

string_content → letters

letters → LETTER_A_TOKEN
        | LETTER_OTHER_TOKEN
        | letters LETTER_A_TOKEN
        | letters LETTER_OTHER_TOKEN
```

### Atributos sintetizados:

- **letters.count**: Acumula el número de letras 'a' encontradas
- **string.count**: Propaga el conteo final de la cadena
- **string_content.count**: Propaga el conteo del contenido

## Algoritmo de conteo

### Variables globales:
```c
int count_a = 0;  // Contador global de letras 'a'
```

### Proceso de conteo:

1. **Análisis léxico**: 
   - Reconoce letras 'a' como `LETTER_A_TOKEN`
   - Reconoce otras letras (b-z) como `LETTER_OTHER_TOKEN`
   
2. **Análisis sintáctico**:
   - Cada `LETTER_A_TOKEN` incrementa el contador global
   - Las demás letras se ignoran para el conteo
   - Al final de la cadena se reporta el resultado

3. **Conteo incremental**:
```c
letters: LETTER_A_TOKEN {
    count_a++;      // Incrementar contador
    $$ = 1;         // Contribución de esta regla
}
```

## Tokens reconocidos

- **LETTER_A_TOKEN**: La letra 'a' específicamente
- **LETTER_OTHER_TOKEN**: Cualquier letra de 'b' a 'z'
- **Newline**: Separador de cadenas ('\n')

## Validación de entrada

### Entrada válida:
- Cadenas compuestas únicamente por letras minúsculas (a-z)
- Espacios y tabs son ignorados
- Líneas vacías son permitidas

### Errores detectados:
```
Entrada: Abracadabra (mayúsculas)
Salida: Error léxico: carácter inválido 'A'

Entrada: abra123cadabra (números)
Salida: Error léxico: carácter inválido '1'

Entrada: abra@cadabra (símbolos)
Salida: Error léxico: carácter inválido '@'
```

## Ejemplo paso a paso

### Conteo de "abracadabra":

| Paso | Carácter | Token | Acción | Contador |
|------|----------|-------|--------|----------|
| 1 | 'a' | LETTER_A_TOKEN | count_a++ | 1 |
| 2 | 'b' | LETTER_OTHER_TOKEN | - | 1 |
| 3 | 'r' | LETTER_OTHER_TOKEN | - | 1 |
| 4 | 'a' | LETTER_A_TOKEN | count_a++ | 2 |
| 5 | 'c' | LETTER_OTHER_TOKEN | - | 2 |
| 6 | 'a' | LETTER_A_TOKEN | count_a++ | 3 |
| 7 | 'd' | LETTER_OTHER_TOKEN | - | 3 |
| 8 | 'a' | LETTER_A_TOKEN | count_a++ | 4 |
| 9 | 'b' | LETTER_OTHER_TOKEN | - | 4 |
| 10 | 'r' | LETTER_OTHER_TOKEN | - | 4 |
| 11 | 'a' | LETTER_A_TOKEN | count_a++ | 5 |

**Resultado final**: 5

## Características técnicas

### Análisis léxico:
- Reconocimiento eficiente usando expresiones regulares
- Separación clara entre letras 'a' y otras letras
- Detección automática de caracteres inválidos

### Análisis sintáctico:
- Gramática simple y eficiente
- Conteo en tiempo real durante el análisis
- Manejo de cadenas de longitud variable

### Manejo de memoria:
- Sin asignación dinámica de memoria
- Variables globales para conteo eficiente
- Gestión automática de tokens

## Complejidad

### Temporal:
- **O(n)** donde n es la longitud de la cadena
- Cada carácter se procesa exactamente una vez
- No hay backtracking ni recursión costosa

### Espacial:
- **O(1)** espacio adicional
- Solo se usa una variable para el contador
- Sin estructuras de datos auxiliares

## Tecnologías utilizadas

- **Flex**: Generador de analizadores léxicos
- **Bison**: Generador de analizadores sintácticos
- **GCC**: Compilador de C
- **Make**: Sistema de construcción

## Limitaciones

- Solo acepta letras minúsculas (a-z)
- No soporta caracteres especiales o acentos
- Una cadena por vez (no archivos múltiples)
- Sin soporte para caracteres Unicode
- No distingue entre mayúsculas y minúsculas automáticamente

## Extensiones posibles

1. **Mayúsculas y minúsculas**: Soporte para 'A' y 'a'
2. **Múltiples caracteres**: Contar cualquier carácter especificado
3. **Estadísticas completas**: Frecuencia de todas las letras
4. **Archivos**: Procesamiento de archivos de texto
5. **Patrones**: Búsqueda de subcadenas o patrones
6. **Unicode**: Soporte para caracteres internacionales

## Casos de prueba

### Casos básicos:
```bash
# Caso normal
echo "abracadabra" | ./build/counter  # Output: 5

# Sin letras 'a'
echo "hello" | ./build/counter        # Output: 0

# Solo letras 'a'
echo "aaaaaa" | ./build/counter       # Output: 6

# Cadena vacía
echo "" | ./build/counter             # Output: 0
```

### Casos límite:
```bash
# Una sola letra 'a'
echo "a" | ./build/counter            # Output: 1

# Una sola letra diferente
echo "z" | ./build/counter            # Output: 0

# Cadena muy larga
echo "$(printf 'a%.0s' {1..1000})" | ./build/counter  # Output: 1000
```

## Aplicaciones prácticas

### Análisis de texto:
- Estadísticas de frecuencia de caracteres
- Análisis de patrones en texto
- Validación de formato de datos

### Educación:
- Introducción a análisis léxico y sintáctico
- Ejemplo de gramáticas simples
- Demostración de autómatas finitos

### Preprocesamiento:
- Filtrado de texto
- Validación de entrada
- Conteo de caracteres específicos

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

## Comparación con otros enfoques

### Ventajas del analizador sintáctico:
- ✅ Validación automática de entrada
- ✅ Extensibilidad para gramáticas más complejas
- ✅ Manejo robusto de errores
- ✅ Separación clara entre léxico y sintáctico

### Alternativas más simples:
```c
// Enfoque directo en C
int count = 0;
for (int i = 0; str[i]; i++) {
    if (str[i] == 'a') count++;
}
```

### Justificación del enfoque:
- Demostración de técnicas de compilación
- Base para analizadores más complejos
- Práctica con herramientas Flex/Bison
- Estructura escalable y mantenible
