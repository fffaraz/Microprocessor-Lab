.include "m32def.inc"
.def temp=r16
.def temp1=r17
.def temp2=r18
.org 0x00
rjmp main

.org 0x30
main:
	ldi temp,high(ramend)
	out sph,temp
	ldi temp,low(ramend)
	out spl,temp
	ldi temp,0xff
	out ddrc,temp
	ldi temp,0x20
	out admux,temp
	ldi temp,0x8f
	out adcsra,temp
l0:
	in temp,adcsra
	ldi temp1,0x40
	or temp,temp1
	out adcsra,temp
l1:
	in temp,adcsra
	ldi temp1,0x10
	and temp,temp1
	cpi temp,0
	breq l1
	call decode
	out portc,temp2
	jmp l0

decode:
	in temp,adch
	cpi temp,51
	brsh next0
	ldi temp2,0b00000001
	jmp exit

next0:
	cpi temp,102
	brsh next1
	ldi temp2,0b00000011
	jmp exit

next1:
	cpi temp,153
	brsh next2
	ldi temp2,0b00000111
	jmp exit

next2:
	cpi temp,204
	brsh next3
	ldi temp2,0b00001111
	jmp exit
next3:
	cpi temp,255
	brsh next4
	ldi temp2,0b00011111
	jmp exit
next4:
 	ldi temp2,0b00111111

exit:
	ret
