// Calculate the factorial of the first number in memory
// The result is then stored in memory right after

// Load number
LW $0 $a0 0

// Call function
ADDI $0 $ra @here+2
J @factorial

// Store result
SW $0 $v0 1

J @End


// Factorial function
@factorial
    ADD $a0 $0 $v0
    ADDI $0 $t0 1

    @LoopBegin
    BEQ $a0 $t0 @LoopEnd

    SUBI $a0 $a0 1
    MULT $a0 $v0 $v0

    J @LoopBegin
    @LoopEnd

    JR $ra


@End
