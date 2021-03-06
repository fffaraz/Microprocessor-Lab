.INCLUDE "M32DEF.INC"

.EQU LCDPORT = PORTB
.EQU LCDPORTDDR = DDRB
.EQU EN=2
.EQU RW=1
.EQU RS=0
.DEF LCDDATA = R31

.DEF Q = R20
.DEF N = R21
.DEF P = R22

.DEF D1 = R28
.DEF D2 = R29

.ORG 0
JMP RESET

.ORG 32
RESET:

LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R16, HIGH(RAMEND)
OUT SPH, R16


LOOP: 
CALL lcd_init
CALL delay

CLR R0
CLR R1
CLR R2

//IN N, PORTC
LDI N, 178

LDI P, 100
CALL divide
MOV R0, Q

LDI P, 10
CALL divide
MOV R1, Q

MOV R2, N

LDI R16, '0'
ADD R0, R16
ADD R1, R16
ADD R2, R16

MOV LCDDATA, R0
CALL lcd_data
CALL delay

MOV LCDDATA, R1
CALL lcd_data
CALL delay

MOV LCDDATA, R2
CALL lcd_data
CALL delay

CALL delay
CALL delay
CALL delay
JMP LOOP

divide:
CLR Q
devide_l1:
CP N, P
BRCS exit
SUB N, P
INC Q
JMP devide_l1

exit: RET



lcd_cmd: // lcd_cmd(LCDDATA)
// high
LDI R16, 0xF0
AND R16, LCDDATA
OUT LCDPORT, R16
// en
SBI LCDPORT, EN
NOP
NOP
NOP
CBI LCDPORT, EN
// low
LDI R16,0x0F
AND R16, LCDDATA
SWAP R16
OUT LCDPORT, R16
// en
SBI LCDPORT, EN
NOP
NOP
NOP
CBI LCDPORT, EN
// clear
LDI R16,0x00
OUT LCDPORT, R16

RET

lcd_data: // lcd_data(LCDDATA)
// high
LDI R16, 0xF0
AND R16, LCDDATA
OUT LCDPORT, R16
// rs
SBI LCDPORT, RS
// en
SBI LCDPORT, EN
NOP
NOP
NOP
CBI LCDPORT, EN

// low
LDI R16,0x0F
AND R16, LCDDATA
SWAP R16
OUT LCDPORT, R16
// rs
SBI LCDPORT, RS
// en
SBI LCDPORT, EN
NOP
NOP
NOP
CBI LCDPORT, EN
// clear
LDI R16,0x00
OUT LCDPORT, R16

RET

lcd_init:
// PORT
SER R16
OUT LCDPORTDDR, R16

LDI LCDDATA, 0b00101000
CALL lcd_cmd
CALL delay
LDI LCDDATA, 0b00000001
CALL lcd_cmd
CALL delay
LDI LCDDATA, 0b00001100
CALL lcd_cmd
CALL delay
LDI LCDDATA, 0b00000110
CALL lcd_cmd
CALL delay
//0x01 //0x06
RET

delay:
RET
LDI D1, 0xFE
delay_1:
LDI D2, 0xFE
delay_2:
NOP
NOP
NOP
NOP
NOP
DEC D2
BRNE delay_2
DEC D1
BRNE delay_1
RET
