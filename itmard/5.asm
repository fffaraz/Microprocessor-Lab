.include "m32def.inc"

.org 0x0000
	jmp main

main:
	;set stack pointer
	ldi r16, high(RAMEND)
	out sph, r16
	ldi r16, low(RAMEND)
	out spl, r16

	ldi	r16, 0x00
	out ddrc, r16

read_number:
	in r16, PINC ; number
	
	;set variables
	ldi r18, 0x00 ;hundreds
	ldi r19, 0x00 ;tens
	ldi r20, 0x00 ;ones
	

	ldi r17, 0x64 ; divisor
	call div
	mov r18, r22

	ldi r17, 0x0A; divisor
	call div
	mov r19, r22
	mov r20, r16

	ldi r30, '0'

	add r18, r30; convert ro ASCII
	add r19, r30
	add r20, r30

	;put them to lcd data and call lcd display


div:
	ldi r22, 0x00 ; remainder
	div_loop:
		cp r16, r17
		brlo end
		sub r16, r17
		inc r22
		jmp div_loop

end:
	ret
