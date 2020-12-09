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
.text
main:		lw $t0, displayAddress # $t0 stores the base address for display
		lw $t1, red # $t1 stores the red colour code
		lw $t2, green # $t2 stores the green colour code
		lw $t3, black # $t3 stores the black colour code
		addi $sp, $sp, -4
		sw $ra, 0($sp) #store return address into stack 
		jal drawplatform #initialize 5 platform randomly
		jal drawdoodler #initialize doodler to the center of the screen
		 

		li $v0, 10 # terminate the program gracefully
		syscall

		
		
drawplatform:	li $t5, 4 #t5 stores 4
		li $t4, 5 #loop number, loop 5 times
		li $t7, 0 #offset for platform array address
loop:		li $v0, 42 #radomize a number
		li $a0, 0 
		li $a1, 1024 #randomized number will be in range 0-1024
		syscall # radomized number stored in $a0
		la $t6, platformArray #load platformArray address
		sll $t8, $t7, 2 #offset $t7 times 4
		add $t6, $t6, $t8 #locate to array where we want to store number in 
		sw $a0, 0($t6) #store randomised position into array
		mul $a0, $a0, $t5 #multiply radomized number with 4
		
		lw $t3, black #store black color
		lw $t2, green #store green color4
		lw $t1, red #store red color
		lw $t0, displayAddress #store base address
		add $t0, $t0, $a0 #calculate position
		sw $t1, 0($t0) # paint the platform by red 
		sw $t1, 4($t0) 
		sw $t1, 8($t0) 
		sw $t1, 12($t0)
		sw $t1, 16($t0)
		sw $t1, 20($t0) #the platform has length of 6 unit 
		addi, $t7, $t7, 1 # increase $t7 by 1
		bne, $t7, $t4, loop #if not complete 5 loops, continue looping
END:		jr $ra#jump back to main

				
drawdoodler:	lw $t3, black #store black color
		lw $t2, green #store green color4
		lw $t1, red #store red color
		lw $t0, displayAddress #store base address
		li $t5, 10 #move up 10 units
		li $t4, 1984 
loop2:		lw $t0, displayAddress #store base address
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
		li $a0, 1000
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
		lw $t7, 0xffff0004
		beq $t7, 0x6a, respond_j # check if j was pressed
		beq $t7, 0x6b, respond_k # check if k was pressed
draw_move:	addi $t4, $t4, -128
		addi $t5, $t5, -1
		bnez $t5, loop2
		
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
		jr $ra
		

respond_j:	addi $t4, $t4, -4 # position move one block to left
		j draw_move
respond_k:	addi $t4, $t4, 4 # position move one block to right		
		j draw_move	
	
	
#Exit:
	#li $v0, 10 # terminate the program gracefully
	#syscall






