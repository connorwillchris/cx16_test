.include "include/cx16.inc"
.include "include/cbm_kernal.inc"

.macpack longbranch

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "ZEROPAGE"
    program_counter:    .res    2                       ; address of the program
    tape_ptr:           .byte   0
    bracket_count:      .res    1

.segment "DATA"
    temporary_prg_1:                                    ; output the NEWLINE character '\n' (#$0D)
        .byte "+++++++++++++..", 0
    temporary_prg_2:                                    ; outputs the letter 'A'
        .byte ">++++++++[<++++++++>-]<+...", 0
    tape:               .res    256

.segment "CODE"

start:
    lda     #<temporary_prg_2
    sta     program_counter
    lda     #>temporary_prg_2
    sta     program_counter + 1

    jsr     brainfuck                                   ; execute the brainfuck program
    rts                                                 ; exit the program

;-------------------------------------------------
;   INTERPRETER
;-------------------------------------------------
brainfuck:
    jmp     :+
;-------------------------------------------------
;   COMPARISONS
;-------------------------------------------------
loop:
    jsr     increment_pc
:                                                       ; go once without increment
    lda     (program_counter)

    cmp     #'>'
    beq     t_brace_L
    cmp     #'<'
    beq     t_brace_R
    cmp     #'+'
    beq     t_plus
    cmp     #'-'
    beq     t_minus
    cmp     #'.'
    beq     t_period
    cmp     #','
    beq     t_comma
    cmp     #'['
    beq     t_bracket_L
    cmp     #']'
    beq     t_bracket_R

    cmp     #0
    bne     loop                                        ; go back to increment_pc if we are not at the NULL character

    rts                                                 ; exit the brainfuck program
;-------------------------------------------------
;   TOKEN FUNCTIONALITY
;-------------------------------------------------
t_brace_L:
    lda     tape_ptr
    inc
    sta     tape_ptr
    jmp     loop

t_brace_R:
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

t_period:                                               ; output to STDOUT
    ldx     tape_ptr
    lda     tape, x
    jsr     CHROUT             
    jmp     loop

t_comma:                                                ; input at STDIN
    ldx     tape_ptr
    lda     tape, x
    jsr     CHRIN
    ldx     tape_ptr                                    ; load X with tape_ptr again, since X is modified
    sta     tape, x                                     ; store A into the value at [tape+x]
    jmp     loop

t_bracket_L:                                            ; TODO
    ldx     tape_ptr
    lda     tape, x
    cmp     #0
    beq     @end                                        ; the increment_pc ends. The right brace will have to check if the stack_ptr is zero.
    lda     bracket_count
    inc
    sta     bracket_count
@end:
    jmp     loop

t_bracket_R:
    ldx     tape_ptr
    lda     tape, x
    cmp     #0
    beq     @end
    lda     bracket_count
    cmp     #1
    bcs     @loop
@loop:
    jsr     decrement_pc
    lda     (program_counter)
    cmp     #'['
    bne     @loop
@end:
    lda     bracket_count
    dec 
    sta     bracket_count
    jmp     loop

;-------------------------------------------------
;   INCREMENT AND DECREMENT PC
;-------------------------------------------------
increment_pc:
    clc
    lda     program_counter                             ; increment the lower byte
    adc     #1
    sta     program_counter
    lda     program_counter+1                           ; add 0 to the upper byte, which adds the carry bit
    adc     #0
    sta     program_counter+1
    rts

decrement_pc:
    sec     
    lda     program_counter
    sbc     #1
    sta     program_counter
    lda     program_counter+1
    sbc     #0
    sta     program_counter+1
    rts

;   FOR LEFT BRACKET
;   int a = 1;
;   while (a > 1) {
;       pc++;
;       if (*pc == '[') a++;
;       if (*pc == ']') a--;
;   }

;   FOR RIGHT BRACKET
;   while (a > 1) {
;       pc--;
;       if (*pc == '[') a--;
;       if (*pc == ']') a++;
;   }
