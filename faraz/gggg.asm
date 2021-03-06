.INCLUDE "M32DEF.INC"
.DEF D1 = R30
.DEF D2 = R31
.DEF D3 = R29

.ORG 0
JMP RESET 


.ORG 32
RESET:

CLR R0


LDI R16,HIGH(RAMEND)
OUT SPH,R16
LDI R16,LOW(RAMEND)
OUT SPL, R16

CLR R27
LDI R26,0x80
LDI R16,0xFF
OUT DDRC,R16

LDI R16,0x01
ST X+, R16

LDI R16,0x02
ST X+, R16

LDI R16,0x04
ST X+, R16

LDI R16,0x08
ST X+, R16

LDI R16,0x10
ST X+, R16

LDI R16,0x20
ST X+, R16

LDI R16,0x40
ST X+, R16

LDI R16,0x80
ST X+, R16


LDI R17,0
CLR R27
LDI R26,0x80


LABEL :
	CPI R17, 8
	BRNE LOOP
	LDI R17,0
LOOP:
	CLR ZH
	CLR ZL

	MOV ZL, XL
	MOV ZH, XH
	
	ADD ZL, R17
	ADC ZH, R0
	//BRCC CONTINUE 
	//INC ZH
	//CONTINUE:
	 
	
	LD R18, Z
	OUT PORTC,R18
	CALL DELAY
	INC R17
	JMP LABEL


DELAY:
LDI D1, 0x10
delay_1:
LDI D2, 0xFF
delay_2:
LDI D3, 0xFF
delay_3:
NOP
DEC D3
BRNE delay_3
DEC D2
BRNE delay_2
DEC D1
BRNE delay_1
RET
