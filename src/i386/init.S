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
        movl    tkpanic,%eax
        repe    stosl
        ret

