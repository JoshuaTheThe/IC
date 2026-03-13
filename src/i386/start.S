        .global _start
        .section .text
_start:
        # syscall( EXIT, code )
        xorl    %eax,   %eax
        incl    %eax
        xorl    %ebx,   %ebx
        int     $0x80
        .include "bss.S"
