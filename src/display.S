        # DISPLAY/S
        # DISPLAY LIBRARY, TO PRINT NUMBERS AND STRINGS TO THE CONSOLE

        # Panic
_IC_P:  write   $stdout, (_S0), $(_S0E-_S0)
_IC_PH: return  %rax

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
        write   $stdout, _PXBUF, $16
        ret
