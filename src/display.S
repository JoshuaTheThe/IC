        # DISPLAY/S
        # DISPLAY LIBRARY, TO PRINT NUMBERS AND STRINGS TO THE CONSOLE

        # Panic
_IC_P:  call    _IC_DBG
        write   $stderr, (_S0), $(_S0E-_S0)
_IC_PH: jmp     _IC_PH
_IC_PP:  write   $stderr, (_S1), $(_S1E-_S1)
_IC_PPH: jmp    _IC_PPH

_IC_PX: movq    %rdi,   %rbx
        movq    $_PXBUF, %rdi
        movl    $15,    %ecx
        xorb    %al,    %al
        repe    stosb
        movl    $15,    %edx        # digit index (15 down to 0)
        movl    $00,    %ecx        # bit offset (60 down to 0)
.LPX:   movq    %rbx,   %rax
        shrq    %cl,    %rax
        andq    $15,    %rax        # low nibble
        movb    _HEX(%rax), %al
        movb    %al,    _PXBUF(%rdx)
        addl    $4,     %ecx
        decl    %edx
        jns     .LPX
        write   %r8, _PXBUF, $16
        ret
