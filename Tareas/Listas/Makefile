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

all: $(BUILD)/sequence_validator

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
$(BUILD)/sequence_validator: $(BUILD)/parser.tab.c $(BUILD)/lex.yy.c $(SRC)/main.c | $(BUILD)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM)

test: $(BUILD)/sequence_validator
	@echo "=== Pruebas del validador de secuencias alternadas ==="
	@echo "Probando secuencia válida: 1,A,2,b,3,Z"
	@echo "1,A,2,b,3,Z" | ./$(BUILD)/sequence_validator
	@echo ""
	@echo "Probando secuencia con error: 1,A,2,3,B"
	@echo "1,A,2,3,B" | ./$(BUILD)/sequence_validator
	@echo ""
	@echo "Probando secuencia que empieza con letra: A,1,B,2"
	@echo "A,1,B,2" | ./$(BUILD)/sequence_validator

.PHONY: all clean test
