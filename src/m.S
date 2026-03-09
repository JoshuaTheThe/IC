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
        xorl    %eax,   %eax
        movb    $1,     %al
        movq    \fd,    %rdi
        leaq    \buf,   %rsi
        movq    \len,   %rdx
        syscall
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

.macro  bc c,a,v0=,v1=,op=testq,preop=,prea=,preb=

.ifnb   \preop
.ifnb   \prea
.ifnb   \preb
        \preop  \prea   \preb
.else
        \preop  \prea
.endif
.else
        \preop
.endif
.endif


.ifb    \v0
.else
.ifb    \v1
        \op     \v0,    \v0
.else
        \op     \v0,    \v1
.endif
.endif
        j\c     \a
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
