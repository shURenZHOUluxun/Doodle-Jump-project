#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Student: Jiayi Zeng, Student Number: 1004711564
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# - Milestone 1
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data
	displayAddress: .word 0x10008000
	red: .word 0xff0000
	green: .word 0x00ff00
	black: .word 0x000000
	score: .word 0 #initial score of player
	platformArray: .space 20 #initialize array of 5 integers to store position of platform
	doodler: .word 496 #initial offset of position of doodler
.text
main:		#lw $t0, displayAddress # $t0 stores the base address for display
		addi $sp, $sp, -4
		sw $ra, 0($sp) #store return address into stack 
		jal platformLocation # calculate new platform location
goUp:		#jal redrawscreen
		jal drawplatform #initialize 5 platform based on platformLocation
		lw $t1, red
		addi $sp, $sp, -4
		sw $t1, 0($sp) #draw Score with green
		jal drawScore
		#lw  $t2, doodler
		#ble $t2, 0, Terminate #if doodler exceeds top of the screen, terminate program
		jal drawdoodler #initialize doodler depend on menmory position
		jal collision # check collision
		lw $t1, 0($sp)
		beq $t1, 1 , goUp
dropagain:	jal dropdoodler #doodler drop by one unit
		jal drawplatform #incase some platform loss its color
		jal collision # check collision
		lw $t1, 0($sp)
		beq $t1, 1, goUp
		lw $t2, doodler
		blt $t2, 1024, dropagain
Terminate:	jal redrawscreen
		jal drawG
		jal drawA
		jal drawM
		jal drawE
		jal drawO
		jal drawV
		jal drawE2
		jal drawR
		li $v0, 10 # terminate the program gracefully
		syscall


redrawscreen:	lw $t3, black #store black color
		li $t4, 1024 #max loop for screen
		li $t1, 0 #offset 
loop6:		sll $t2, $t1, 2 #offset times 4
		lw $t0, displayAddress #store base address
		add $t0, $t0, $t2 #calculate position
		sw $t3, 0($t0) #paint current block by black
		addi $t1, $t1, 1
		bne $t1, $t4, loop6
		jr $ra


platformLocation:	li $t1, 5 #loop 5 times
			li $t2, 0 #offset
			la $t6, platformArray #load array address
loop:			li $v0, 42 #radomize a number
			li $a0, 0 
			li $a1, 1024 #randomized number will be in range 0-1024
			syscall # radomized number stored in $a0
			sll $t5, $t2, 2 
			add $t6, $t6, $t5 #locate to array where we want to store number in 
			sw $a0, 0($t6) #store number into array
			addi $t2, $t2, 1 #offset add 1
			bne $t2, $t1, loop #check if we have 5 numbers already
			jr $ra	#jump back to caller
		
drawplatform:	li $t5, 4 #t5 stores 4
		li $t4, 5 #loop number, loop 5 times
		li $t7, 0 #offset for platform array address
		la $t6, platformArray #load platformArray address
loop2:		sll $t8, $t7, 2 #offset $t7 times 4
		add $t6, $t6, $t8 #locate to array where we want to store number in 
		lw $t3, 0($t6) #load position from array
		mul $t3, $t3, $t5 #multiply position number with 4
		lw $t1, red #store red color
		lw $t0, displayAddress #store base address
		add $t0, $t0, $t3 #calculate position
		sw $t1, 0($t0) # paint the platform by red 
		sw $t1, 4($t0) 
		sw $t1, 8($t0) 
		sw $t1, 12($t0)
		sw $t1, 16($t0)
		sw $t1, 20($t0) #the platform has length of 6 unit 
		addi, $t7, $t7, 1 # increase $t7 by 1
		bne, $t7, $t4, loop2 #if not complete 5 loops, continue looping
END:		jr $ra#jump back to main

				
drawdoodler:	lw $t3, black #store black color
		lw $t2, green #store green color
		lw $t1, red #store red color
		lw $t0, displayAddress #store base address
		li $t6, 4 # store 4
		li $t5, 10 #move up 10 units
