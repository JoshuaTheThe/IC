        # PARSER FUNCTIONS
_IC_HASH:
        xorq    %rax,   %rax
        movb    $1,     %cl
.LH:    movzbl  _ID-1(%rcx), %edx
        imulq   %rcx,   %rdx
        addq    %rdx,   %rax
        incq    %rcx
        cmpq    %r11,   %rcx
        jle     .LH
        ret
        # First Order Expression
_IC_EXPR:
        call    _IC_NXT
        ret
