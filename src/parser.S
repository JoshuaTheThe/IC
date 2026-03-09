        # PARSER FUNCTIONS
_IC_P_NUM:
        write   $stdout, _EMIT_PUSH, $(_EMIT_PUSH.E - _EMIT_PUSH)
        movq    %r15,   %rdi
        movq    $stdout,%r8
        call    _IC_PX
        write   $stdout, _NL, $1
        ret
_IC_P_ADD:
        pushq   %r11
        movq    $11,    %r11
        call    _IC_EXPR
        popq    %r11
        write   $stdout, _EMIT_ADD, $(_EMIT_ADD.E - _EMIT_ADD)
        ret
_IC_P_SUB:
        pushq   %r11
        movq    $11,    %r11
        call    _IC_EXPR
        popq    %r11
        write   $stdout, _EMIT_SUB, $(_EMIT_SUB.E - _EMIT_SUB)
        ret
_IC_P_LP:
_IC_P_RP:
_IC_P_IDE:
_IC_P_END:
_IC_P_AST:
_IC_P_SLH:
_IC_P_PCT:
_IC_P_AMP:
_IC_P_CAR:
_IC_P_PIP:
_IC_P_BNG:
_IC_P_LT:
_IC_P_GT:
_IC_P_EQ:
_IC_P_SET:
_IC_P_LONG:
_IC_P_IF:
_IC_P_WHILE:
        ret
_IC_P_RET:
                pushq   %r11
                xorq    %r11,   %r11
                call    _IC_EXPR
                write   $stdout, _EMIT_RET, $(_EMIT_RET.E - _EMIT_RET)
                movq    $tok_end,       %rdi
                call    _IC_REQUIRE
                popq    %r11
                ret
_IC_EXPR:       
_IC_EXPR_OR:    call    _IC_EXPR_AND
.M8:            call    _IC_NXT
                cmpq    $tok_amp, %rax
                jne     .LDONE
                call    _IC_EXPR_AND
                write   $stdout, _EMIT_OR, $(_EMIT_OR.E - _EMIT_OR)
                jmp     .M8
.LDONE:         unget_tok
                ret
_IC_EXPR_AND:   call    _IC_EXPR_ADD
.M11:           call    _IC_NXT
                cmpq    $tok_pipe, %rax
                jne     .LDONE
                call    _IC_EXPR_ADD
                write   $stdout, _EMIT_AND, $(_EMIT_AND.E - _EMIT_AND)
                jmp     .M11

# _IC_EXPR_CMP:   call    _IC_EXPR_ADD
                # < > =

_IC_EXPR_ADD:   call    _IC_EXPR_MUL
.M9:            call    _IC_NXT
                cmpq    $tok_add, %rax
                je      .LADD
                cmpq    $tok_sub, %rax
                je      .LSUB
                jmp     .LADONE
.LADD:          call    _IC_EXPR_MUL
                write   $stdout, _EMIT_ADD, $(_EMIT_ADD.E - _EMIT_ADD)
                jmp     .M9
.LSUB:          call    _IC_EXPR_MUL
                write   $stdout, _EMIT_SUB, $(_EMIT_SUB.E - _EMIT_SUB)
                jmp     .M9
.LADONE:        unget_tok
                ret

_IC_EXPR_MUL:   call    _IC_EXPR_UNARY
.M10:           call    _IC_NXT
                cmpq    $tok_asterisk, %rax
                je      .LMUL
                cmpq    $tok_slash, %rax
                je      .LDIV
                cmpq    $tok_percent, %rax
                je      .LMOD
                jmp     .LMDONE
.LMUL:          call    _IC_EXPR_UNARY
                write   $stdout, _EMIT_MUL, $(_EMIT_MUL.E - _EMIT_MUL)
                jmp     .M10
.LDIV:          call    _IC_EXPR_UNARY
                write   $stdout, _EMIT_DIV, $(_EMIT_DIV.E - _EMIT_DIV)
                jmp     .M10
.LMOD:          call    _IC_EXPR_UNARY
                write   $stdout, _EMIT_MOD, $(_EMIT_MOD.E - _EMIT_MOD)
                jmp     .M10
.LMDONE:        unget_tok
                ret
                # * / %

_IC_EXPR_UNARY: # ! & *
                call    _IC_EXPR_PRIMARY
                ret

_IC_EXPR_PRIMARY: # number, identifier, (expr)
                call    _IC_NXT
                cmpq    $tok_number,    %rax
                je      _IC_EXPR_NUM
                jmp     _IC_EXPR_END
_IC_EXPR_NUM:   write   $stdout, _EMIT_PUSH, $(_EMIT_PUSH.E - _EMIT_PUSH)
                movq    $stdout,        %r8
                movq    %r15,           %rdi
                call    _IC_PX
                write   $stdout, _NL, $1
                jmp     _IC_EXPR_END
_IC_EXPR_END:
                ret