loop3:		lw $t4, doodler
		mul $t4, $t4, $t6 #multiply $t4 with 4
		lw $t0, displayAddress #store base address
		add $t0, $t0, $t4 #calculate position
		sw $t2, 0($t0) # paint the doodler by red 
		sw $t2, 124($t0) 
		sw $t2, 128($t0) 
		sw $t2, 132($t0)
		sw $t2, 252($t0)
		sw $t2, 256($t0)
		sw $t3, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 268($t0)
		sw $t2, 380($t0)
		sw $t2, 384($t0)
		sw $t2, 388($t0)
		sw $t1, 508($t0)
		sw $t1, 512($t0)
		sw $t1, 516($t0)
		li $v0, 32 # wait for 1 second
		li $a0, 500
		syscall
		sw $t3, 0($t0) # repaint the screen by black
		sw $t3, 124($t0) 
		sw $t3, 128($t0) 
		sw $t3, 132($t0)
		sw $t3, 252($t0)
		sw $t3, 256($t0)
		sw $t3, 260($t0)
		sw $t3, 264($t0)
		sw $t3, 268($t0)
		sw $t3, 380($t0)
		sw $t3, 384($t0)
		sw $t3, 388($t0)
		sw $t3, 508($t0)
		sw $t3, 512($t0)
		sw $t3, 516($t0)
		addi $sp, $sp, -4
		sw $ra, 0($sp) #store return address into stack 
		addi $sp, $sp, -4
		sw $t0, 0($sp) #store $t0 into stack 
		addi $sp, $sp, -4
		sw $t1, 0($sp) #store $t1 into stack 
		addi $sp, $sp, -4
		sw $t2, 0($sp) #store $t2 into stack 
		addi $sp, $sp, -4
		sw $t3, 0($sp) #store $t3 into stack 
		addi $sp, $sp, -4
		sw $t4, 0($sp) #store $t4 into stack 
		addi $sp, $sp, -4
		sw $t5, 0($sp) #store $t5 into stack 
		addi $sp, $sp, -4
		sw $t6, 0($sp) #store $t6 into stack 
		jal drawplatform
		lw $t6, 0($sp) #load $t6 from stack 
		addi $sp, $sp, 4
		lw $t5, 0($sp) #load $t5 from stack 
		addi $sp, $sp, 4
		lw $t4, 0($sp) #load $t4 from stack 
		addi $sp, $sp, 4
		lw $t3, 0($sp) #load $t3 from stack 
		addi $sp, $sp, 4
		lw $t2, 0($sp) #load $t2 from stack 
		addi $sp, $sp, 4
		lw $t1, 0($sp) #load $t1 from stack 
		addi $sp, $sp, 4
		lw $t0, 0($sp) #load $t0 from stack 
		addi $sp, $sp, 4
		lw $ra, 0($sp) #load return address into stack 
		addi $sp, $sp, 4
		lw $t7, 0xffff0004
		beq $t7, 0x6a, respond_j # check if j was pressed
		beq $t7, 0x6b, respond_k # check if k was pressed
draw_move:	addi $t4, $t4, -128
		sra $t4, $t4, 2 #divide $t4 by 4
		la $s0, doodler
		sw $t4, 0($s0)
		addi $t5, $t5, -1
		bnez $t5, loop3
		jr $ra
		

respond_j:	addi $t4, $t4, -4 # position move one block to left
		j draw_move
respond_k:	addi $t4, $t4, 4 # position move one block to right		
		j draw_move	

dropdoodler:	lw $t3, black #store black color
		lw $t2, green #store green color
		lw $t1, red #store red color
		li $t6, 4 # store 4
		lw $t4, doodler
		mul $t4, $t4, $t6 #multiply $t4 with 4
		lw $t7, 0xffff0004
		beq $t7, 0x6a, respond_j2 # check if j was pressed
		beq $t7, 0x6b, respond_k2 # check if k was pressed
