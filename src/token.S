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

_IC_LP: return $tok_lparen
_IC_RP: return $tok_rparen
_IC_EN: return $tok_end

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
_IC_W:  return $tok_ignore
        # Number, read while its a number
_IC_N:  unget
        xorq    %r11,   %r11
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
        imulq   %rbx,   %r11
        subb    $48,    %al
        addq    %rax,   %r11
        jmp     _IC_NL
_IC_NX: unget
        return $tok_number
_IC_ID: unget
        xorq    %r11,   %r11    # LENGTH
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
        movb    %al,    _ID(%r11)
        incb    %r11b
        cmpb    $254,   %r11b
        jb      _IC_IL
_IC_IDX:unget
        return $tok_identifier
