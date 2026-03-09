X:
	pushq %rbp
	movq %rsp,%rbp
	pushq (%rbp)
	popq %eax
	movq %rbp, %rsp
	popq %rbp
	ret
