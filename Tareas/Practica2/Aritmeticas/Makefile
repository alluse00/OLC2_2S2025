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

all: $(BUILD)/postfix_converter

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
$(BUILD)/postfix_converter: $(BUILD)/parser.tab.c $(BUILD)/lex.yy.c $(SRC)/main.c | $(BUILD)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM)

test: $(BUILD)/postfix_converter
	@echo "=== Pruebas del convertidor postfijo a infijo ==="
	@echo "Probando: 3 4 + 5 * (esperado: (3 + 4) * 5)"
	@echo "3 4 + 5 *" | ./$(BUILD)/postfix_converter
	@echo ""
	@echo "Probando: 2 3 + 4 5 + * (esperado: (2 + 3) * (4 + 5))"
	@echo "2 3 + 4 5 + *" | ./$(BUILD)/postfix_converter
	@echo ""
	@echo "Probando: 15 7 1 1 + - / 3 * 2 1 1 + + - (más complejo)"
	@echo "15 7 1 1 + - / 3 * 2 1 1 + + -" | ./$(BUILD)/postfix_converter

.PHONY: all clean test
