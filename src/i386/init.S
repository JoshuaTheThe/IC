        # ----- HEAD
        #       init/S
        #       services that provide initialisation
        #       for the compiler's state.
        # ----- SOURCE
init:   xorl    %ebp,   %ebp
        #       Initialise the token table
        xorl    %ecx,   %ecx
        decb    %cl
        leal    toktab, %edi
        #       Default is panic
        movl    $tkpanic, %eax
        repe    stosl
        #       48-57: digits -> tknumber handler
        leal    toktab+(48*4), %edi
        movl    $10,    %ecx
        movl    $tknumber, %eax
        repe    stosl
        #       65-90: uppercase -> tkident handler
        leal    toktab+(65*4), %edi
        movl    $26,    %ecx
        movl    $tkident, %eax
        repe    stosl
        #       Symbols
        movl    $tkeof,   toktab+(0)
        movl    $tkplus,  toktab+('+' * 4)
        movl    $tksubt,  toktab+('-' * 4)
        movl    $tkaste,  toktab+('*' * 4)
        movl    $tkslas,  toktab+('/' * 4)
        movl    $tkampe,  toktab+('&' * 4)
        movl    $tkperc,  toktab+('%' * 4)
        movl    $tkcare,  toktab+('^' * 4)
        movl    $tkpipe,  toktab+('|' * 4)
        movl    $tkbang,  toktab+('!' * 4)
        movl    $tkless,  toktab+('<' * 4)
        movl    $tkgrea,  toktab+('>' * 4)
        movl    $tkequa,  toktab+('=' * 4)
        movl    $tkassi,  toktab+(':' * 4)
        movl    $tkbegi,  toktab+('(' * 4)
        movl    $tkbegi,  toktab+('{' * 4)
        movl    $tkend,   toktab+(')' * 4)
        movl    $tkend,   toktab+('}' * 4)
        ret

