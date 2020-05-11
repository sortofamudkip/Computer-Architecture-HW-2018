.data
	n:	
		.word	0	
	c:	
		.word	0
	comma:	
		.word	0
	output:	
		.word	0

# TODO : change the file path to access the files for testing your result(IN ABSOLUTE PATH)
#        but change back to input.txt and output.txt when you upload your homework
	file_in:
		.asciiz	"input.txt"
	file_out:
		.asciiz	"output.txt"
		
# the following data is only for sample demonstration		
	output_ascii:	
		.byte	'0', '0', '3', '6'

.text
	main:    #start of your program

#STEP1: open input file
# ($s0: fd_in)

	li	$v0, 13			# 13 = open file
	la	$a0, file_in		# $a2 <= filepath
	li	$a1, 0x4000		# $a1 <= flags = 0x4000 for Windows, 0x0000 for Linux
	li	$a2, 0			# $a2 <= mode = 0
	syscall				# $v0 <= $s0 = fd
	move	$s0, $v0		# store fd_in in $s0, fd_in is the file descriptor just returned by syscall

#STEP2: read inputs (chars) from file to registers
# ($s1: n, $s2: c)

#   2 bytes for n
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la	$a1, n			# $a1 <= n
	li	$a2, 2			# read 2 byte to the address given by n
	syscall
	
#   1 byte for the comma
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la	$a1, comma		# $a1 <= comma
	li	$a2, 1			# read 1 bytes to the address given by comma
	syscall
	
#   2 bytes for c
	li	$v0, 14			# 14 = read from file
	move	$a0, $s0		# $a0 <= fd_in
	la	$a1, c			# $a1 <= c
	li	$a2, 2			# read 2 byte to the address given by c
	syscall

#STEP3: turn the chars into integers
	la	$a0, n		
	bal	atoi			 
	move	$s1, $v0		# $s1 <= atoi(n)

	la	$a0, c		
	bal	atoi			 
	move	$s2, $v0		# $s2 <= atoi(c)

################################ write your code below ################################
# Inputs are ($s1: n, $s2: c)
# Output is $s3 (in integer)

	# set $s7 = 2
	li $s7, 2            # $s7 = 2
	jal Tfunc
	move $s3, $v0
	j result

#STEP4: implement recursive function to solve the equation 
Tfunc:
	bge $s1, $s7, home     # go home if n >= 2
	# otherwise, return c
	move $v0, $s2        # $v0 = return value = $s2 = c
	jr $ra               # return
	
home:
	addi $sp, $sp, -8    # move the stack thingy down by 2 ints (return addr and n)
	sw $ra, 0($sp)       # push return addr to stack
	sw $s1, 4($sp)       # push s1 = n to stack

	# now go call Tfunc(n/2)
	div $s1, $s7         # $s1 / 2
	mflo $s1             # $s1 = $s1 / 2
	jal Tfunc          # jump straight to recurse(n/2); ans is now in v0
	move $s6, $v0        # let $s6 = $v0 = return value of recurse(n/2)

	# load original n, return addr
	lw $ra, 0($sp)       # load the original return addr back
	lw $v0, 4($sp)       # load the original $s1 = n back into $v0
	addi $sp, $sp, 8     # pop the stack
	# now, add the values all together: 2*recurse(n/2) + cn
	# do c*n = $s2 * $s1
	mult $v0, $s2        # $v0 * $s2 = n*c
	mflo $t3             # $t3 = $v0 * $s2 = c * n
	# do 2*recurse(n/2) = 2 * $s6
	mult $s6, $s7        # multiply $s6 * 2
	mflo $t1             # $t1 = $s6 * 2 (this is 2*recurse(n/2))
	add $v0, $t1, $t3    # add them and put them into v0
	jr $ra               # return


#STEP5: turn the integer into printable char
    # transferred ASCII should be put into "output_ascii"(see definition in the beginning of the file)
result:
	sw	$s3, output	# output <= $s3	
	move	$a0, $s3
	bal	itoa		# itoa($s3)

	# TODO: store return array to output_ascii

	jr	ret

