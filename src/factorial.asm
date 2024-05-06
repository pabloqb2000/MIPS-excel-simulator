; Calculate the factorial of the first number in memory
; The result is then stored in memory right after

; Load number
LW $0 $a0 0

; Call function
JAL @factorial

; Store result
SW $0 $v0 1

J @End


; Factorial function
@factorial
    LOADI $v0 1
    
    @LoopBegin
    BEQ $a0 $0 @LoopEnd

    MULT $a0 $v0 $v0
    DEC $a0

    J @LoopBegin
    @LoopEnd

    JR $ra


@End
