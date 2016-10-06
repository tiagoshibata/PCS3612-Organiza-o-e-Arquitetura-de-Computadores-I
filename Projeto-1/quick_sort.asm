la $a0, v
add $a1, $zero, $zero
addi $a2, $zero, 12
jal quicksort
break
# halt: j halt

quicksort: # quicksort(int v[], int start, int end)
	slt $t0, $a1, $a2
	# return if start >= end
	bne $t0, $zero, valid_range
	jr $ra
	valid_range:
	add $t1, $a0, $a1  # $t1 = pointer to smaller numbers
	add $t2, $a0, $a2  # $t2 = pointer to larger numbers
	addi $t3, $t1, 4  # $t3 = &v[i + 1]
	lw $t0, 0($t1)  # $t0 = pivot

	three_way_partition:
		# $t4 = v[i]
		lw $t4, ($t3)

		bne $t0, $t4, not_equal
		# if v[i] == pivot, increment i
		addi $t3, $t3, 4
		b three_way_partition_end

		not_equal:
		# if v[i] < pivot
		slt $t5, $t4, $t0
		beq $t5, $zero, greater
		# swap(v, low++, i++) -> swap ($t1) and ($t3)
		lw $t6, ($t1)
		lw $t7, ($t3)
		sw $t6, ($t3)
		sw $t7, ($t1)
		# increment
		addi $t1, $t1, 4
		addi $t3, $t3, 4
		b three_way_partition_end

		greater:
		# v[i] > pivot
		# swap(v, i, high--) -> swap ($t2) and ($t3)
		lw $t6, ($t2)
		lw $t7, ($t3)
		sw $t6, ($t3)
		sw $t7, ($t2)
		# decrement
		addi $t2, $t2, -4

		# exit if high < i
		three_way_partition_end:
		sltu $t5, $t2, $3
	beq $t5, $zero, three_way_partition

	# save return address, high and end
	addi $sp, $sp, -12
	sw $ra, -8($sp)
	sw $t2, -4($sp)
	sw $a2, 0($sp)
	# recurse
	addi $a2, $t1, -4
	jal quicksort

	lw $a1, -4($sp)
	addi $a1, $a1, 4
	lw $a2, 0($sp)
	jal quicksort

	lw $ra, -8($sp)
	addi $sp, $sp, 12
	jr $ra
.data
v: .word 5, 4, 2, 3
