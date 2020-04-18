.data
grid: .word 0:9
charGrid: .byte ' ':9
turn: .word 0

StartMessage: .asciiz "player 1, pick 3 for x, or 4 for y\n"
StalemateMessage: .asciiz "it's a stalemate!\n"
EnterCoordsMessage: .asciiz "enter x coords\n"
EnterCoordsMessage2: .asciiz "enter y coords\n"
SpotNotEmptyMessage: .asciiz "spot not empty\n"


newline: .asciiz "\n"
gridline: .asciiz "|"

.text

preGame:
    li $t0,0#turn

    #prompt the user for input
	li $v0, 4
	la $a0, StartMessage
	syscall

    li $v0,5 #store temp input to s0 directly
	syscall

    move $s0,$v0

    li $s1,3 #player 1
    li $s2,4 #player 2

    #if(tempInput == 3 || tempInput == 4) then goto apropriate thing
    beq $s0,$s1,gameLoop
    beq $s0,$s2,symbolSwap
    j preGame

    symbolSwap:
        addi $s1,$s1,1
        addi $s2,$s2,-1

gameLoop:
    li $s3,0 #xPos
    li $s4,0 #yPos
    li $s5,0 #finalPos

    #if turn counter != 9, go to draw grid 1
    li $t9,9
    bne $t0,$t9, drawGrid1
    #else go to the stalemate message
    li $v0, 4
    la,$a0,StalemateMessage
    j exit

    drawGrid1:
        li $t7,3#if statement condition
        li $t8,0#iterator value
        li $t6,0
        drawWhile:
            #if we are done the loop, then exit
            beq $t8,$t7,input

            add $t6,$zero,$t8 #array offset holder

            #0, 3 and 6
            li $v0, 4
            la $a0,charGrid($t6)
            syscall

            #print |
            li $v0, 4
            la $a0,gridline
            syscall

            addi $t6,$t6,1#incriment counter by one

            #1, 4 and 7
            li $v0, 4
            la $a0,charGrid($t6)
            syscall
            
            #print |
            li $v0, 4
            la $a0,gridline
            syscall

            addi $t6,$t6,1#incriment counter by one

            #2, 5 and 8
            li $v0, 4
            la $a0,charGrid($t6)
            syscall

            li $v0,4
            la $a0,newline
            syscall

            add $t8,$t8,1
            j drawWhile
        input:
            #xpos
            #prompt user for input
            li $v0, 4
            la $a0,EnterCoordsMessage
            syscall

            #take user input
            li $v0,5
            syscall

            move $s3,$v0
            
            #ypos
            #prompt user for input
            li $v0, 4
            la $a0,EnterCoordsMessage2
            syscall

            #take user input
            li $v0,5
            syscall

            move $s4,$v0

            li $t9,3
            mul $s4,$s4,$t9

            add $s5,$s4,$s3
            mul $s5,$s5,4

            lw $t9,grid($s5)
            #if grid[finalPos] == 0, place the symbol
            beq $t9,$zero,placeSymbol

            li $v0,4
            la $a0,SpotNotEmptyMessage
            syscall

            j input#else back to top
            placeSymbol:

            #if turn % 2 == 0, its player one's turn 
            li $t9,2           
            div $t0,$t9
            mfhi $t9
            beq $t9,$zero,player1Turn
            #else
            la $t3,grid
            add $t3,$t3,$s5
            sw $s1,0($t3)

            #insert jump condition here
            player1Turn:
            la $t3,grid
            add $t3,$t3,$s5
            sw $s1,0($t3)


exit:
