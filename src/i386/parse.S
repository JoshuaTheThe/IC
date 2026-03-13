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
        call    next
        call    pxor
        #       TODO - emit or
        jmp     1b
2:      ret
        #       ^ (binary)
pxor:   call    pand
1:      cmpb    $token_sym_care,  %al
        jne     2f
        call    next
        call    pand
        #       TODO - emit xor
        jmp     1b
2:      ret
        #       & (binary)
pand:   call    padd
1:      cmpb    $token_sym_ampe,  %al
        jne     2f
        call    next
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
2:      call    next
        call    pmul
        #       TODO - emit add/sub
        popl    %ebx
        leal    dbinpre,   %ecx
        movl    $19,    %edx
        call    println
        cmpb    $token_sym_plus,  %bl
        jne     4f
        leal    dadd,   %ecx
        movl    $14,    %edx
        call    println
        jmp     5f
4:
5:      leal    dpusha, %ecx
        movl    $10,    %edx
        call    println
        jmp     1b
3:      popl    %ebx
        ret
        #       *,/,% (binary)
pmul:   call    punary
1:      pushl   %eax
        cmpb    $token_sym_aste,  %al
        je      2f
        cmpb    $token_sym_slas,  %al
        je      2f
        cmpb    $token_sym_perc,  %al
        jne     3f
2:      call    next
        call    punary
        #       TODO - emit mul/div/mod
        popl    %ebx
        jmp     1b
3:      popl    %ebx
        ret
        #       TODO
punary: call    pprim
        ret

        #       (..),[0-9][0-9]*,[A-Z][A-Z]*
pprim:  cmpl    $token_sym_begi,   %eax
        je      pbegin
        cmpl    $token_number,  %eax
        je      pnumber
        #cmpl    $token_identifier,%eax
        #       TODO
        #je      hang
        ret
hang:   jmp     hang
pnumber:movl    $1,     %ebx
        leal    dpush,  %ecx
        movl    $6,     %edx
        call    fdprint
        leal    dimm,  %ecx
        movl    $3,     %edx
        call    fdprint
        movl    number, %ecx
        call    fdprinx
        call    fdln
        call    next
        ret
pbegin: call    next
1:      cmpb    $token_sym_end, %al
        je      2f
        cmpb    $token_eof,     %al
        je      3f
        call    pexpr
        jmp     1b
2:      call    next
        ret
3:      jmp     tkpanic
