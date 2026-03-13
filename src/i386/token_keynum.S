        # ----- HEAD
        #       token_keynum.S
        #       tokenise numbers, keywords and identifiers
        # ----- SOURCE
        .equ    kw_LONG, 0x474e4f4c    # 'G','N','O','L'
        .equ    kw_IF,   0x00004649    # 0,0,'F','I'
        .equ    kw_WHIL, 0x4c494857    # 'L','I','H','W'
        .equ    kw_RETU, 0x55544552    # 'U','T','E','R'
        .equ    kw_ASM,  0x004d5341    # 0,'M','S','A'
tknumber:
        call    unget
        movl    $0,               number
        xorl    %edx,             %edx
        xorl    %esi,             %esi
        #       Grab number
1:      call    get
        cmpb    $'0',             %al
        jl      2f
        cmpb    $'9',             %al
        jg      2f
        subb    $'0',             %al
        xchgl   %eax,             %esi
        mull    constant10
        xchgl   %eax,             %esi
        addl    %eax,             %esi
        jmp     1b
2:      call    unget
        movl    %esi,             number
        movl    $token_number,    %eax
        ret
tkident:call    unget
        #       Grab identifier
        leal    ident,            %edi
        movl    $max_identifier,  %ecx
1:      call    get
        cmpb    $'A',             %al
        jl      2f
        cmpb    $'Z',             %al
        jg      2f
        stosb
        loop    1b
2:      #       >max_identifier, grab and ignore
        call    get
        cmpb    $'A',             %al
        jl      4f
        cmpb    $'Z',             %al
        jg      4f
        jmp     2b
4:      call    unget
3:      movl    $max_identifier,  %eax
        subl    %ecx,             %eax
        movl    %eax,             identlen
        cmpl    $kw_LONG,         ident
        je      kwlong
        cmpl    $kw_IF,           ident
        je      kwif
        cmpl    $kw_WHIL,         ident
        je      kwwhil
        cmpl    $kw_RETU,         ident
        je      kwretu
        cmpl    $kw_ASM,          ident
        je      kwasm
        movl    $token_identifier,%eax
        ret
kwlong: movl    $token_kw_long, %eax
        ret
kwif:   movl    $token_kw_if,   %eax
        ret
kwwhil: movl    $token_kw_while,%eax
        ret
kwretu: movl    $token_kw_ret,  %eax
        ret
kwasm:  movl    $token_kw_asm,  %eax
        ret
