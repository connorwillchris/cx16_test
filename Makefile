# ASSEMBLER
AS = cl65

# specific target flags
BF_FLAGS = -u __EXEHDR__

# FLAGS
TYPE_FLAGS = -t cx16
DEFAULT_CFG = -C cx16.cfg

AS_FLAGS = $(DEFAULT_CFG) $(TYPE_FLAGS)

# SOURCE AND BUILD DIRS
SRC_DIR = src
BLD_DIR = build

# targets

# brainfuck
BF_TARGET = BRAINFUCK.PRG
BF_SRC = $(SRC_DIR)/brainfuck/main.s

# cartridge
CART_CFG = -C src/cartridge/cart.cfg
CART_TARGET = CART.BIN
CART_SRC = $(SRC_DIR)/cartridge/main.s

all: $(BLD_DIR) cart brainfuck

# make the build directory
$(BLD_DIR):
	mkdir -p $(BLD_DIR)

cart: $(CART_SRC)
	$(AS) $(TYPE_FLAGS) $(CART_CFG) $(CART_SRC) -o $(BLD_DIR)/$(CART_TARGET)

# make a brainfuck executable
brainfuck: $(BF_SRC)
	$(AS) $(AS_FLAGS) $(BF_FLAGS) $(BF_SRC) -o $(BLD_DIR)/$(BF_TARGET)

# clean and run targets
.PHONY: clean runcart
# clean the directory and all object files
clean:
	rm -rf $(BLD_DIR) $(TARGET)
	rm -rf $(SRC_DIR)/*.o

runcart:
	x16emu -cartbin $(BLD_DIR)/$(CART_TARGET)
