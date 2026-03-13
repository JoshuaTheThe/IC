        # ----- HEAD
        #       begin/S
        #       the mainloop of the compiler, calling the parser untill EOF.
        # ----- SOURCE
begin:  call    next
1:      cmpb    $token_eof,     %al
        je      2f
        call    pexpr
        cmpl    filesize,       %ebp
        jl      1b
2:      ret

