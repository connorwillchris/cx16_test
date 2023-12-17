.include "../include/cx16.inc"
.include "../include/cbm_kernal.inc"
.include "./data.inc"

.segment "CODE"
;-------------------------------------------------
;   INTERPRETER
;-------------------------------------------------
brainfuck:                                              ; initialize all the tape cells and tape_ptr to zero
    stz     tape_ptr
    ldx     #0
@init:
    stz     tape, x
    inx
    bne     @init

    jmp     :+                                          ; jump to the loop without incrementing the program counter
;-------------------------------------------------
;   COMPARISONS
;-------------------------------------------------
loop:
    jsr     increment_pc                                ; increment the program counter (except on turn one)
:
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

    cmp     #0                                          ; go back to loop if we are not at the NULL character
    bne     loop

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
    lda     tape, x
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
    cmp     #0                                          ; jump to the end of the loop
    beq     @end
    lda     bracket_count
    cmp     #1                                          ; if it's less than 1, go to the end
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
    inc     program_counter
    bne     :+
    inc     program_counter + 1
:
    rts


decrement_pc:
    lda     program_counter
    bne     :+
    dec     program_counter + 1
:
    dec     program_counter
    rts

;-------------------------------------------------
;   INITIALIZE MEMORY TO ZERO
;-------------------------------------------------
;   TAPE_SIZE = 256
;...
;   tape:               .res    TAPE_SIZE
;...
;   lda #<tape
;   sta gREG::r0L
;   lda #>tape
;   sta gREG::r0H
;   lda #<TAPE_SIZE
;   sta gREG::r1L
;   lda #>TAPE_SIZE
;   sta gREG::r1H
;   lda #$00
;   jsr MEMORY_FILL
