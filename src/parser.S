        # PARSER FUNCTIONS
_IC_HASH:
        xorq    %rax,   %rax
        xorq    %rcx,   %rcx
.LH:    movzbl  _ID(%rcx), %edx
        imulq   %rcx,   %rdx        # char * index
        addq    %rdx,   %rax        # accumulate
        incq    %rcx
        cmpq    %r11,   %rcx
        jl      .LH
        ret
        