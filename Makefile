# makefile for 6502

AS = cl65
AS_FLAGS = -t cx16 -C cx16-asm.cfg -u __EXEHDR__

SRC_DIR = src
BLD_DIR = build
TARGET = BRAINFUCK.PRG

SOURCES = $(SRC_DIR)/brainfuck/main.s
LST_FILE = $(BLD_DIR)/brainfuck.list

all: $(BLD_DIR) $(TARGET)

# make the build directory
$(BLD_DIR):
	mkdir -p $(BLD_DIR)

# make PRG executable
$(TARGET): $(SOURCES)
	$(AS) $(AS_FLAGS) -l $(LST_FILE) $(SOURCES) -o $(BLD_DIR)/$(TARGET)

# make a clean and 
.PHONY: clean run
clean:
	rm -rf $(BLD_DIR) $(TARGET)
	rm -rf $(SRC_DIR)/*.o

run:
	box16 -prg $(BLD_DIR)/$(TARGET)
