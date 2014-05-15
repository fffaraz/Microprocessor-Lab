.include"m32def.inc"
.def delaycnt=r20
.def temp1=r16
.def lcd_data=r17
.def temp2=r18
.def temp=r19
.equ lcd_port=portB
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

	ldi lcd_data,'m'
	call lcd_disp
	call delay

	ldi lcd_data,'a'
	call lcd_disp
	call delay

	ldi lcd_data,'r'
	call lcd_disp
	call delay


	ldi lcd_data,0b11000000

	call lcd_cmd
	call delay

	ldi lcd_data,'a'
	call lcd_disp
x
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