draw:		addi $t4, $t4, 128
		lw $t0, displayAddress #store base address
		add $t0, $t0, $t4 #calculate position
		
		sra $t4, $t4, 2 #divide $t4 by 4
		la $s0, doodler
		sw $t4, 0($s0)
		
		sw $t2, 0($t0) # paint the doodler 
		sw $t2, 124($t0) 
		sw $t2, 128($t0) 
		sw $t2, 132($t0)
		sw $t2, 252($t0)
		sw $t2, 256($t0)
		sw $t3, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 268($t0)
		sw $t2, 380($t0)
		sw $t2, 384($t0)
		sw $t2, 388($t0)
		sw $t1, 508($t0)
		sw $t1, 512($t0)
		sw $t1, 516($t0)
		li $v0, 32 # wait for 1 second
		li $a0, 500
		syscall
		sw $t3, 0($t0) # repaint the screen by black
		sw $t3, 124($t0) 
		sw $t3, 128($t0) 
		sw $t3, 132($t0)
		sw $t3, 252($t0)
		sw $t3, 256($t0)
		sw $t3, 260($t0)
		sw $t3, 264($t0)
		sw $t3, 268($t0)
		sw $t3, 380($t0)
		sw $t3, 384($t0)
		sw $t3, 388($t0)
		sw $t3, 508($t0)
		sw $t3, 512($t0)
		sw $t3, 516($t0)
		jr $ra
		
respond_j2:	addi $t4, $t4, -4 # position move one block to left
		j draw
respond_k2:	addi $t4, $t4, 4 # position move one block to right		
		j draw
		
collision:	li $t5, 4 #t5 stores 4
		li $t4, 5 #loop number, loop 5 times
		li $t7, 0 #offset for platform array address
		la $t6, platformArray #load platformArray address
loop4:		sll $t8, $t7, 2 #offset $t7 times 4
		add $t6, $t6, $t8 #locate to array with offset
		lw $t3, 0($t6) #load position of platform from array
		lw $t2, doodler #load doodler position		
		addi $t2, $t2, 161 #doodler right bottom position
		bge $t2, $t3, next #check doodler right bottom greater than or equal to platform leftmost block
		addi $t7, $t7, 1 # if not collide, offset plus one
		bne $t7, $t4, loop4 # if not all platform checked, loop 
		li $t0, 0 # if all platform checked, no collision
		addi $sp, $sp, -4
		sw $t0, 0($sp) #store 1 for true 0 for false into stack 
		jr $ra #return 0
next:		addi $t2, $t2, -2 #doodler left bottom 
		addi $t3, $t3, 6 #platform rightmost block
		blt $t2, $t3, End # if collide, jump to end
		addi $t7, $t7, 1
		bne $t7, $t4, loop4
		li $t0, 0
		addi $sp, $sp, -4
		sw $t0, 0($sp) #store 1 for true 0 for false into stack 
		jr $ra
		
End:		
		blt $t3, 864, platformdown #if collided block not in last 5 rows, move it down
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		jal drawplatform
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		li $t0, 1
		addi $sp, $sp, -4
		sw $t0, 0($sp) #store 1 for true 0 for false into stack 
		jr $ra		

platformdown:	addi $t3, $t3, 32 # move block down one row
		li $s4, 5 #loop number, loop 5 times
		li $s7, 0 #offset for platform array address
		la $s6, platformArray #load platformArray address
loop5:		sll $s1, $s7, 2 #offset $t7 times 4
		add $s6, $s6, $s1 #locate to array where we want to store number in 
		lw $s3, 0($s6) #load position from array
		lw $s2, black #store block
		sll $s5, $s3, 2 #position number times 4
		lw $s0, displayAddress #load address
		add $s0, $s0, $s5 #calculate new address
		sw $s2, 0($s0)# paint old platform to black
		sw $s2, 4($s0)
		sw $s2, 8($s0)
		sw $s2, 12($s0)
		sw $s2, 16($s0)
		sw $s2, 20($s0)
		addi $s3, $s3, 32 #move one row down
		bge $s3, 1024, renew
