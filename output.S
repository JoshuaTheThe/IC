	pushq $0x0000000000000002
	pushq $0x0000000000000002
	popq %rbx
	popq %rax
	addq %rbx, %rax
	pushq %rax
	pushq $0x0000000000000008
	popq %rbx
	popq %rax
	imulq %rbx, %rax
	pushq %rax
	popq %rax
	ret
