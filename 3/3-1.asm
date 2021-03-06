.INCLUDE "M32DEF.INC"

.ORG 0
JMP RESET
.ORG 0x16
JMP ADCISR

.ORG 32

RESET:

LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R16, HIGH(RAMEND)
OUT SPH, R16

SER R16
OUT DDRC, R16

LDI 0b11101000
OUT ADCSRA. R16

LOOP: JMP LOOP

ADCISR:
IN R16, ADCL
IN R17, ADCH

		CPI R16, 51
		BRSH	L1
		OUT PORTC, 0B00000001
		JMP END

L1:
		CPI R16, 102
		BRSH	L2
		OUT PORTC, 0B00000011
		JMP END

L2:
		CPI R16, 153
		BRSH	L3
		OUT PORTC, 0B00000111
		JMP END
L3:
		CPI R16, 204
		BRSH	L4
		OUT PORTC, 0B00001111
		JMP END

L4:
		CPI R16, 255
		BRSH	L5
		OUT PORTC, 0B00011111
		JMP END

L5:
		OUT PORTC, 0B00111111

END:
	RETI
