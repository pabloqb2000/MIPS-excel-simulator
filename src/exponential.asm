; Compute e^x where x is the first number in memory, using Taylor series
; The second number in memory is used as the number of iterations to perform

; Load data
LW $0 $s0 0   ; x
LW $0 $s1 1   ; n
MOVE $0 $s2   ; result
MOVE $0 $s3   ; i

INC $s1
@LoopBegin
BEQ $s3 $s1 @LoopEnd

; Call power
MOVE $s0 $a0
MOVE $s3 $a1
JAL @power
MOVE $v0 $s4

; Call factorial
MOVE $s3 $a0
JAL @factorial
MOVE $v0 $s5

; Update value
DIV $s4 $s5 $s6
ADD $s2 $s6 $s2

INC $s3

J @LoopBegin
@LoopEnd

; Store result
SW $0 $s2 2

J @End


; Power function
@power
    LOADI $v0 1

    @LoopBegin1
    BEQ $a1 $0 @LoopEnd1

    MULT $a0 $v0 $v0
    DEC $a1

    J @LoopBegin1
    @LoopEnd1

    JR $ra


; Factorial function
@factorial
    LOADI $v0 1
    
    @LoopBegin2
    BEQ $a0 $0 @LoopEnd2

    MULT $a0 $v0 $v0
    DEC $a0

    J @LoopBegin2
    @LoopEnd2

    JR $ra


@End
