; Clear registers and load data
MOVE $0 $1
MOVE $0 $2
MOVE $0 $3
LW $0 $1 0
LW $0 $2 1


; Test all R-Type operations
ADD $1 $2 $3
SW $0 $3 2

SUB $1 $2 $3
SW $0 $3 3

MULT $1 $2 $3
SW $0 $3 4

DIV $1 $2 $3
SW $0 $3 5

MOD $1 $2 $3
SW $0 $3 6

AND $1 $2 $3
SW $0 $3 7

OR $1 $2 $3
SW $0 $3 8

SLT $1 $2 $3
SW $0 $3 9


; Test all I-Type operations
ADDI $1 $3 -3
SW $0 $3 10

SUBI $1 $3 -3
SW $0 $3 11

MULTI $1 $3 -3
SW $0 $3 12

DIVI $1 $3 -3
SW $0 $3 13

MODI $1 $3 3
SW $0 $3 14

ANDI $1 $3 3
SW $0 $3 15

ORI $1 $3 3
SW $0 $3 16

SLTI $1 $3 -3
SW $0 $3 17


; Test jumps
LOADI $1 1
LOADI $2 -1

J @JumpSuccess
SW $0 $2 18 ; Error

@JumpSuccess
SW $0 $1 19 ; Success


; Test branches
LOADI $3 -19
LOADI $4 -19
LOADI $5 19

BEQ $3 $4 @BeqSuccess1
SW $0 $2 20 ; Error

@BeqSuccess1
SW $0 $1 21 ; Success

BEQ $3 $5 @BeqError1
SW $0 $1 22 ; Success

@BeqError1

ADDI $1 $ra @here+2
JR $ra
SW $0 $2 23 ; Error
SW $0 $1 24 ; Success


; Reset registers
MOVE $0 $1
MOVE $0 $2
MOVE $0 $3
MOVE $0 $4
MOVE $0 $5
MOVE $0 $ra

