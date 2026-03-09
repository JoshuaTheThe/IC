MAIN:
	pushq %rbp
	movq %rsp,%rbp
	pushq $0x0000000000000045
	popq %eax
	movq %rbp, %rsp
	popq %rbp
	ret
