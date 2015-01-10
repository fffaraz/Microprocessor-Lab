.include "m32def.inc"

.org 0x0000
	jmp main

main:
	;set stack pointer
	ldi r16, high(RAMEND)
	out sph, r16
	ldi r16, low(RAMEND)

	;define port c as output
	ldi r16, 0xff
	out ddrc , r16

set:
	;turn first LED on
	ldi r16, 0x01
	out portc, r16

delay:
	;set values for delay 
	ldi r17, 0xff
	ldi r18, 0xff
	ldi r20, 0xff

counter:
	;loop for delay > r20{r18{r17}}
	dec r17
	cmp r17, 0x00
	brne counter
	dec r18
	cmp r18, 0x00
	brne counter
	dec r20
	cmp r20, 0x00
	brne counter

shift:
	cpi r16, 0x80
	breq set
	lsl r16
	out portc, r16
	jmp delay
