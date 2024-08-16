SYS_OBJ = bin/vos.o

run: all
	qemu-system-riscv64 -machine virt -bios vos.elf

all: $(SYS_OBJ)
	riscv64-unknown-elf-ld $(SYS_OBJ) -T build/vos.ld -o vos.elf --oformat elf64-littleriscv

bin/%.o: */%.s
	riscv64-unknown-elf-as -march=rv64i -mabi=lp64 -o $@ -c $^
