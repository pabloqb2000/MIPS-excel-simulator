; Load a seed from the first position in memoy
; The  return the next generated random number using a Linear Congruential Generator
LW $0 $a0 0
JAL @random_generator
SW $0 $v0 1
SW $0 $v1 2
J @End

@random_generator
    LOADI $t0 75       ; a = 75
    LOADI $t1 74       ; c = 74
    LOADI $t2 16384    ; 2**14
    MULTI $t2 $t2 4    ; 2**16
    INC $t2            ; m = 2**16 + 1 = 65537

    MULT $t0 $a0 $t0
    ADD $t0 $t1 $t0
    MOD $t0 $t2 $v0
    DIV $v0 $t2 $v1     

    JR $ra

@End
