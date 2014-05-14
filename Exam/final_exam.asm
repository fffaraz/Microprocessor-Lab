.INCLUDE "M32DEF.INC"

.DEF TEMP  = R16
.DEF TEMP1 = R27
.DEF TEMP2 = R28

.DEF CNT  = R16 // COUNTER

.DEF A0   = R17 // ADC 0
.DEF A1   = R18 // ADC 1
.DEF TL   = R19
.DEF TH   = R20
.DEF TS   = R21 // TIMER STATUS
.DEF MRL  = R22 // MODE RIGHT/LEFT
.DEF MNU  = R23 // MODE NUMBER
.DEF MSTA = R24 // STATE START
.DEF MEND = R25 // STATE END

.DEF LED  = R29

.equ lcd_port=PORTB
.equ en=2
.equ rs=0
.equ rw=1
.def lcd_data=r26


//VECTOR
.ORG 0
JMP RESET

.ORG 0x00E
JMP TIM1_COMPA

//MAIN
.ORG 0x32
RESET:

//STACK
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R16, HIGH(RAMEND)
OUT SPH, R16

//PORTC
SER TEMP1
OUT DDRC, TEMP1
CALL TEST

//LCD
call lcd_init
call delay


//TIMER1 SETUP
LDI TEMP1, 5 // CLK/1024
OUT TCCR1B, TEMP1
LDI TEMP1, 0b00010000
OUT TIMSK, TEMP1

//SEI
//LLL: JMP LLL;

CALL SET_TIME
CALL SET_MODE
MOV LED, MSTA
OUT PORTC, LED
CALL delay
SEI

LOOP:

//LCD
LDI lcd_data, 0b10000000
CALL LCD_CMD
CALL delay

LDI TEMP1, '0'
MOV lcd_data, MRL
ADD lcd_data, TEMP1
CALL LCD_DSP
CALL delay

LDI lcd_data, ' '
CALL LCD_DSP
CALL delay

LDI TEMP1, '0'
MOV lcd_data, MNU
ADD lcd_data, TEMP1
CALL LCD_DSP
CALL delay

; choose line 2
ldi lcd_data , 0xc0 
call lcd_cmd
call delay

LDI TEMP1, '0'
MOV lcd_data, TS
ADD lcd_data, TEMP1
CALL LCD_DSP
CALL delay

JMP LOOP


TIM1_COMPA:

// RESET TIMER
CLR TEMP2
OUT TCNT1L, TEMP2
OUT TCNT1H, TEMP2

CALL SET_TIME
CALL SET_MODE

// CHECK END
CP LED, MEND
BRNE NEXT_3
MOV LED, MSTA
RJMP NEXT_2

NEXT_3:

// SHIFT
CPI MRL, 1
BRNE NEXT_1
LSL LED

NEXT_1:
CPI MRL, 2
BRNE NEXT_2
LSR LED

NEXT_2:

CPI LED, 0
BRNE CONTINUE
MOV LED, MSTA
CONTINUE:

// OUTPUT
OUT PORTC, LED


RETI




SET_MODE:
// ADC0
LDI TEMP1,0b00100000
OUT ADMUX, TEMP1
// INIT
LDI TEMP1, 0b11000000
OUT ADCSRA, TEMP1
// WAIT
AND0WAIT:
IN TEMP1, ADCSRA
SBRS TEMP1, 4
RJMP AND0WAIT
// READ
IN A0, ADCH
// COMPARE
CPI A0, 50
BRSH MP2
LDI MRL, 1
LDI MNU, 2
LDI MSTA, 3
LDI MEND, 192
RJMP END_MODE

MP2:
CPI A0, 100
BRSH MP3
LDI MRL, 1
LDI MNU, 1
LDI MSTA, 1
LDI MEND, 128
RJMP END_MODE

MP3:
CPI A0, 150
BRSH MP4
LDI MRL, 0
LDI MNU, 0
LDI MSTA, 1
LDI MEND, 128
RJMP END_MODE

