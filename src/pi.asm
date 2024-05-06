; Calculate pi using Leibniz series
; First address in memory should have the desired number of iterations
; Result will be stored at the second address in memory

; Initialization
LW $0 $t9 0
MOVE $0 $t4
LOADI $t1 4
LOADI $t2 1

@LoopBegin
BEQ $t9 $0 @LoopEnd

; Update values
DIV $t1 $t2 $t3
ADD $t4 $t3 $t4

MULTI $t1 $t1 -1
ADDI $t2 $t2 2

; Decrease counter
DEC $t9

J @LoopBegin
@LoopEnd

; Store result
SW $0 $t4 1
