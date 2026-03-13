        # ----- HEAD
        #       begin/S
        #       the mainloop of the compiler, calling the parser untill EOF.
        # ----- SOURCE
begin:  call    next
        cmpl    filesize, %ebp
        jl      begin
        ret

