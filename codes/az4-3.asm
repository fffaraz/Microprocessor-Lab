.include"m32def.inc"
.def delaycnt=r20
.def temp1=r16
.def lcd-data=r17
.def temp2=r18
.def temp=r19
.equ lcd-port=portB
.equ en=2
.equ rs=0
.equ rw=1

.org 0x30
rjmp reset
reset:
ldi temp1,low(ramend)
out spl,temp1
ldi temp1,high(ramend)
out sph,temp1

call lcd-init
ldi lcd-data,0x80

call lcd-cmd
call delay

ldi lcd-data,'r'
call lcd-disp
call delay

ldi lcd-data,'s'
call lcd-disp
call delay

loop:
jmp loop




delay:
ldi delaycnt,0x05
loop2:
ldi zL,0xff
ldi zH,0xff
lo:
sbiw z
brne lo
dec delaycnt
brne loop2



lcd-init:
ldi temp1,0xf7
out ddrb,temp1

ldi lcd-data,0x20
call lcd-cmd
call delay

ldi lcd-data,0x28
call lcd-cmd
call delay

ldi lcd-data,0x28
call lcd-cmd
call delay

ldi lcd-data,0x28
call lcd-cmd
call delay

ldi lcd-data,0x01
call lcd-cmd
call delay

ldi lcd-data,0x0c
call lcd-cmd
call delay

ldi lcd-data,0x14
call lcd-cmd
call delay










lcd-cmd:
mov temp,lcd-data
andi temp,0xf0
out lcd-port,temp
sbi lcd-port,en
nop
nop
nop
cbi lcd-port,en

mov temp,lcd-data
andi temp,0x0f
swap temp
out lcd-port,temp
sbi lcd-port,en
nop
nop
nop
cbi lcd-port,en
ret





lcd-disp:
mov temp,lcd-data
andi temp,0xf0
out lcd-port,temp
sbi lcd-port,en
sbi lcd-port,rs
nop
nop
nop
cbi lcd-port,en
cbi lcd-port,rs

mov temp,lcd-data
andi temp,0x0f
swap temp
out lcd-port,temp
sbi lcd-port,en
sbi lcd-port,rs
nop
nop
nop
cbi lcd-port,en

