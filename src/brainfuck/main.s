.include "../brainfuck/brainfuck.s"

.segment "CODE"
;-------------------------------------------------
;   MAIN ENTRY POINT
;-------------------------------------------------
start:
program:
    jsr     print_str
    rts                                             ; END PROGRAM

print_str:
    ldy     #0
@loop:
    lda     print_buffer, y
    beq     @end
    jsr     CHROUT
	
    iny
    bra     @loop
@end:
    rts
