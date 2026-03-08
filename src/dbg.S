        # DBG/S
        # DEBUG UTILS

        # Print all registers
_IC_DBG:
        # Save all registers first
        movq    %rax,   _REGBUF+0
        movq    %rbx,   _REGBUF+8
        movq    %rcx,   _REGBUF+16
        movq    %rdx,   _REGBUF+24
        movq    %rsi,   _REGBUF+32
        movq    %rdi,   _REGBUF+40
        movq    %r8,    _REGBUF+48
        movq    %r9,    _REGBUF+56
        movq    %r10,   _REGBUF+64
        movq    %r11,   _REGBUF+72
        movq    %r12,   _REGBUF+80
        movq    %r13,   _REGBUF+88
        movq    %r14,   _REGBUF+96
        movq    %r15,   _REGBUF+104

        # Print each with label
        xorq    %r13,   %r13        # register index
.LPR:   # Print label
        movq    %r13,   %r14
        shlq    $3,     %r14
        write   $stderr, _RNMS(%r14), $8
        # Print value
        movq    _REGBUF(%r14),  %rdi
        call    _IC_PX
        # Newline
        write   $stderr, _NL, $1
        incq    %r13
        cmpq    $14,    %r13
        jl      .LPR

        # Restore all registers
        movq    _REGBUF+0, %rax
        movq    _REGBUF+8, %rbx
        movq    _REGBUF+16, %rcx
        movq    _REGBUF+24, %rdx
        movq    _REGBUF+32, %rsi
        movq    _REGBUF+40, %rdi
        movq    _REGBUF+48, %r8
        movq    _REGBUF+56, %r9
        movq    _REGBUF+64, %r10
        movq    _REGBUF+72, %r11
        movq    _REGBUF+80, %r12
        movq    _REGBUF+88, %r13
        movq    _REGBUF+96, %r14
        movq    _REGBUF+104, %r15
        write   $stderr, (_ID), %r15
        ret
