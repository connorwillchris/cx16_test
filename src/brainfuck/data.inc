.segment "ZEROPAGE"
    bracket_count:      .res    1
    tape_ptr:           .res    1
    program_counter:    .res    2
.segment "DATA"
    tape:               .res    256

    print_buffer:       .byte   "hello world!", 0

    ibf_start:          .byte   "ibf(", 0
    ibf_end:            .byte   ")", 0