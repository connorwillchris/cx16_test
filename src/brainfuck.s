.include "include/cx16.inc"
.include "include/cbm_kernal.inc"

.macpack longbranch

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "ZEROPAGE"
    program_counter:    .res    2                   ; address of the program
;   jmp_buffer:         .res    2

.segment "DATA"
    temporary_prg_1:                                ; output the NEWLINE character '\n' (#$0D)
        .byte "+++++++++++++..", 0
    temporary_prg_2:                                ; outputs the letter 'A'
        .byte ">++++++++[<++++++++>-]<+.", 0
    tape:               .res    256
    tape_ptr:           .byte   0
    stack:              .res    256
    stack_ptr:          .byte   0

.segment "CODE"

start:
    lda     #<temporary_prg_2
    sta     program_counter
    lda     #>temporary_prg_2
    sta     program_counter + 1

    jsr     brainfuck                               ; execute the brainfuck program
    rts                                             ; exit the program

brainfuck:
    jmp     :+
loop:
    clc
    lda     program_counter                         ; increment the lower byte
    adc     #1
    sta     program_counter
    lda     program_counter + 1                     ; add 0 to the upper byte, which adds the carry bit
    adc     #0
    sta     program_counter + 1
:                                                   ; go once without increment
    lda     (program_counter)

    cmp     #'>'
    beq     t_bracket_L
    cmp     #'<'
    beq     t_bracket_R
    cmp     #'+'
    beq     t_plus
    cmp     #'-'
    beq     t_minus
    cmp     #'.'
    beq     t_period
    cmp     #','
    beq     t_comma
    cmp     #'['
    beq     t_brace_L
    cmp     #']'
    beq     t_brace_R

    cmp     #0
    bne     loop                                    ; go back to loop if we are not at the NULL character

    rts                                             ; exit the brainfuck program

t_bracket_L:
    lda     tape_ptr
    inc
    sta     tape_ptr
    jmp     loop

t_bracket_R:
    lda     tape_ptr
    inc
    sta     tape_ptr
    jmp     loop

t_plus:
    ldx     tape_ptr
    lda     tape, x
    inc
    sta     tape, x
    jmp     loop

t_minus:
    ldx     tape_ptr
    lda     tape, X
    dec
    sta     tape, x
    jmp     loop

t_period:                                           ; output to STDOUT
    ldx     tape_ptr
    lda     tape, x
    jsr     CHROUT             
    jmp     loop

t_comma:                                            ; input at STDIN
    ldx     tape_ptr
    lda     tape, x
    jsr     CHRIN
    ldx     tape_ptr                                ; load X with tape_ptr again, since X is modified
    sta     tape, x                                 ; store A into the value at [tape+x]
    jmp     loop

t_brace_L:                                          ; TODO
    ldx     tape_ptr
    lda     tape, x
    cmp     #0
    beq     @end                                    ; the loop ends. The right brace will have to check if the stack_ptr is zero.

    ldx     stack_ptr                               ; load the stack pointer
    lda     #<program_counter                       ; load the program counter LSB
    sta     stack, x                                ; store the program counter LSB in [stack+X]
    inx                                             ; X++
    lda     #>program_counter                       ; load the program counter MSB
    sta     stack, x                                ; store the program counter MSB in [stack+X+1]
    inx     

    stx     stack_ptr                               ; store the current stack pointer

@end:
    jmp     loop

t_brace_R:
    ldx     tape_ptr
    lda     tape, x
    cmp     #0
    beq     @end

    ldx     stack_ptr
    lda     stack, x
    sta     program_counter+1
    dex
    lda     stack, x
    sta     program_counter
    dex

    stx     stack_ptr

@end:
    jmp     loop
