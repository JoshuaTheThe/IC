        # ----- HEAD
        #       begin/S
        #       the mainloop of the compiler, calling the parser untill EOF.
        # ----- SOURCE
begin:  call    next
1:      call    pexpr
        cmpl    filesize,       %ebp
        jl      1b
        ret