restore:	sw $s3, 0($s6)
		addi $s7, $s7, 1 #offset add 1
		bne $s7, $s4, loop5 #check if we have 5 numbers already
		j End
renew:		li $v0, 42 #radomize a number
		li $a0, 0 
		li $a1, 26 #randomized number will be in range 0-26
		syscall # radomized number stored in $a0
		addi $s3, $a0, 0
		j restore
		
drawG:		lw $t1, red
		lw $t0, displayAddress
		li $t3, 102 #offset of top left block
		sll $t4, $t3, 2 # offset times 4
		add $t0, $t0, $t4 #calculate top left block 
		sw $t1, 0($t0) #draw G with red
		sw $t1, 4($t0)
		sw $t1, 8($t0)
		sw $t1, 12($t0)
		sw $t1, 128($t0)
		sw $t1, 256($t0)
		sw $t1, 264($t0)
		sw $t1, 268($t0)
		sw $t1, 384($t0)
		sw $t1, 396($t0)
		sw $t1, 512($t0)
		sw $t1, 516($t0)
		sw $t1, 520($t0)
		sw $t1, 524($t0)
		jr $ra

drawA:		lw $t1, red
		lw $t0, displayAddress
		li $t3, 108 #offset of top left block
		sll $t4, $t3, 2 # offset times 4
		add $t0, $t0, $t4 #calculate top left block 
		sw $t1, 0($t0) #draw G with red
		sw $t1, 124($t0)
		sw $t1, 132($t0)
		sw $t1, 252($t0)
		sw $t1, 256($t0)
		sw $t1, 260($t0)
		sw $t1, 380($t0)
		sw $t1, 388($t0)
		sw $t1, 508($t0)
		sw $t1, 516($t0)
		jr $ra

drawM:		lw $t1, red
		lw $t0, displayAddress
		li $t3, 111 #offset of top left block
		sll $t4, $t3, 2 # offset times 4
		add $t0, $t0, $t4 #calculate top left block 
		sw $t1, 0($t0) #draw G with red
		sw $t1, 16($t0)
		sw $t1, 128($t0)
		sw $t1, 132($t0)
		sw $t1, 140($t0)
		sw $t1, 144($t0)
		sw $t1, 256($t0)
		sw $t1, 264($t0)
		sw $t1, 272($t0)
		sw $t1, 384($t0)
		sw $t1, 400($t0)
		sw $t1, 512($t0)
		sw $t1, 528($t0)
		jr $ra

drawE:		lw $t1, red
		lw $t0, displayAddress
		li $t3, 117 #offset of top left block
		sll $t4, $t3, 2 # offset times 4
		add $t0, $t0, $t4 #calculate top left block 
		sw $t1, 0($t0) #draw G with red
		sw $t1, 4($t0)
		sw $t1, 8($t0)
		sw $t1, 128($t0)
		sw $t1, 256($t0)
		sw $t1, 260($t0)
		sw $t1, 264($t0)
		sw $t1, 384($t0)
		sw $t1, 512($t0)
		sw $t1, 516($t0)
		sw $t1, 520($t0)
		jr $ra

drawO:		lw $t1, red
		lw $t0, displayAddress
		li $t3, 326 #offset of top left block
		sll $t4, $t3, 2 # offset times 4
		add $t0, $t0, $t4 #calculate top left block 
		sw $t1, 4($t0) #draw G with red
		sw $t1, 8($t0)
		sw $t1, 128($t0)
		sw $t1, 140($t0)
		sw $t1, 256($t0)
		sw $t1, 268($t0)
		sw $t1, 384($t0)
		sw $t1, 396($t0)
		sw $t1, 516($t0)
		sw $t1, 520($t0)
		jr $ra
		
drawV:		lw $t1, red
		lw $t0, displayAddress
		li $t3, 331 #offset of top left block
		sll $t4, $t3, 2 # offset times 4
		add $t0, $t0, $t4 #calculate top left block 
		sw $t1, 0($t0) #draw G with red
		sw $t1, 16($t0)
		sw $t1, 128($t0)
		sw $t1, 144($t0)
		sw $t1, 256($t0)
		sw $t1, 272($t0)
		sw $t1, 388($t0)
		sw $t1, 396($t0)
		sw $t1, 520($t0)
		jr $ra
		
