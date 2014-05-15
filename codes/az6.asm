.include"m32def.inc"
.def temp1=r20
.def count=r16
.def delaycount=r19
.org 0x00
	jmp main
.org 0x0030
.dseg
lut:
      //.byte8
.cseg
main:
	ldi r17,low(ramend)
	out spl,r17
	ldi r17,high(ramend)
	out sph,r17
	ldi temp1,0xff
	out ddrc,temp1
	ldi count,0x00
	ldi zl,low(lut)
	ldi zh,high(lut)
	ldi temp1,0x01
loop1:
	cpi count,8
	brsh loop2
	st z+,temp1
	inc count
	lsl temp1
	jmp loop1

loop2:
	ldi count,0x00

	ldi zl,low(lut)
	ldi zh,high(lut)
next:
	ld temp1,z+
	out portc,temp1
	inc count
	cpi count,8
	brne next1
	ldi count,0x00
	ldi zl,low(lut)
	ldi zh,high(lut)
next1:
	call delay
	jmp next

delay:
	ldi delaycount,0xff
loop3:
	ldi xl,0xff
	ldi xh,0xff
loop4:
	sbiw x,1
	brne loop4
	dec delaycount
	brne loop3
	ret
