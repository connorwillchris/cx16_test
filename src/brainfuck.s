.include "include/cx16.inc"
.include "include/cbm_kernal.inc"

.macpack longbranch

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "ZEROPAGE"
    program_counter:    .res    2                   ; 16-bit unsigned int
.segment "DATA"
    temporary_prg_1:
        .byte "+++++++++++++....", $00              ; output the NEWLINE character '\n'
    temporary_prg_2:
        .byte ">++++++++[<++++++++>-]<+.", $00      ; outputs the letter 'A'
    tape:               .res    256
    tape_ptr:           .byte   $00
.segment "CODE"

start:
    lda     #<temporary_prg_1
    sta     program_counter
    lda     #>temporary_prg_1
    sta     program_counter + 1

    jmp     brainfuck                               ; execute the brainfuck program

brainfuck:
    jmp     @loop
@increment:
    clc
    lda     program_counter                         ; increment the lower byte
    adc     #$01
    sta     program_counter

    lda     program_counter + 1                     ; add 0 to the upper byte, which adds the carry bit
    adc     #$00
    sta     program_counter + 1

@loop:
    lda     (program_counter)

    cmp     '>'
    beq     @t_bracket_L
    cmp     '<'
    beq     @t_bracket_R
    cmp     '+'
    beq     @t_plus
    cmp     '-'
    beq     @t_minus
    cmp     '.'
    beq     @t_period
    cmp     ','
    beq     @t_comma
    cmp     '['
    beq     @t_brace_L
    cmp     ']'
    beq     @t_brace_R

    cmp     $00
    bne     @increment
    rts

@t_bracket_L:
    jmp     @increment
@t_bracket_R:
    jmp     @increment
@t_plus:
    ldx     tape_ptr
    lda     tape, x
    inc
    sta     tape, x
    jmp     @increment

@t_minus:
    jmp     @increment
@t_period:
    ldx     tape_ptr
    lda     tape, x
    jsr     CHROUT
    jmp     @increment

@t_comma:
    jmp     @increment
@t_brace_L:
    jmp     @increment
@t_brace_R:
    jmp     @increment