drawE2:		lw $t1, red
		lw $t0, displayAddress
		li $t3, 337 #offset of top left block
		sll $t4, $t3, 2 # offset times 4
		add $t0, $t0, $t4 #calculate top left block 
		sw $t1, 0($t0) #draw G with red
		sw $t1, 4($t0)
		sw $t1, 8($t0)
		sw $t1, 128($t0)
		sw $t1, 256($t0)
		sw $t1, 260($t0)
		sw $t1, 264($t0)
		sw $t1, 384($t0)
		sw $t1, 512($t0)
		sw $t1, 516($t0)
		sw $t1, 520($t0)
		jr $ra

drawR:		lw $t1, red
		lw $t0, displayAddress
		li $t3, 341 #offset of top left block
		sll $t4, $t3, 2 # offset times 4
		add $t0, $t0, $t4 #calculate top left block 
		sw $t1, 0($t0) #draw G with red
		sw $t1, 4($t0)
		sw $t1, 8($t0)
		sw $t1, 128($t0)
		sw $t1, 136($t0)
		sw $t1, 256($t0)
		sw $t1, 260($t0)
		sw $t1, 264($t0)
		sw $t1, 384($t0)
		sw $t1, 388($t0) 
		sw $t1, 512($t0)
		sw $t1, 520($t0)

drawScore:	lw $t6, 0($sp)# pop color from stack
		addi $sp, $sp, 4 #pop 
		lw $t1, score
		li $t2, 10 # store 10
		div $t1, $t2 #divide score with 10
		mflo $t3 #quotient, tenth digit
		mfhi $t4 #remainder, oneth digit
		li $t5, 132 #top left block of tenth digit
		addi $sp, $sp, -4
		sw $ra, 0($sp) #store return address into stack
		addi $sp, $sp, -4
		sw $t3, 0($sp) #store quotient into stack
		addi $sp, $sp, -4
		sw $t4, 0($sp) #store remainder into stack
		addi $sp, $sp, -4
		sw $t6, 0($sp) #store color into stack
		addi $sp, $sp, -4
		sw $t5, 0($sp) #store top left block for tenth digit into stack
		beq $t3, 0, drawzero # if tenth digit is 0
		beq $t3, 1, drawone # if tenth digit is 1
		beq $t3, 2, drawtwo # if tenth digit is 2
		beq $t3, 3, drawthree # if tenth digit is 3
		beq $t3, 4, drawfour # if tenth digit is 4
		beq $t3, 5, drawfive # if tenth digit is 5
		beq $t3, 6, drawsix # if tenth digit is 6
		beq $t3, 7, drawseven # if tenth digit is 7
		beq $t3, 8, draweight # if tenth digit is 8
		beq $t3, 9, drawnine # if tenth digit is 9
drawoneth:	lw $t5, 0($sp)
		addi $sp, $sp, 4 #pop numbers
		lw $t6, 0($sp)
		addi $sp, $sp, 4 #pop numbers
		lw $t4, 0($sp)
		addi $sp, $sp, 4 #pop numbers
		lw $t3, 0($sp)
		addi $sp, $sp, 4 #pop numbers
		li $t5, 148 #top left block of oneth digit
		addi $sp, $sp, -4
		sw $t6, 0($sp) #store color into stack
		addi $sp, $sp, -4
		sw $t5, 0($sp) #store top left block for oneth digit into stack
		beq $t4, 0, drawzero2 # if oneth digit is 0
		beq $t4, 1, drawone2 # if oneth digit is 1
		beq $t4, 2, drawtwo2 # if oneth digit is 2
		beq $t4, 3, drawthree2 # if oneth digit is 3
		beq $t4, 4, drawfour2 # if oneth digit is 4
		beq $t4, 5, drawfive2 # if oneth digit is 5
		beq $t4, 6, drawsix2 # if oneth digit is 6
		beq $t4, 7, drawseven2 # if oneth digit is 7
		beq $t4, 8, draweight2 # if oneth digit is 8
		beq $t4, 9, drawnine2 # if oneth digit is 9
