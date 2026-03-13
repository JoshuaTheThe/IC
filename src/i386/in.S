        # ----- HEAD
        #       in/S
        #       input services
        # ----- SOURCE
        #       handle resolving of a character.
        .equ    MAX_SIZE,(65536)
        #       Grab a single character
get:    xorl    %eax,     %eax
        movb    filedata(%ebp), %al
        inc     %ebp
        ret
        #       Trace back by one character
unget:  xorl    %eax,     %eax
        dec     %ebp
        movb    filedata(%ebp), %al
        ret
        #       Load the file
loadfil:xorl    %eax,     %eax
        movb    $0x03,    %al     # Read
        xorl    %ebx,     %ebx    # FD/0=stdin
        leal    filedata, %ecx    # buffer
        movl    $MAX_SIZE,%edx  # max bytes to read
        int     $0x80
        ret
        #       Save the token's position
save:   movl    %ebp,   saved
        ret
        #       Load the saved token's positions
load:   movl    saved,    %ebp
        ret

