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
        .include "dbg.S"
        .global _IC_I
        .section .text
_IC_I:    # Initialize function table
        leaq    _FNT,   %rdi
.Linit:
        # Set up Token Function Table

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
        read    $stdin, (_PROG), $4095
        movq    %rax,   (_SZ)
        leaq    _PROG,  %r12
        call    _IC_NXT
.LL:    # Start grabbing from buffer
        call    _IC_EXPR
        cmpq    $0,     (_SZ)
        jne     .LL
_IC_X:  exit    $0
_IC_R:  movb    (%r12), %al
        movb    %al,    _DC
        decq    (_SZ)
        incq    %r12
        return  %rax
_S0:    .asciz " [PANIC] Function is not implemented for symbol\n\00"
_S0E:
_KLONG: .asciz "LONG\00"
_KIF:   .asciz "IF\00"
_KWHILE:.asciz "WHILE\00"
_KRETUR:.asciz "RETURN\00"
_HEX:   .asciz "0123456789ABCDEF"
_RNMS:  .ascii  "rax     "
        .ascii  "rbx     "
        .ascii  "rcx     "
        .ascii  "rdx     "
        .ascii  "rsi     "
        .ascii  "rdi     "
        .ascii  "r8      "
        .ascii  "r9      "
        .ascii  "r10     "
        .ascii  "r11     "
        .ascii  "r12     "
        .ascii  "r13     "
        .ascii  "r14     "
        .ascii  "r15     "
_NL:    .byte   '\n'
        .byte   '\r'
_EMIT_MOD:
        .ascii  "\txorl %edx, %edx\n\tpopq  %rbx\n\tpopq  %rax\n\tidivq %rbx,%rax\n\tmovq %rdx, %rax\n\tpushq %rax\n"
_EMIT_MOD.E:
_EMIT_DIV:
        .ascii  "\tpopq  %rbx\n\tpopq  %rax\n\tidivq %rbx,%rax\n\tpushq %rax\n"
_EMIT_DIV.E:
_EMIT_MUL:
        .ascii  "\tpopq  %rbx\n\tpopq  %rax\n\timulq %rbx,%rax\n\tpushq %rax\n"
_EMIT_MUL.E:
_EMIT_OR:
        .ascii  "\tpopq  %rbx\n\tpopq  %rax\n\torq  %rbx,%rax\n\tpushq %rax\n"
_EMIT_OR.E:
_EMIT_AND:
        .ascii  "\tpopq  %rbx\n\tpopq  %rax\n\tandq  %rbx,%rax\n\tpushq %rax\n"
_EMIT_AND.E:
_EMIT_ADD:
        .ascii  "\tpopq  %rbx\n\tpopq  %rax\n\taddq  %rbx,%rax\n\tpushq %rax\n"
_EMIT_ADD.E:
_EMIT_SUB:
        .ascii  "\tpopq  %rbx\n\tpopq  %rax\n\tsubq  %rbx,%rax\n\tpushq %rax\n"
_EMIT_SUB.E:
_EMIT_RET:
        .ascii  "\tpopq  %rax\n\tret\n"
_EMIT_RET.E:
_EMIT_PUSH:
        .ascii  "\tpushq $0x"
_EMIT_PUSH.E:
_EXPECTED:
        .ascii  "Syntax Error is present, Aborting\n"
_EXPECTED.E:
        .section .bss
_REGBUF:.space  112     # 14 * 8
_ICSAVE:.space  8
_P:     .quad   00
_FNT:   .space  8*256
_DC:    .byte   00
_ID:    .space  32
_SZ:    .space  8
_PROG:  .space 4096 # MAX PROGRAM SIZE
_PXBUF: .space  16
_PREVPOS:   .quad 0
_PREVSZ:    .quad 0
