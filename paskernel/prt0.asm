;entry symbol, required by ld, to make an executable
		bits 32

		section .text
mb_magic:	dd 1BADB002h
mb_flags:	dd 2
mb_checksum:	dd 0-2-1BADB002h
		
		global _start
		extern PASCALMAIN
_start:		cli
		lgdt [gdt_limit]
		jmp 8:.next
.next:		mov ax, 010h
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		mov ss, ax
		mov esp, stack_end
		cld
		lidt [idt_limit]
		jmp PASCALMAIN

		align 4
irq0:
		iret

		section .data
		align 8
idt:		times 256*8 db 0 ; exceptions
idt_end:

		section .bss
		align 4
stack:		resd ((256*1024)/4)-1
stack_end:	resd 1

		section .data
idt_limit:	dw (idt_end - idt)-1
idt_base:	dd idt
		
gdt_limit:      dw (gdt_end - gdt)-1
gdt_base:       dd gdt
                align 8
gdt:            dd 0
                dd 0

                dw 0FFFFh ; 8 - code; dpl=0; base=0; limit=4g
                dw 0
                db 0
                db 10011010b
                db 11001111b
                db 0

                dw 0FFFFh ; 16 - data; dpl=0; base=0; limit=4g
                dw 0
                db 0
                db 10010010b
                db 11001111b
                db 0
gdt_end:
