        # TOKENISER FUNCTIONS
        .equ    tok_ignore,0
        .equ    tok_number,1
        .equ    tok_identifier,2
        .equ    tok_lparen,3
        .equ    tok_rparen,4
        .equ    tok_end,5 # ,
        .equ    tok_add,6
        .equ    tok_sub,7
        .equ    tok_asterisk,8
        .equ    tok_slash,9
        .equ    tok_percent,10
        .equ    tok_amp,11
        .equ    tok_caret,12
        .equ    tok_pipe,13
        .equ    tok_bang,14
        .equ    tok_lt,15
        .equ    tok_gt,16
        .equ    tok_eq,17
        .equ    tok_set,18
        
        .equ    tok_kw_long,19
        .equ    tok_kw_if,20
        .equ    tok_kw_while,21
        .equ    tok_kw_return,22

_IC_SYM_AD: return $tok_add
_IC_SYM_SU: return $tok_sub
_IC_SYM_AS: return $tok_asterisk
_IC_SYM_SL: return $tok_slash
_IC_SYM_PE: return $tok_percent
_IC_SYM_AM: return $tok_amp
_IC_SYM_CA: return $tok_caret
_IC_SYM_PI: return $tok_pipe
_IC_SYM_BA: return $tok_bang
_IC_SYM_LT: return $tok_lt
_IC_SYM_GT: return $tok_gt
_IC_SYM_EQ: return $tok_eq
_IC_SYM_SE: return $tok_set
_IC_SYM_LP: return $tok_lparen
_IC_SYM_RP: return $tok_rparen
_IC_SYM_EN: return $tok_end

        # IF al is ord(NUMBER), SET carry=FALSE ELSE carry=TRUE
_IC_IN: cmpb    $48,    %al
        rccsc   l
        cmpb    $57,    %al
        rccsc   g
        ret
_IC_II: cmpb    $65,    %al
        rccsc   l
        cmpb    $90,    %al
        rccsc   g
        ret
        # Whitespace (' ', '\n', '\r', '\a', '\t')
_IC_W:  return  $tok_ignore
        # Number, read while its a number
_IC_N:  unget
        xorq    %r15,   %r15
_IC_NL: call    _IC_R
        bc      e,_IC_NX, %rax
        # Fetch Char
        xorl    %eax,   %eax
        movb    _DC,    %al
        # Is Number
        call    _IC_IN
        # If non number, exit
        bc      c,_IC_NX
        # Otherwise, accumulate in R11
        movq    $10,    %rbx
        imulq   %rbx,   %r15
        subb    $48,    %al
        addq    %rax,   %r15
        jmp     _IC_NL
_IC_NX: unget
        return $tok_number
_IC_ID: unget
        xorq    %r15,   %r15    # LENGTH
_IC_IL: call    _IC_R
        bc      e,_IC_IDX, %rax
        # Fetch Char
        xorl    %eax,   %eax
        movb    _DC,    %al
        # Is Identifier
        call    _IC_II
        # If non number, exit
        bc      c,_IC_IDX
        # Accumulate
        movb    %al,    _ID(%r15)
        incb    %r15b
        cmpb    $31,   %r15b
        jb      _IC_IL
_IC_IDX:unget
        # You could probably roll this into a loop
        # oh well
        # COMPARE WITH KEYWORDS
        cmpq    $4,     %r15
        jne     .M0
        leaq    _ID,    %rdi
        leaq    _KLONG, %rsi
        xorl    %ecx,   %ecx
        movb    $4,     %cl
        repe    cmpsb
        retucc z,$tok_kw_long
.M0:    # EARLY NEXT
        cmpq    $2,     %r15
        jne     .M1
        leaq    _ID,    %rdi
        leaq    _KIF,   %rsi
        xorl    %ecx,   %ecx
        movb    $2,     %cl
        repe    cmpsb
        retucc z,$tok_kw_if
.M1:    # EARLY NEXT
        cmpq    $5,     %r15
        jne     .M2
        leaq    _ID,    %rdi
        leaq    _KWHILE,   %rsi
        xorl    %ecx,   %ecx
        movb    $5,     %cl
        repe    cmpsb
        retucc z,$tok_kw_while
.M2:    # EARLY NEXT
        cmpq    $6,     %r15
        jne     .M3
        leaq    _ID,    %rdi
        leaq    _KRETUR,   %rsi
        xorl    %ecx,   %ecx
        movb    $6,     %cl
        repe    cmpsb
        retucc z,$tok_kw_return
.M3:    # EARLY NEXT
        return $tok_identifier

_IC_NXT:
        leaq    _ID,    %rdi
        movq    $32,    %rcx
        xorl    %eax,   %eax
        repe    stosb
        xorq    %r15,   %r15
        cmpq    $0, (_SZ)
        jle     _IC_X
        call    _IC_R
        shlq    $3,     %rax
        call    *_FNT(%rax)
        testq   %rax,   %rax        # tok_ignore = 0
        je      _IC_NXT             # skip whitespace transparently
        call    _IC_DBG
        ret
