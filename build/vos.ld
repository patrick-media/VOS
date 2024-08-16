SECTIONS {
	. = 0x80000000;
	.text : { bin/vos.o(.text) }
	.data : { bin/vos.o(.data) }
	.rodata : { bin/vos.o(.rodata) }
	. += 0x1000;
	stack_top = .;
}
