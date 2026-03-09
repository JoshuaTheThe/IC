        # KEYWORD PARSING
_IC_KEY_LONG:
        call    _IC_NXT
        ret
_IC_KEY_IF:
        call    _IC_NXT
        ret
_IC_KEY_WHILE:
        call    _IC_NXT
        ret
_IC_KEY_RETURN:
        call    _IC_NXT
        call    _IC_EXPR
        write   $stdout, _EMIT_RET, $(_EMIT_RET.E - _EMIT_RET)
        ret
