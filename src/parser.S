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

        #       ELSE, ENTER ASSIGNMENT CHECK
        call    _IC_ASSIGNMENT
        ret
_IC_ASSIGNMENT:
        call    _IC_ADD
        ret
_IC_ADD:
        call    _IC_MUL
_IC_ADD_LOOP:
        cmp     $tok_add,       %rax
        jne     _IC_ADD_END
        call    _IC_NXT
        call    _IC_MUL
        write   $stdout, _EMIT_ADD, $(_EMIT_ADD.E - _EMIT_ADD)
        jmp     _IC_ADD_LOOP
_IC_ADD_END:
        ret
_IC_MUL:
        call    _IC_PRIMARY
_IC_MUL_LOOP:
        cmp     $tok_asterisk,       %rax
        jne     _IC_MUL_END
        call    _IC_NXT
        call    _IC_PRIMARY
        write   $stdout, _EMIT_MUL, $(_EMIT_MUL.E - _EMIT_MUL)
        jmp     _IC_MUL_LOOP
_IC_MUL_END:
        ret
_IC_PRIMARY:
        cmp     $tok_number,    %rax
        je      _IC_NUMBER
        ret
_IC_NUMBER:
        write   $stdout, _EMIT_PUSH, $(_EMIT_PUSH.E - _EMIT_PUSH)
        movq    %r15,   %rdi
        movq    $stdout,%r8
        call    _IC_PX
        write   $stdout, _NL, $1
        call    _IC_NXT
        ret
