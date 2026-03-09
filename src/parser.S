        .include "keyword.S"
_IC_EXPR:
        #       EQUIVILENT TO STATEMENT
        call    _IC_NXT
        cmp     $tok_kw_long,   %rax
        je      _IC_KEY_LONG
        cmp     $tok_kw_if,   %rax
        je      _IC_KEY_IF
        cmp     $tok_kw_while,   %rax
        je      _IC_KEY_WHILE
        cmp     $tok_kw_return,   %rax
        je      _IC_KEY_RETURN
        ret
