#Anthony Smiderle 100695532
#Evyn Brouwer 100702629
#Jeremy Kan 100704536

.data
grid: .word 0:9
turn: .word 0

StartMessage: .asciiz "player 1, pick 3 for X, or 4 for O\n"
StalemateMessage: .asciiz "it's a stalemate!\n"
EnterCoordsMessage: .asciiz "enter x coords\n"
EnterCoordsMessage2: .asciiz "enter y coords\n"
SpotNotEmptyMessage: .asciiz "spot not empty\n"
PlayAgain: .asciiz "Do you want to play again? 1 for yes, 2 for no\n"

Player1WinMessage: .asciiz "Player 1 wins!\n"
Player2WinMessage: .asciiz "Player 2 wins!\n"

X: .asciiz "X"
O: .asciiz "O"
Space: .asciiz " "

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

    syscall
    j exit

    drawGrid1:
        li $t7,3#if statement condition
        li $t8,0#iterator value
        li $t6,0#array offset holder
        drawWhile:
            #if we are done the loop, then exit
            beq $t8,$t7,input
            
            li $t2,3 #condition
            li $t3,0 #iterator value
            innerFor:
                 beq $t3,$t2,innerForExit

                 li $v0,4
                 la $a0,gridline
                 syscall
                 #if character is x
                 li $t9,3
                 lw $t4, grid($t6)
                 beq $t4,$t9,drawX

                 #if character is o
                 li $t9,4
                 beq $t4,$t9,drawO

                 #if its a space
                 beq $t4,$zero,drawZero
                 drawX:
                     li $v0, 4
                     la $a0,X
                     syscall
                     j drawGridLine
                 drawO:
                     li $v0, 4
                     la $a0,O
                     syscall
                     j drawGridLine
                 drawZero:
                     li $v0, 4
                     la $a0,Space
                     syscall

                 drawGridLine:
                 li $v0,4
                 la $a0,gridline
                 syscall

                 add $t6,$t6,4 #increment offset holder

                 add $t3,$t3,1

                 j innerFor
            innerForExit:

            li $v0,4
            la $a0,newline
            syscall
            li $t9,4
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
            sw $s2,0($t3)

            j checkWinner
            
            player1Turn:
                la $t3,grid
                add $t3,$t3,$s5
                sw $s1,0($t3)
                
        checkWinner:

        #t2 and t3 are used to figure out who won
        li $t9,3
        mul $t2,$s1,$t9
        mul $t3,$s2,$t9

        #vertical 1
        li $t7, 0#add to
        
        li $t9, 0
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 12
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 24
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        beq $t7,$t2,player1Win
        beq $t7,$t3,player2Win

        #vertical 2
        li $t7, 0#add to
        
        li $t9, 4
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 16
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 28
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        beq $t7,$t2,player1Win
        beq $t7,$t3,player2Win

        #vertical 3
        li $t7, 0#add to
        
        li $t9, 8
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 20
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 32
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        beq $t7,$t2,player1Win
        beq $t7,$t3,player2Win
        
         #horizontal 1
        li $t7, 0#add to
        
        li $t9, 0
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 4
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 8
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        beq $t7,$t2,player1Win
        beq $t7,$t3,player2Win

         #horizontal 2
        li $t7, 0#add to
        
        li $t9, 12
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 16
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 20
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        beq $t7,$t2,player1Win
        beq $t7,$t3,player2Win

         #horizontal 3
        li $t7, 0#add to
        
        li $t9, 24
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 28
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 32
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        beq $t7,$t2,player1Win
        beq $t7,$t3,player2Win

         #diagonal 1
        li $t7, 0#add to
        
        li $t9, 0
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 16
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 32
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        beq $t7,$t2,player1Win
        beq $t7,$t3,player2Win

         #diagonal 2
        li $t7, 0#add to
        
        li $t9, 8
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 16
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        li $t9, 24
        lw $t8, grid($t9)
        add $t7, $t7, $t8
        
        beq $t7,$t2,player1Win
        beq $t7,$t3,player2Win
        
        add $t0,$t0,1
        
        j gameLoop
        
        player1Win:
        
        li $v0, 4
	la $a0, Player1WinMessage
	syscall
        j exit
        
        player2Win:
        
        li $v0, 4
	la $a0, Player2WinMessage
	syscall
        j exit
	
exit:

 drawGrid2:
        li $t7,3#if statement condition
        li $t8,0#iterator value
        li $t6,0#array offset holder
        drawWhile2:
            #if we are done the loop, then exit
            beq $t8,$t7,exit2
            
            li $t2,3 #condition
            li $t3,0 #iterator value
            innerFor2:
                 beq $t3,$t2,innerForExit2

                 li $v0,4
                 la $a0,gridline
                 syscall
                 #if character is x
                 li $t9,3
                 lw $t4, grid($t6)
                 beq $t4,$t9,drawX2

                 #if character is o
                 li $t9,4
                 beq $t4,$t9,drawO2

                 #if its a space
                 beq $t4,$zero,drawZero2
                 drawX2:
                     li $v0, 4
                     la $a0,X
                     syscall
                     j drawGridLine2
                 drawO2:
                     li $v0, 4
                     la $a0,O
                     syscall
                     j drawGridLine2
                 drawZero2:
                     li $v0, 4
                     la $a0,Space
                     syscall

                 drawGridLine2:
                 li $v0,4
                 la $a0,gridline
                 syscall

                 add $t6,$t6,4 #increment offset holder

                 add $t3,$t3,1

                 j innerFor2
            innerForExit2:

            li $v0,4
            la $a0,newline
            syscall
            li $t9,4
            add $t8,$t8,1
            j drawWhile2
exit2:

li $v0,4
la $a0,PlayAgain

syscall

li $v0,5
syscall

move $t0,$v0

li $t9,1
beq $t0,$t9,preGame

