.include "m32def.inc"

.org 0x0000
jmp maim
.org 0x0016
jmp timer0

main:
	;set stack pointer
	ldi r16, high(RAMEND)
	out sph, r16
	ldi r16, low(RAMEND)
	out spl, r16

	;portc output
	ldi r16, 0xFF
	out ddrc, r16

	;TCNT0 Timer counter register = 0
	ldi r16, 0x00
	out TCNT0, r16

	;TCCR0 prescaler = 1024
	ldi r16, 0x05
	out TCCR0, r16
	;TIMSK overflow interupt enabled
	ldi r16, 0x01
	out TIMSK, r16


	;set interupt enable
	sei

set:
	;couter for interupts
	ldi r17, 61

	ldi r18, 0x01
	out portc,r18

loop:
	;infnite loop
	jmp loop

timer0:
	dec r17
	brne goback
	lsl r18
	out portc, r18
	cmp r18, 0x80
	breq set

goback:
	reti
