        # ----- HEAD
        #       token_keynum.S
        #       tokenise numbers, keywords and identifiers
        # ----- SOURCE
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
2:      movl    %esi,             number
        #       Debug
        movl    $2,               %ebx
        call    fddbg
        movl    $token_number,    %eax
        ret
tkident:call    unget
        #       Clear identifier
        leal    ident,            %edi
        movl    $max_identifier,  %ecx
        xorl    %eax,             %eax
        repe    stosb
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
2:      movl    $max_identifier,  %eax
        subl    %ecx,             %eax
        movl    %eax,             identlen
        movl    $token_identifier,%eax
        movl    $2,               %ebx
        call    fddbg
        leal    ident,            %ecx
        movl    identlen,         %edx
        call    fdprintln
        ret
