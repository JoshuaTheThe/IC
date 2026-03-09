        .include "keyword.S"
_IC_EXPR:
        #       EQUIVILENT TO STATEMENT
        cmp     $tok_kw_long,   %rax
        je      _IC_KEY_LONG
        cmp     $tok_kw_if,   %rax
        je      _IC_KEY_IF
        cmp     $tok_kw_while,   %rax
        je      _IC_KEY_WHILE
        cmp     $tok_kw_return,   %rax
        je      _IC_KEY_RETURN
        call    _IC_ASSIGNMENT
        ret
_IC_ASSIGNMENT:
        call    _IC_OR
        ret
_IC_OR:
        call    _IC_AND
_IC_OR_LOOP:
        cmp     $tok_pipe,      %rax
        jne     _IC_OR_END
        call    _IC_NXT
        call    _IC_AND
        write   $stdout, _EMIT_OR, $(_EMIT_OR.E - _EMIT_OR)
        jmp     _IC_OR_LOOP
_IC_OR_END:
        ret
_IC_AND:
        call    _IC_ADD
_IC_AND_LOOP:
        cmp     $tok_amp,       %rax
        jne     _IC_AND_END
        call    _IC_NXT
        call    _IC_ADD
        write   $stdout, _EMIT_AND, $(_EMIT_AND.E - _EMIT_AND)
        jmp     _IC_AND_LOOP
_IC_AND_END:
        ret
_IC_ADD:
        call    _IC_MUL
_IC_ADD_LOOP:
        cmp     $tok_add,       %rax
        jne     _IC_SUB_CHK
        call    _IC_NXT
        call    _IC_MUL
        write   $stdout, _EMIT_ADD, $(_EMIT_ADD.E - _EMIT_ADD)
        jmp     _IC_ADD_LOOP
_IC_SUB_CHK:
        cmp     $tok_sub,       %rax
        jne     _IC_ADD_END
        call    _IC_NXT
        call    _IC_MUL
        write   $stdout, _EMIT_SUB, $(_EMIT_SUB.E - _EMIT_SUB)
        jmp     _IC_ADD_LOOP
_IC_ADD_END:
        ret
_IC_MUL:
        call    _IC_PRIMARY
_IC_MUL_LOOP:
        cmp     $tok_asterisk,  %rax
        jne     _IC_DIV_CHK
        call    _IC_NXT
        call    _IC_PRIMARY
        write   $stdout, _EMIT_MUL, $(_EMIT_MUL.E - _EMIT_MUL)
        jmp     _IC_MUL_LOOP
_IC_DIV_CHK:
        cmp     $tok_slash,     %rax
        jne     _IC_MOD_CHK
        call    _IC_NXT
        call    _IC_PRIMARY
        write   $stdout, _EMIT_DIV, $(_EMIT_DIV.E - _EMIT_DIV)
        jmp     _IC_MUL_LOOP
_IC_MOD_CHK:
        cmp     $tok_percent,   %rax
        jne     _IC_MUL_END
        call    _IC_NXT
        call    _IC_PRIMARY
        write   $stdout, _EMIT_MOD, $(_EMIT_MOD.E - _EMIT_MOD)
        jmp     _IC_MUL_LOOP
_IC_MUL_END:
        ret
_IC_PRIMARY:
        cmp     $tok_number,    %rax
        je      _IC_NUMBER
        cmp     $tok_lparen,    %rax
        je      _IC_LPAREN
        ret
_IC_LPAREN:
        call    _IC_NXT
_IC_LPAREN_LOOP:
        call    _IC_EXPR
        cmp     $tok_rparen, %rax
        jne     _IC_LPAREN_LOOP
        call    _IC_NXT
        ret
_IC_NUMBER:
        write   $stdout, _EMIT_PUSH, $(_EMIT_PUSH.E - _EMIT_PUSH)
        movq    %r15,   %rdi
        movq    $stdout,%r8
        call    _IC_PX
        write   $stdout, _NL, $1
        call    _IC_NXT
        ret
