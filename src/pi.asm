LW $0 $t9 0

ADD $0 $0 $t4
ADDI $0 $t1 4
ADDI $0 $t2 1

@LoopBegin
BEQ $t9 $0 @LoopEnd

DIV $t1 $t2 $t3
ADD $t4 $t3 $t4

MULTI $t1 $t1 -1
ADDI $t2 $t2 2

SUBI $t9 $t9 1

J @LoopBegin
@LoopEnd

SW $0 $t4 1
