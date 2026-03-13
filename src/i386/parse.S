        # ----- HEAD
        #       parse/S
        #       Parse a given expression list or expression.
        # ----- SOURCE
        #       Must have a token already
pexpr:  cmpb    $token_kw_long,    %al
        je      plong
        cmpb    $token_kw_if,      %al
        je      pif
        cmpb    $token_kw_while,   %al
        je      pwhile
        cmpb    $token_kw_ret,     %al
        je      preturn
        cmpb    $token_kw_asm,     %al
        je      pasm
        call    por
        ret
        #       | (binary)
por:    call    pxor
1:      cmpb    $token_sym_pipe,  %al
        jne     2f
        call    pxor
        #       TODO - emit or
        jmp     1b
2:      ret
        #       ^ (binary)
pxor:   call    pand
1:      cmpb    $token_sym_care,  %al
        jne     2f
        call    pand
        #       TODO - emit xor
        jmp     1b
2:      ret
        #       & (binary)
pand:   call    padd
1:      cmpb    $token_sym_ampe,  %al
        jne     2f
        call    padd
        #       TODO - emit and
        jmp     1b
2:      ret
        #       +,- (binary)
padd:   call    pmul
1:      pushl   %eax
        cmpb    $token_sym_plus,  %al
        je      2f
        cmpb    $token_sym_subt,  %al
        jne     3f
2:      call    pmul
        #       TODO - emit add/sub
        popl    %eax
        jmp     1b
3:      ret
        #       *,/,% (binary)
pmul:   call    punary
1:      pushl   %eax
        cmpb    $token_sym_aste,  %al
        je      2f
        cmpb    $token_sym_slas,  %al
        je      2f
        cmpb    $token_sym_perc,  %al
        jne     3f
2:      call    punary
        #       TODO - emit mul/div/mod
        popl    %eax
        jmp     1b
3:      ret

        #       TODO
punary: call    pprim
        ret

        #       (..),[0-9][0-9]*,[A-Z][A-Z]*
pprim:  cmpb    $token_sym_begi,   %al
        je      pbegin
        cmpb    $token_number,  %al
        je      pnumber
        cmpb    $token_identifier,%al
        #       TODO
        je      hang
hang:   jmp     hang
pbegin: call    next
1:      call    pexpr
        cmpb    $token_sym_end,     %al
        jne     1b
        call    next
        ret
pnumber:movl    $1,     %ebx
        leal    dpush,  %ecx
        movl    $6,     %edx
        call    fdprint
        movl    number, %ecx
        call    fdprinx
        call    fdln
        ret
