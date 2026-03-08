        # 
        #  src/start.S
        #  IC's entry point
        #  Notice - i normally write 32 bit bare metal ASM.
        #  ITS SO LIBERATING TO ACTUALLY HAVE A NORMAL AMOUNT OF REGISTERS
        #

        .include "m.S"
        .include "token.S"
        .include "parser.S"
        .include "display.S"
        .global _IC_I
        .section .text
_IC_I:    # Initialize function table
        leaq    _FNT,   %rdi
.Linit:
        # Ignore all below or equal to ascii 32(' ')
        movq    $_IC_W,   %rax
        movq    $33,    %rcx
        rep     stosq
        # Some Errors for now
        movq    $_IC_P,   %rax
        movq    $(48-33),   %rcx
        rep     stosq
        # Numbers
        movq    $_IC_N,   %rax
        movq    $10,    %rcx
        rep     stosq
        # Rest Rrror
        movq    $_IC_P,   %rax
        movq    $(64-57),    %rcx
        rep     stosq
        # A-Z
        movq    $_IC_ID,   %rax
        movq    $26,    %rcx
        rep     stosq
        # Rest Rrror
        movq    $_IC_P,   %rax
        movq    $(256-90),    %rcx
        rep     stosq

        # Symbols
        movq    $_IC_SYM_LP,        (_FNT + ('(' * 8))
        movq    $_IC_SYM_RP,        (_FNT + (')' * 8))
        movq    $_IC_SYM_EN,        (_FNT + (';' * 8))
        movq    $_IC_SYM_EN,        (_FNT + (',' * 8))
        movq    $_IC_SYM_AD,        (_FNT + ('+' * 8))
        movq    $_IC_SYM_SU,        (_FNT + ('-' * 8))
        movq    $_IC_SYM_AS,        (_FNT + ('*' * 8))
        movq    $_IC_SYM_SL,        (_FNT + ('/' * 8))
        movq    $_IC_SYM_PE,        (_FNT + ('%' * 8))
        movq    $_IC_SYM_AM,        (_FNT + ('&' * 8))
        movq    $_IC_SYM_CA,        (_FNT + ('^' * 8))
        movq    $_IC_SYM_PI,        (_FNT + ('|' * 8))
        movq    $_IC_SYM_BA,        (_FNT + ('!' * 8))
        movq    $_IC_SYM_LT,        (_FNT + ('<' * 8))
        movq    $_IC_SYM_GT,        (_FNT + ('>' * 8))
        movq    $_IC_SYM_EQ,        (_FNT + ('=' * 8))
        movq    $_IC_SYM_SE,        (_FNT + (':' * 8))
        # Initial Position
        xorl    %eax,   %eax
        movq    %rax,   _P
        # Read
        read    $stdin, (_PROG), $65535
        movq    %rax,   (_SZ)
        leaq    _PROG,  %r12
.LL:    # Start grabbing from buffer
        decq    (_SZ)
        jle     _IC_X
        call    _IC_R
        shlq    $3,     %rax
        call    *_FNT(%rax)
        jmp     .LL
_IC_X:  exit    $0
_IC_R:  movb    (%r12), %al
        movb    %al,    _DC
        incq    %r12
        return  %rax
_S0:    .asciz " [PANIC] Function is not implemented for symbol\n\00"
_S0E:
        .section .bss
_P:     .quad   00
_FNT:   .space  2048
_DC:    .byte   00
_ID:    .space  256
_SZ:    .space  8
_PROG:  .space 65536 # MAX PROGRAM SIZE
