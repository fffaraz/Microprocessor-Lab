.include "M32DEF.INC"
.def reg1 = r16
.def reg2 = r17
.def reg3 = r18

.org 0x0000
jmp main

.org 0x0016
jmp timer

.org 0x0050

main:
	cli

	ldi reg1,high(ramend)
	out sph,reg1
	ldi reg2,low(ramend)
	out spl,reg1

	ldi reg1,0x01
	out timsk,reg1

	ldi reg1,96
	out tcnt0,reg1

	ldi reg1,0x05
	out tccr0,reg1
	ldi reg1,0xff
	out ddrc,reg1

	sei

	ldi reg2,0x01
	ldi reg3,100

	loop: rjmp loop
timer:
	ldi reg1,96
	out tcnt0,reg1

	dec reg3
	brne continue
	ldi reg3,100

	out portc,reg2
	clc
	rol reg2

	cpi reg2,0x00
	brne continue
	ldi reg2,0x01
	 continue:
	reti
	
