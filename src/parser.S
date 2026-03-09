        .include "keyword.S"
_IC_EXPR:
        #       EQUIVILENT TO STATEMENT
        cmp     $tok_end,       %rax
        je      _IC_EXPR_DONE
        cmp     $tok_kw_long,   %rax
        je      _IC_KEY_LONG
        cmp     $tok_kw_if,   %rax
        je      _IC_KEY_IF
        cmp     $tok_kw_while,   %rax
        je      _IC_KEY_WHILE
        cmp     $tok_kw_return,   %rax
        je      _IC_KEY_RETURN
        call    _IC_OR
_IC_EXPR_DONE:
        ret
_IC_OR:
        call    _IC_XOR
_IC_OR_LOOP:
        cmp     $tok_pipe,      %rax
        jne     _IC_OR_END
        call    _IC_NXT
        call    _IC_XOR
        emit_binop _EMIT_ORQ
        jmp     _IC_OR_LOOP
_IC_OR_END:
        ret
_IC_XOR:
        call    _IC_AND
_IC_XOR_LOOP:
        cmp     $tok_caret,     %rax
        jne     _IC_XOR_END
        call    _IC_NXT
        call    _IC_AND
        emit_binop _EMIT_XORQ
        jmp     _IC_XOR_LOOP
_IC_XOR_END:
        ret
_IC_AND:
        call    _IC_ADD
_IC_AND_LOOP:
        cmp     $tok_amp,       %rax
        jne     _IC_AND_END
        call    _IC_NXT
        call    _IC_ADD
        emit_binop _EMIT_ANDQ
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
        emit_binop _EMIT_ADDQ
        jmp     _IC_ADD_LOOP
_IC_SUB_CHK:
        cmp     $tok_sub,       %rax
        jne     _IC_ADD_END
        call    _IC_NXT
        call    _IC_MUL
        emit_binop _EMIT_SUBQ
        jmp     _IC_ADD_LOOP
_IC_ADD_END:
        ret
_IC_MUL:
        call    _IC_UNARY
_IC_MUL_LOOP:
        cmp     $tok_asterisk,  %rax
        jne     _IC_DIV_CHK
        call    _IC_NXT
        call    _IC_UNARY
        emit_binop _EMIT_IMULQ
        jmp     _IC_MUL_LOOP
_IC_DIV_CHK:
        cmp     $tok_slash,     %rax
        jne     _IC_MOD_CHK
        call    _IC_NXT
        call    _IC_UNARY
        emit_binop _EMIT_IDIVQ
        jmp     _IC_MUL_LOOP
_IC_MOD_CHK:
        cmp     $tok_percent,   %rax
        jne     _IC_MUL_END
        call    _IC_NXT
        call    _IC_UNARY
        emit_binop _EMIT_MODQ
        jmp     _IC_MUL_LOOP
_IC_MUL_END:
        ret
_IC_UNARY:
_IC_UNARY_LOOP:
        cmp     $tok_asterisk,  %rax
        jne     _IC_ADDR_CHK
        call    _IC_NXT
        call    _IC_PRIMARY
        write   $stdout, _EMIT_DEREF, $(_EMIT_DEREF.E - _EMIT_DEREF)
        ret
_IC_ADDR_CHK:
        cmp     $tok_amp,  %rax
        jne     _IC_UNARY_END
        call    _IC_NXT
        movq    $tok_identifier, %rdi
        call    _IC_REQUIRE
        #       TODO! FIND ADDRESS
        ret
_IC_UNARY_END:
        call    _IC_PRIMARY
        ret
_IC_PRIMARY:
        cmp     $tok_number,    %rax
        je      _IC_NUMBER
        cmp     $tok_lparen,    %rax
        je      _IC_LPAREN
        cmp     $tok_identifier,%rax
        je      _IC_IDENTIFIER
        ret
_IC_IDENTIFIER:
        call    _IC_SYM_LOOKUP
        movb    sym_info(%rax), %r11b
        movswq  sym_off(%rax),  %r10
        call    _IC_NXT
        cmp     $tok_set,       %rax
        je      _IC_ASSIGN
        cmp     $tok_lparen,    %rax
        je      _IC_CALL
        write   $stdout, _EMIT_PUSH_VAR, $(_EMIT_PUSH_VAR.E - _EMIT_PUSH_VAR)
        movq    %r10,   %rdi
        call    _IC_PX
        write   $stdout, _EMIT_RBP, $(_EMIT_RBP.E - _EMIT_RBP)
        ret

_IC_ASSIGN:
        call    _IC_NXT
        call    _IC_EXPR
        write   $stdout, _EMIT_POP_VAR, $(_EMIT_POP_VAR.E - _EMIT_POP_VAR)
        movq    %r10,   %rdi
        call    _IC_PX
        write   $stdout, _EMIT_RBP, $(_EMIT_RBP.E - _EMIT_RBP)
        ret

_IC_CALL:
        xorq    %r9,    %r9
_IC_CALL_LOOP:
        call    _IC_NXT
        cmp     $tok_rparen,    %rax
        je      _IC_CALL_DONE
        call    _IC_EXPR
        incq    %r9
        cmp     $tok_end,       %rax
        je      _IC_CALL_LOOP
_IC_CALL_DONE:
        write   $stdout, _EMIT_CALL, $(_EMIT_CALL.E - _EMIT_CALL)
        write   $stdout, _ID, %r11
        write   $stdout, _NL, $1
        call    _IC_NXT
        ret
_IC_LPAREN:
_IC_LPAREN_LOOP:
        call    _IC_NXT
        call    _IC_EXPR
        cmp     $tok_end,       %rax
        je      _IC_LPAREN_LOOP
        cmp     $tok_rparen,    %rax
        je      _IC_LPAREN_DONE
        jmp     _IC_P
_IC_LPAREN_DONE:
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
