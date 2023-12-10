.include "../include/cx16.inc"
.include "../include/cbm_kernal.inc"

.segment "ZEROPAGE"
.segment "DATA"
    print_buffer:               .res 80
.segment "CODE"

start:
    rts
