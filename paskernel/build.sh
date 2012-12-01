#!/bin/bash
nasm -f elf prt0.asm

# change system.pp to syslinux.pp if you are compiling with fpc 1.0.10
fpc -n -Us -Fifrom_fpc/inc -Fifrom_fpc/i386 -Fifrom_fpc/objpas system.pp

fpc -n -Fifrom_fpc/inc -Fifrom_fpc/i386 -Fifrom_fpc/objpas -FE. from_fpc/objpas/objpas.pp
fpc -n -k-Ttext -k0x100000 kernel.pp
