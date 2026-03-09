	pushq $0x0000000000000040
	pushq $0x0000000000000040
	popq %rbx
	popq %rax
	addq %rbx, %rax
	pushq %rax
	pushq $0x0000000000000080
	popq %rbx
	popq %rax
	imulq %rbx, %rax
	pushq %rax
	popq %rax
	ret