Finish:		lw $t5, 0($sp)
		addi $sp, $sp, 4 #pop numbers
		lw $t6, 0($sp)
		addi $sp, $sp, 4 #pop color
		lw $ra, 0($sp)
		addi $sp, $sp, 4 #pop $ra
		jr $ra


drawzero:	jal drawZero
		j drawoneth
drawone:	jal drawOne
		j drawoneth
drawtwo:	jal drawTwo
		j drawoneth
drawthree:	jal drawThree
		j drawoneth
drawfour:	jal drawFour
		j drawoneth
drawfive:	jal drawFive
		j drawoneth
drawsix:	jal drawSix
		j drawoneth
drawseven:	jal drawSeven
		j drawoneth
draweight:	jal drawEight
		j drawoneth
drawnine:	jal drawNine
		j drawoneth

drawzero2:	jal drawZero
		j Finish
drawone2:	jal drawOne
		j Finish
drawtwo2:	jal drawTwo
		j Finish
drawthree2:	jal drawThree
		j Finish
drawfour2:	jal drawFour
		j Finish
drawfive2:	jal drawFive
		j Finish
drawsix2:	jal drawSix
		j Finish
drawseven2:	jal drawSeven
		j Finish
draweight2:	jal drawEight
		j Finish
drawnine2:	jal drawNine
		j Finish

drawZero:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 128($t0)
		sw $t2, 136($t0)
		sw $t2, 256($t0)
		sw $t2, 264($t0)
		sw $t2, 384($t0)
		sw $t2, 392($t0)
		sw $t2, 512($t0)
		sw $t2, 516($t0)
		sw $t2, 520($t0)
		jr $ra

drawOne:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 132($t0)
		sw $t2, 260($t0)
		sw $t2, 388($t0)
		sw $t2, 512($t0)
		sw $t2, 516($t0)
		sw $t2, 520($t0)
		jr $ra

drawTwo:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 136($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 384($t0)
		sw $t2, 512($t0)
		sw $t2, 516($t0)
		sw $t2, 520($t0)
		jr $ra

drawThree:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 136($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 392($t0)
		sw $t2, 512($t0)
		sw $t2, 516($t0)
		sw $t2, 520($t0)
		jr $ra
		
drawFour:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 8($t0)
		sw $t2, 128($t0)
		sw $t2, 136($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 392($t0)
		sw $t2, 520($t0)
		jr $ra		
		
drawFive:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 128($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 392($t0)
		sw $t2, 512($t0)
		sw $t2, 516($t0)
		sw $t2, 520($t0)
		jr $ra
		
drawSix:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 128($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 384($t0)
		sw $t2, 392($t0)
		sw $t2, 512($t0)
		sw $t2, 516($t0)
		sw $t2, 520($t0)
		jr $ra	
		
drawSeven:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 136($t0)
		sw $t2, 264($t0)
		sw $t2, 392($t0)
		sw $t2, 520($t0)
		jr $ra			
		
drawEight:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 128($t0)
		sw $t2, 136($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 384($t0)
		sw $t2, 392($t0)
		sw $t2, 512($t0)
		sw $t2, 516($t0)
		sw $t2, 520($t0)
		jr $ra
		
drawNine:	lw $t1, 0($sp) #load offset
		lw $t0, displayAddress
		lw $t2, 4($sp) #load color
		add $t0, $t0, $t1 #locate left top block
		sw $t2, 0($t0) # paint the number
		sw $t2, 4($t0)
		sw $t2, 8($t0)
		sw $t2, 128($t0)
		sw $t2, 136($t0)
		sw $t2, 256($t0)
		sw $t2, 260($t0)
		sw $t2, 264($t0)
		sw $t2, 392($t0)
		sw $t2, 520($t0)
		jr $ra
