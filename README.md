## VOS
VOS (RISC-**V** **O**perating **S**ystem) is an "operating system" designed for QEMU's RISC-V "virt" machine. It may not do much, but it is mostly a proof-of-concept and practice in something closer to embedded systems than what I have previously looked into

## Build & Run
Required packages (Debian/Ubuntu):
```
build-essential
make
qemu
gcc-riscv64-unknown-elf
qemu-system-misc
```

The following is a list of rules in the Makefile:
```
# Compile and link all source files into vos.elf
make all
# Executes 'all' and opens an instance of qemu-system-riscv64 with the '-bios' flag pointing to vos.elf
make run
```

Adding files to the compile list is as easy as editing `SYS_OBJ` at the top of the Makefile, ensuring the file's exact location is specified in the list (e.g. `bin/example.o`).
