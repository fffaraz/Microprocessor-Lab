.include "m32def.inc"
.def temp1=r17
.def count=r18
.def delaycount=r19
.org 0x30
	rjmp main 
main:
	ldi r16,low(ramend)
	out spl, r16
	ldi r16,high(ramend)
	out sph, r16
	ldi r16,0xff
	out ddrc,r16
	ldi r16,0x33
	out portc,r16



