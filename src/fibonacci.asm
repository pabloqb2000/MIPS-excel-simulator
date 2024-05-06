; Compute the first N terms of the fibonacci secuence
; The first memory address should store the number of desired terms (N)
; The second and third memory addresses should store the initialization of the secuence (usually 1 and 1)

; Load data
LW $0 $t9 0
LW $0 $t0 1
LW $0 $t1 2
LOADI $t8 3

@LoopBegin
BEQ $t9 $0 @LoopEnd

; Update values
ADD $t1 $0 $t2
ADD $t0 $t1 $t1
ADD $t2 $0 $t0

; Store result
SW $t8 $t1 0

; Update counters
DEC $t9
INC $t8

J @LoopBegin
@LoopEnd
