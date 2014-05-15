.include"m32def.inc"
.def delaycnt=r20
.def temp1=r16
.def lcd_data=r17
.def temp2=r18
.def temp=r19
.equ lcd_port=portB
.def q=r21
.def n=r22
.def asci=r23
.equ en=2
.equ rs=0
.equ rw=1

.org 0x00
	rjmp reset
.org 0x30
reset:
	ldi temp1,low(ramend)
	out spl,temp1
	ldi temp1,high(ramend)
	out sph,temp1

	call lcd_init

	ldi lcd_data,0b10000000
	call lcd_cmd
	call delay
	ldi temp1,0x00
	out ddrc,temp1
	ldi q,0x00
	ldi asci,'0'
 	ldi n,0x00




loop:

	in r24,pinc
	cp r24,n
	breq loop
	mov n,r24

a1:
	cpi n,100
	brlo b1
	subi n,100
	inc q
	jmp a1
b1:
	ldi lcd_data,0b00000001
	call lcd_cmd
	call delay
	add q,asci
	mov lcd_data,q
	call lcd_disp
	call delay

	ldi q,0x00
a2:
	cpi n,10
	brlo b2
	subi n,10
	inc q
	jmp a2
b2:
	add q,asci
	mov lcd_data,q
	call lcd_disp
	call delay
	add n,asci
	mov lcd_data,n
	call lcd_disp
	call delay
    call delay
	call delay
	call delay
	call delay

	ldi q,0x00


	jmp loop




delay:
	ldi delaycnt,0x05
loop2:
	ldi zl,0xff
	ldi zh,0xff
lo:
	sbiw z,1
	brne lo
	dec delaycnt
	brne loop2
	ret



lcd_init:
	ldi temp1,0xf7
	out ddrb,temp1

	ldi lcd_data,0x20
	call lcd_cmd
	call delay

	ldi lcd_data,0x28
	call lcd_cmd
	call delay

	ldi lcd_data,0x28
	call lcd_cmd
	call delay

	ldi lcd_data,0x28
	call lcd_cmd
	call delay

	ldi lcd_data,0x01
	call lcd_cmd
	call delay

	ldi lcd_data,0x0c
	call lcd_cmd
	call delay

	ldi lcd_data,0x14
	call lcd_cmd
	call delay
	ret










lcd_cmd:
	mov temp,lcd_data
	andi temp,0xf0
	out lcd_port,temp
	sbi lcd_port,en
	nop
	nop
	nop
	cbi lcd_port,en

	mov temp,lcd_data
	andi temp,0x0f
	swap temp
	out lcd_port,temp
	sbi lcd_port,en
	nop
	nop
	nop
	cbi lcd_port,en
	ret





lcd_disp:
	mov temp,lcd_data
	andi temp,0xf0
	out lcd_port,temp
	sbi lcd_port,en
	sbi lcd_port,rs
	nop
	nop
	nop
	cbi lcd_port,en
	cbi lcd_port,rs

	mov temp,lcd_data
	andi temp,0x0f
	swap temp
	out lcd_port,temp
	sbi lcd_port,en
	sbi lcd_port,rs
	nop
	nop
	nop
	cbi lcd_port,en
	cbi lcd_port,rs
	ret
