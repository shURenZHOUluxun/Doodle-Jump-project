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
	platformArray: .word 0:5 #initialize array of 5 integers to store position of platform
	doodler: .word 496 #initial offset of position of doodler
.text
main:		lw $t0, displayAddress # $t0 stores the base address for display
		addi $sp, $sp, -4
		sw $ra, 0($sp) #store return address into stack 
		jal platformLocation # calculate new platform location
goUp:		jal redrawscreen
		jal drawplatform #initialize 5 platform based on platformLocation
		lw  $t2, doodler
		ble $t2, 0, Terminate #if doodler exceeds top of the screen, terminate program
		jal drawdoodler #initialize doodler depend on menmory position
		jal collision # check collision
		lw $t1, 0($sp)
		beq $t1, 1 , goUp
dropagain:	jal dropdoodler #doodler drop by one unit
		jal collision # check collision
		lw $t1, 0($sp)
		beq $t1, 1, goUp
		lw $t2, doodler
		blt $t2, 1024, dropagain
Terminate:	li $v0, 10 # terminate the program gracefully
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
		addi $t2, $t2, 129 #doodler left bottom position
		bge $t2, $t3, next
		addi $t7, $t7, 1
		bne $t7, $t4, loop4
		li $t0, 0
		addi $sp, $sp, -4
		sw $t0, 0($sp) #store 1 for true 0 for false into stack 
		jr $ra
next:		addi $t2, $t2, -2
		addi $t3, $t3, 6
		ble $t2, $t3, End
		addi $t7, $t7, 1
		bne $t7, $t4, loop4
		li $t0, 0
		addi $sp, $sp, -4
		sw $t0, 0($sp) #store 1 for true 0 for false into stack 
		jr $ra
		
End:		blt $t3, 928, platformdown
		li $t0, 1
		addi $sp, $sp, -4
		sw $t0, 0($sp) #store 1 for true 0 for false into stack 
		jr $ra		

platformdown:	addi $t3, $t3, 128 
		li $s4, 5 #loop number, loop 5 times
		li $s7, 0 #offset for platform array address
		la $s6, platformArray #load platformArray address
loop5:		sll $s1, $s7, 2 #offset $t7 times 4
		add $s6, $s6, $s1 #locate to array where we want to store number in 
		lw $s3, 0($s6) #load position from array
		addi $s3, $s3, 128 #move one row down
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
		





















