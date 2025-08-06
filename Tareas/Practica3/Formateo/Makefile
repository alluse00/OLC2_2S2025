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

all: $(BUILD)/formatter

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
$(BUILD)/formatter: $(BUILD)/parser.tab.c $(BUILD)/lex.yy.c $(SRC)/main.c | $(BUILD)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM)

test: $(BUILD)/formatter
	@echo "=== Pruebas del formateador de código ==="
	@echo "Probando: print(a); if(a>0) then print(b); else print(c);"
	@echo "print(a); if(a>0) then print(b); else print(c);" | ./$(BUILD)/formatter
	@echo ""
	@echo "Probando: if(x>0) then if(y>0) then print(z); else print(w); else print(v);"
	@echo "if(x>0) then if(y>0) then print(z); else print(w); else print(v);" | ./$(BUILD)/formatter
	@echo ""
	@echo "Probando: print(start); if(a>b) then print(greater); print(end); else print(smaller); print(done);"
	@echo "print(start); if(a>b) then print(greater); print(end); else print(smaller); print(done);" | ./$(BUILD)/formatter

.PHONY: all clean test
