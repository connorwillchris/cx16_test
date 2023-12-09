#!/usr/bin/python3

import os
import sys

CC = "cl65"

in_file = "src/brainfuck.s"
out_file = "build/BRAINFUCK.PRG"
name = "brainfuck"
emulator = "x16emu"

CC_FLAGS = f"-l build/{name}.list -C cx16-asm.cfg -u __EXEHDR__"
CC_TYPE = "-t cx16"

if not os.path.exists("build"):
    os.mkdir("build")

os.system(f"{CC} {CC_TYPE} {CC_FLAGS} -o {out_file} {in_file}")

# parse command line args
if len(sys.argv) == 2:
    if sys.argv[1] == "run":
        os.system(f"{emulator} -prg {out_file}")
