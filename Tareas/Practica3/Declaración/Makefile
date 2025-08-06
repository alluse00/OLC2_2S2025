SRC     := src
BUILD   := build

CC      := gcc
BISON   := bison
FLEX    := flex
CFLAGS  := -I$(SRC) -Wall -Wextra

# Usa siempre rm -rf y mkdir -p
RM      := rm -rf $(BUILD)
MKDIR   := mkdir -p $(BUILD)

.DEFAULT_GOAL := all

all: $(BUILD)/declaration_parser

# 1) Crear carpeta build/
$(BUILD):
	$(MKDIR)

# 2) Generar parser
$(BUILD)/parser.tab.c $(BUILD)/parser.tab.h $(BUILD)/parser.output: \
    $(SRC)/parser.y | $(BUILD)
	$(BISON) -d -v --locations -o $@ $<

# 3) Generar lexer
$(BUILD)/lex.yy.c: $(SRC)/lexer.l $(BUILD)/parser.tab.h | $(BUILD)
	$(FLEX) -o $@ $<

# 4) Compilar ejecutable
$(BUILD)/declaration_parser: $(BUILD)/parser.tab.c $(BUILD)/lex.yy.c $(SRC)/main.c | $(BUILD)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM)

test: $(BUILD)/declaration_parser
	@echo "=== Pruebas del analizador de declaraciones ==="
	@echo "Probando: int x, y; char a; int b; (esperado: [(x,int), (y,int), (a,char), (b,int)])"
	@echo "int x, y; char a; int b;" | ./$(BUILD)/declaration_parser
	@echo ""
	@echo "Probando: float pi, e; int count, total; char ch;"
	@echo "float pi, e; int count, total; char ch;" | ./$(BUILD)/declaration_parser
	@echo ""
	@echo "Probando: double precision; char letter; float value;"
	@echo "double precision; char letter; float value;" | ./$(BUILD)/declaration_parser

.PHONY: all clean test
