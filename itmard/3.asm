.include "m32def.inc"

.org 0x0000
	jmp main

main:
	;stack pointer
	ldi r16, high(RAMEND)
	out sph, r16
	ldi r16, low(RAMEND)
	out spl, r16

	;portc output
	ldi r16, 0xFF
	out ddrc, r16

	;Config adc
	;ADMUX source is AREF and ADLAR = 1 and high is important and mux is 000 ADC0
	ldi r16, 0x20
	out ADMUX, r16

	;ADCSRA adc enable =1 adc start =1  and presclare 111 > 128 
	ldi r16, 0xC7
	out ADCSRA, r16

check_status:
	;infnite loop
	in r16, ADCSRA
	cmp r16, 0xC7
	brne reset_status
	call read_adc
	jmp check_status

reset_status:
	ldi, r16, 0xC7
	out ADCSRA, r16
	jmp check_status

read_adc:
	in r16, ADCH
	call binary_number
	out portc, r16
	ret

binary_number:
	cmp r16, 0x33
	brlo set_led_one
	
	cmp r16, 0x66
	brlo set_led_two
	
	cmp r16, 0x99
	brlo set_led_three

	cmp r16, 0xCC
	brlo set_led_four

	cmp r16, 0xFF
	brlo set_led_five

	jmp set_led_six



set_led_one
	ldi r16, 0x01
	ret

set_led_two
	ldi r16, 0x02
	ret

set_led_one
	ldi r16, 0x04
	ret

set_led_one
	ldi r16, 0x08
	ret

set_led_one
	ldi r16, 0x10
	ret
