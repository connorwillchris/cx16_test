; Build with: cl65 -o HELLO.BIN -t cx16 -C cart.cfg hello.asm
; Load in emulator with: x16emu -cartbin HELLO.BIN
; Run in emulator with: BANK 0,32:SYS$C000

; From x16-rom/inc/banks.inc:
jsrfar3    	= $02c4 ; jsrfar: RAM part
jmpfr      	= $02df ; jsrfar: core jmp instruction
imparm     	= $82   ; jsrfar: temporary byte

; From x16-rom/inc/io.inc

.include 	"../include/cx16.inc"
.include 	"../include/cbm_kernal.inc"

.CODE

; Header
.byte 	"cx16"

; Cartridge start - $c004
start:
	cli
    ldy 	#0

loop:
    lda 	msg, y
    beq 	exit
    jsr 	jsrfar

    .word 	CHROUT
    .byte 	$00

    iny
    bra 	loop

exit:
	; Infinite loop
    bra exit

msg:
    .byte 	"hello world",0

.include 	"./jsrfar.inc"
