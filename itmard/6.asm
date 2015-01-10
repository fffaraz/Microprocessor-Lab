.include "m32def.inc"

.dseg
	.org 0x0060
		LUT:
			.BYTE 8

.cseg
	.org 0x0000
		jmp main

main:
	;stack pointer
	ldi r16, high(RAMEND)
	out sph, r16
	ldi r16, low(RAMEND)
	out spl, r16

	;portc output
	ldi r16, 0xFF
	out ddrc, r16

	;create couter for lut
	call set_y_pointer

	;load data to lut
	ldi r16, 0x01
	ST Y+, r16

	ldi r16, 0x02
	ST Y+, r16

	ldi r16, 0x04
	ST Y+, r16

	ldi r16, 0x08
	ST Y+, r16

	ldi r16, 0x10
	ST Y+, r16

	ldi r16, 0x20
	ST Y+, r16

	ldi r16, 0x40
	ST Y+, r16

	ldi r16, 0x80
	ST Y+, r16

	;set Y pointer again
	set_y_pointer

	ldi r17, 0x00 ; read counter

set_leds:
	LD r16, Y+
	out portc, r16
	
	inc r17
	cp r17, 0x08
	brne set_leds
	
	ldi r17, 0x00

	set_y_pointer
	jmp set_leds

set_y_pointer:
	ldi YL, low(LUT)
	ldi YH, high(LUT)
	ret




















