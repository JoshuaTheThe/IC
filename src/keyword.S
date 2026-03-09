        # KEYWORD PARSING
_IC_KEY_LONG:
        call    _IC_NXT                     # get identifier → _ID
        movq    %r15,           %r13
        leaq    _IDP,           %rdi
        leaq    _ID,            %rsi
        movq    $32,            %rcx
        repe    movsb
        movq    %rax,           %r9         # save tok_identifier
        call    _IC_NXT                     # peek next
        cmp     $tok_lparen,    %rax
        je      _IC_KEY_LONG_FUN
        cmp     $tok_set,       %rax
        je      _IC_KEY_LONG_VAR
        jmp     _IC_PP

_IC_KEY_LONG_VAR:
        leaq    _IDP,           %rsi
        leaq    _ID,            %rdi
        movq    $32,            %rcx
        repe    movsb
        # allocate stack slot
        subq    $8,             _STKOFF
        movw    _STKOFF,        %r10w       # offset for sym create
        movb    $sym_var,       %r11b
        movw    $0,             %r9w
        call    _IC_SYM_CREATE
        # emit stack alloc
        write   $stdout, _EMIT_ALLOC, $(_EMIT_ALLOC.E - _EMIT_ALLOC)
        # parse initializer
        call    _IC_NXT
        call    _IC_EXPR
        # emit store to slot
        write   $stdout, _EMIT_POP_VAR, $(_EMIT_POP_VAR.E - _EMIT_POP_VAR)
        movswq  _STKOFF,        %rdi
        movq    $stdout,        %r8
        call    _IC_PX
        write   $stdout, _EMIT_RBP, $(_EMIT_RBP.E - _EMIT_RBP)
        ret

_IC_KEY_LONG_FUN:
        leaq    _IDP,           %rsi
        leaq    _ID,            %rdi
        movq    $32,            %rcx
        repe    movsb
        movw    _FUNCNT,        %r9w        # fn index
        movb    $sym_fun,       %r11b
        movw    $0,             %r10w       # no stack offset
        call    _IC_SYM_CREATE
        write   $stdout, _ID,       %r13    # name length
        write   $stdout, _EMIT_COLON, $(_EMIT_COLON.E - _EMIT_COLON)
        write   $stdout, _EMIT_PROLOGUE, $(_EMIT_PROLOGUE.E - _EMIT_PROLOGUE)
_IC_KEY_LONG_ARGS:
        call    _IC_NXT
        cmp     $tok_rparen,    %rax
        je      _IC_KEY_LONG_BODY
        cmp     $tok_identifier,%rax
        jne     _IC_PP
        movb    $sym_var,       %r11b
        movw    _ARGOFF,        %r10w
        movw    $0,             %r9w
        call    _IC_SYM_CREATE
        addw    $8,             _ARGOFF
        call    _IC_NXT                     # consume , or )
        cmp     $tok_end,       %rax
        je      _IC_KEY_LONG_ARGS
        cmp     $tok_rparen,    %rax
        je      _IC_KEY_LONG_BODY
        jmp     _IC_PP
_IC_KEY_LONG_BODY:
        call    _IC_NXT
        call    _IC_EXPR                    # body
        write   $stdout, _EMIT_EPILOGUE, $(_EMIT_EPILOGUE.E - _EMIT_EPILOGUE)
        incw    _FUNCNT
        movq    $0,             _STKOFF
        movw    $16,            _ARGOFF     # args start at rbp+16
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
        write   $stdout, _EMIT_EPILOGUE, $(_EMIT_EPILOGUE.E - _EMIT_EPILOGUE)
        ret
