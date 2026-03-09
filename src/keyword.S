        # KEYWORD PARSING
_IC_KEY_LONG:
        #       TODO - IF IDENTIFIER FOLLOWED BY LPAREN, IS FUNCTION
        #       TODO - SYMBOL TABLE
        call    _IC_NXT
        ret
_IC_KEY_IF:
        call    _IC_NXT
        call    _IC_EXPR
        # emit test + jz LELSE_N
        call    _IC_EXPR
        # emit jmp LDONE_N
        # emit LELSE_N:
        call    _IC_EXPR
        # emit LDONE_N:
        ret

_IC_KEY_WHILE:
        # emit LWHILE_N:
        call    _IC_NXT
        call    _IC_EXPR
        # emit test + jz LWDONE_N
        call    _IC_EXPR
        # emit jmp LWHILE_N
        # emit LWDONE_N:
        ret
_IC_KEY_RETURN:
        call    _IC_NXT
        call    _IC_EXPR
        write   $stdout, _EMIT_RET, $(_EMIT_RET.E - _EMIT_RET)
        ret
