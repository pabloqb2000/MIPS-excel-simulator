; Calculate pi using montecarlo methods
; First number in memory is used as the number of iterations
; Second number in memory is used as random seed

LW $0 $s7 0     ; n
LW $0 $a0 1     ; s
LOADI $s6 0     ; n_points
MOVE $s7 $s0    ; i

@LoopBegin
BEQ $s0 $0 @LoopEnd

; Get fist random number
JAL @random_generator
MOVE $v1 $s1
MOVE $v0 $a0

; Get second random number
JAL @random_generator
MOVE $v1 $s2
MOVE $v0 $a0

; Compute norm of numbers
MULT $s1 $s1 $s1
MULT $s2 $s2 $s2
ADD $s1 $s2 $s3

; Check if point is inside the circle
SLTI $s3 $s4 1

; Increment the counter in case it is
BEQ $s4 $0 @here+2
INC $s6

DEC $s0

J @LoopBegin
@LoopEnd

; Get proportion of points inside the cirle
DIV $s6 $s7 $s6

; Pi is 4 times that
MULTI $s6 $s6 4

; Store result
SW $0 $s6 2

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
