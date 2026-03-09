MAIN:
	pushq %rbp
	movq %rsp,%rbp
	subq $8, %rsp
	pushq $0x0000000000000002
	popq (%rbp)
	popq %eax
	movq %rbp, %rsp
	popq %rbp
	ret
