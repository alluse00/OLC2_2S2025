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

all: $(BUILD)/counter

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
$(BUILD)/counter: $(BUILD)/parser.tab.c $(BUILD)/lex.yy.c $(SRC)/main.c | $(BUILD)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM)

test: $(BUILD)/counter
	@echo "=== Pruebas del contador de letras 'a' ==="
	@echo "Probando: abracadabra (esperado: 5)"
	@echo "abracadabra" | ./$(BUILD)/counter
	@echo ""
	@echo "Probando: banana (esperado: 3)"
	@echo "banana" | ./$(BUILD)/counter
	@echo ""
	@echo "Probando: programming (esperado: 1)"
	@echo "programming" | ./$(BUILD)/counter
	@echo ""
	@echo "Probando: hello (esperado: 0)"
	@echo "hello" | ./$(BUILD)/counter
	@echo ""
	@echo "Probando: aaaaaa (esperado: 6)"
	@echo "aaaaaa" | ./$(BUILD)/counter

.PHONY: all clean test
