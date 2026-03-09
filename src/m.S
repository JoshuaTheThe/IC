.macro rcc c
        j\c      .Lrcc\@
        jmp      .Lrcce\@
.Lrcc\@:
        ret
.Lrcce\@:
.endm

.macro rccsc c
        j\c      .Lrccsc\@
        jmp      .Lrccsce\@
.Lrccsc\@:
        stc
        ret
.Lrccsce\@:
        clc
.endm

.macro  exit    with
        movq    \with,   %rdi
        movq    $60,    %rax
        syscall
.endm

.macro read     fd      buf     len
        xorl    %eax,   %eax        
        movq    \fd,    %rdi
        leaq    \buf,   %rsi
        movq    \len,   %rdx
        syscall
.endm

.macro  write   fd      buf     len
        pushq   %rax
        xorl    %eax,   %eax
        movb    $1,     %al
        movq    \fd,    %rdi
        leaq    \buf,   %rsi
        movq    \len,   %rdx
        syscall
        popq    %rax
.endm

.macro  return v
        movq    \v,     %rax
        ret
.endm

.macro  retucc cc,v
        movq    \v,     %rax
        rcc     \cc
.endm

.macro  retuccsc cc, v
        movq    \v,     %rax
        rccsc   \cc
.endm

.macro unget
        incq    (_SZ)
        decq    %r12
.endm

.macro unget_tok
        movq    (_PREVSZ),       %r12
        movq    %r12,          (_SZ)
        movq    (_PREVPOS),      %r12
.endm

        .equ stdin, 0
        .equ stdout, 1
        .equ stderr, 2
        .equ null, 0
        # END OF M.S