itoa:
	# Input: ($a0 = input integer)
	# Output: ( output_ascii )
	# TODO: (you should turn an integer into a pritable char with the right ASCII code to output_ascii)
	
	la $t5, output_ascii
	li $t2, 10
	# repeatedly divide $a0, taking the last digit and then moving it to output_ascii
	div $a0, $t2
	mflo $a0           # a0 /= 10
	mfhi $t0           # t0 = last digit of a0
	addi $t0, 48
	sb $t0, 3($t5)     # take t0 and save it into output_ascii[3]
	div $a0, $t2
	mflo $a0           # a0 /= 10
	mfhi $t0           # t0 = last digit of a0
	addi $t0, 48
	sb $t0, 2($t5)     # take t0 and save it into output_ascii[2]
	div $a0, $t2
	mflo $a0           # a0 /= 10
	mfhi $t0           # t0 = last digit of a0
	addi $t0, 48
	sb $t0, 1($t5)     # take t0 and save it into output_ascii[1]
	div $a0, $t2
	mflo $a0           # a0 /= 10
	mfhi $t0           # t0 = last digit of a0
	addi $t0, 48
	sb $t0, 0($t5)     # take t0 and save it into output_ascii[0]

	jr	$ra		# go straight to output

################################ write your code above ################################

ret:

#STEP6: write result (output_ascii) to file_out
# ($s4 = fd_out)
	
	li	$v0, 13			# 13 = open file
	la	$a0, file_out		# $a2 <= filepath
	li	$a1, 0x4301		# $a1 <= flags = 0x4301 for Windows, 0x41 for Linux
	li	$a2, 0644		# $a2 <= mode = 0
	syscall				# $v0 <= $s0 = fd_out
	move	$s4, $v0		# store fd_out in $s4
	
	li	$v0, 15			# 15 = write file
	move	$a0, $s4		# $a0 <= $s4 = fd_out
	la	$a1, output_ascii
	li	$a2, 4		
	syscall				# $v0 <= $s0 = fd
	
#STEP7: this is for you to debug your calculation on console
	li	$v0, 1			# 1 = print int
	lw	$a0, output		# $a0 <= $s1
	syscall				# print output


#STEP8: close file_in and file_out

	li	$v0, 16			# 16 = close file
	move	$a0, $s0		# $a0 <= $s0 = fd_in
	syscall				# close file

	li	$v0, 16			# 16 = close file
	move	$a0, $s4		# $a0 <= $s4 = fd_out
	syscall				# close file


# exit

	li	$v0, 10
	syscall



#######################################################################################
#
#  int atoi ( const char *str );
#
#  Parse the cstring str into an integral value
#
#  Author: http://stackoverflow.com/questions/9649761/mips-store-integer-data-into-array-from-file
atoi:
    	or      $v0, $zero, $zero   	# num = 0
   	or      $t1, $zero, $zero   	# isNegative = false
    	lb      $t0, 0($a0)
    	bne     $t0, '+', .isp      	# consume a positive symbol
    	addi    $a0, $a0, 1
.isp:
    	lb      $t0, 0($a0)
    	bne     $t0, '-', .num
    	addi    $t1, $zero, 1       	# isNegative = true
    	addi    $a0, $a0, 1
.num:
    	lb      $t0, 0($a0)
    	slti    $t2, $t0, 58        	# *str <= '9'
    	slti    $t3, $t0, '0'       	# *str < '0'
    	beq     $t2, $zero, .done
    	bne     $t3, $zero, .done
    	sll     $t2, $v0, 1
    	sll     $v0, $v0, 3
    	add     $v0, $v0, $t2       	# num *= 10, using: num = (num << 3) + (num << 1)
    	addi    $t0, $t0, -48
    	add     $v0, $v0, $t0       	# num += (*str - '0')
    	addi    $a0, $a0, 1         	# ++num
    	j   .num
.done:
    	beq     $t1, $zero, .out    	# if (isNegative) num = -num
    	sub     $v0, $zero, $v0		
.out:
    	jr      $ra         		# return