MP4:
CPI A0, 200
BRSH MP5
LDI MRL, 2
LDI MNU, 1
LDI MSTA, 128
LDI MEND, 1
RJMP END_MODE

MP5:
LDI MRL, 2
LDI MNU, 2
LDI MSTA, 192
LDI MEND, 3
// END
END_MODE:
RET



SET_TIME:

//15625 = 3D09
// x2   = 7A12
// x3   = B71B
// x4   = F424

// ADC1
LDI TEMP1,0b00100001
OUT ADMUX, TEMP1
// INIT
LDI TEMP1, 0b11000000
OUT ADCSRA, TEMP1
// WAIT
AND1WAIT:
IN TEMP1, ADCSRA
SBRS TEMP1, 4
RJMP AND1WAIT
// READ
IN A1, ADCH
// COMPARE
CPI A1, 64
BRSH PART2
LDI TL, 0x09
LDI TH, 0x3D
LDI TS, 1
RJMP END_SET

PART2:
CPI A1, 128
BRSH PART3
LDI TL, 0x12
LDI TH, 0x7A
LDI TS, 2
RJMP END_SET

PART3:
CPI A1, 192
BRSH PART4
LDI TL, 0x1B
LDI TH, 0xB7
LDI TS, 3
RJMP END_SET

PART4:
LDI TL, 0x1B
LDI TH, 0xB7
LDI TS, 4

// END
END_SET:
OUT OCR1AL, TL
OUT OCR1AH, TH
RET


DELAY:
LDI CNT, 0x03
LDI ZH, 0xFF
LDI ZL, 0xFF

FOR1:
	SBIW Z, 1
	BRNE FOR1

	LDI ZH, 0xFF
	LDI ZL, 0xFF
	DEC CNT
	BRNE FOR1
RET


TEST:

SER TEMP
OUT PORTC, TEMP
CALL DELAY

CLR TEMP
OUT PORTC, TEMP
CALL DELAY

SER TEMP
OUT PORTC, TEMP
CALL DELAY

CLR TEMP
OUT PORTC, TEMP
CALL DELAY


RET




LCD_CMD:
mov temp,lcd_data
andi temp,0xf0
; write high nibel in port
out lcd_port,temp
cbi lcd_port,rs
cbi lcd_port,rw
; change en from 1 to 0
sbi lcd_port,en 
cbi lcd_port,en
; write low nibel in port
mov temp,lcd_data
lsl temp
lsl temp
lsl temp
lsl temp
out lcd_port,temp
cbi lcd_port,rs
cbi lcd_port,rw
; change en from 1 to 0
sbi lcd_port,en
cbi lcd_port,en
ret

lcd_init:
ser temp 
out DDRB,temp
; 4line interface:
	ldi lcd_data,0b00101000
	out lcd_port,lcd_data
	cbi lcd_port,rs
	cbi lcd_port,rw
	sbi lcd_port,en
	cbi lcd_port,en
; 2line 
call lcd_cmd
call delay
; 5*7 dots display
call lcd_cmd
call delay
call lcd_cmd
call delay
; clear lcd:
ldi lcd_data,0x01
call lcd_cmd
call delay
; shift cursor to right:
ldi lcd_data, 0b00001100
call lcd_cmd
call delay
; turn on display/ cursor off:
ldi lcd_data,0b00000110
call lcd_cmd
call delay
ret

LCD_DSP:
mov temp,lcd_data
andi temp,0xf0
; write high nibel in port
out lcd_port,temp
sbi lcd_port,rs  // write at display
cbi lcd_port,rw
; change en from 1 to 0
sbi lcd_port,en 
cbi lcd_port,en
; write low nibel in port
mov temp,lcd_data
lsl temp
lsl temp
lsl temp
lsl temp
out lcd_port,temp
sbi lcd_port,rs  // write at display
cbi lcd_port,rw
; change en from 1 to 0
sbi lcd_port,en
cbi lcd_port,en
ret

