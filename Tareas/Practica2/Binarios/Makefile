SRC     := src
BUILD   := build

CC      := gcc
BISON   := bison
FLEX    := flex
CFLAGS  := -I$(SRC) -Wall -Wextra
LDFLAGS := -lm

# Usa siempre rm -rf y mkdir -p
RM      := rm -rf $(BUILD)
MKDIR   := mkdir -p $(BUILD)

.DEFAULT_GOAL := all

all: $(BUILD)/binary_converter

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
$(BUILD)/binary_converter: $(BUILD)/parser.tab.c $(BUILD)/lex.yy.c $(SRC)/main.c | $(BUILD)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	$(RM)

test: $(BUILD)/binary_converter
	@echo "=== Pruebas del convertidor binario a decimal ==="
	@echo "Probando 101.101 (esperado: 5.625):"
	@echo "101.101" | ./$(BUILD)/binary_converter
	@echo ""
	@echo "Probando 1010 (esperado: 10.000):"
	@echo "1010" | ./$(BUILD)/binary_converter
	@echo ""
	@echo "Probando 11.11 (esperado: 3.750):"
	@echo "11.11" | ./$(BUILD)/binary_converter

.PHONY: all clean test
