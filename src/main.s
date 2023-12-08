.include "include/cx16.inc"
.include "include/cbm_kernal.inc"

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "ZEROPAGE"
    p_buffer:       .res 2
.segment "DATA"
    hello_world:    .byte "hello world!", $00
.segment "CODE"

start:
    lda     #<hello_world
    sta     p_buffer
    lda     #>hello_world
    sta     p_buffer + 1

    jsr     print_str                               ; prints what's in the `p_buffer` pointer
    rts                                             ; exit program

print_str:                                          ; print a string subroutine
    ldy     #$00
@loop:
    lda     (p_buffer),y
    cmp     #$00
    beq     @end
    jsr     CHROUT
    iny
    jmp     @loop
@end:
    rts
