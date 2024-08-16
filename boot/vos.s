.align 2
.global _start
.section .text

.equ UART_BASE,		0x10000000
.equ UART_TX,		0
.equ UART_RX,		0
.equ UART_LSR,		0x5
.equ UART_FIFO_CTRL,	0x2

_start:
	csrr	t0, mhartid
	bnez	t0, nz_halt

	la	sp, stack_top

	la	t0, UART_BASE

	la	a0, debug_msg
	jal	puts

halt:
	lb	t2, UART_LSR(t0)
	andi	t2, t2, 0x1
	beqz	t2, halt

	lb	t1, UART_RX(t0)
	sb	t1, UART_TX(t0)

	li	t2, 0xD
	bne	t1, t2, skip_nl
	li	t2, 0xA
	sb	t2, UART_TX(t0)

skip_nl:

	j	halt

puts:
	la	t0, UART_BASE

1:	lb	t1, (a0)
	beqz	t1, 3f

2:	lb	t2, UART_TX(t0)
	bltz	t2, 2b
	sb	t1, UART_TX(t0)

	addi	a0, a0, 0x1

	j	1b

3:	ret

gets:
	la	t0, UART_BASE		/* t0 = UART_BASE */
	la	t1, con_buffer		/* t1 = con_buffer */

1:	lb	t2, UART_LSR(t0)	/* t2 = UART_LSR data */
	andi	t2, t2, 0x1		/* t2 = t2 & 0x1 (data ready bit) */
	beqz	t2, 1b			/* check over and over until UART confirms data has been sent (from previous call) */

	lb	t2, UART_RX(t0)		/* t2 = UART_RX data */
	sb	t2, UART_TX(t0)		/* UART_TX data = t2 (transmit RX byte) */

	la	t4, con_wptr		/* t4 = con_wptr */
	lb	t5, (t4)		/* t5 = con_wptr data */
	add	t4, t4, t5		/* t4 += t5 (con_wptr + offset) */
	sb	t2, (t4)		/* t4 = t2 (con_wptr+offset = RX data) */

	li	t3, 0xD			/* t3 = 0xD (\r carriage return) */
	bne	t2, t3, 1b		/* jump to beginning if RX data was not \r */
	li	t3, 0xA			/* t3 = 0xA (\n newline) */
	sb	t3, UART_TX(t0)		/* UART_TX data = t3 (transmit newline) */

	/* TODO handle enter return (newline), handle backspace */

nz_halt:
	j	nz_halt

.section .rodata
debug_msg: .string "Hi\n"
con_wptr: .byte 0x0
con_rptr: .byte 0x0
con_buffer: .byte 0x0

