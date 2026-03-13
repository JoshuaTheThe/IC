        # ----- HEAD
        #       start/S
        # ----- SOURCE
        .global _start
        .section .text
        #       the entry point of the compiler
_start: andl    $-4,  %esp
        call    init
        call    loadfil
        call    begin
        #       syscall( EXIT, code )
        xorl    %ebx,   %ebx
exit:
        xorl    %eax,   %eax
        incl    %eax
        int     $0x80
        .include "begin.S"
        .include "token.S"
        .include "token_sym.S"
        .include "token_keynum.S"
        .include "parse.S"
        .include "init.S"
        .include "out.S"
        .include "in.S"
        .include "data.S"
        .include "bss.S"

