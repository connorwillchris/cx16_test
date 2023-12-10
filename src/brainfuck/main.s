.include "../brainfuck/brainfuck.s"

.segment "CODE"
;-------------------------------------------------
;   MAIN ENTRY POINT
;-------------------------------------------------
start:
    lda     #<program_test
    sta     program_counter
    lda     #>program_test
    sta     program_counter + 1

    jsr     brainfuck
    rts
