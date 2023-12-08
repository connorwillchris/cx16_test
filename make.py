import os
import sys

in_file = "src/brainfuck/brainfuck.s"
out_file = "build/BRAINFUCK.PRG"
name = "brainfuck"

if not os.path.exists("build"):
    os.mkdir("build")

os.system(f"cl65 -t cx16 -o {out_file} -l build/{name}.list -C cx16-asm.cfg -u __EXEHDR__ {in_file}")

# parse command line args
if len(sys.argv) == 2:
    if sys.argv[1] == "run":
        os.system(f"x16emu -debug -prg {out_file}")
