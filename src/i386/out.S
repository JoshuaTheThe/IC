        # ----- HEAD
        #       out/S
        #       output and debugging services
        # ----- SOURCE
        #       fddbg(fd=%ebx)
fddbg:  pushal
        movl    %esp,   %esi
        addl    $28,    %esi
        pushl   $8
        leal    nameeax,%ecx
1:      xorl    %edx,   %edx
        movb    $5,     %dl
        call    fdprint
        #       Print contents of register
        pushl   %ecx
        movl    (%esi), %ecx
        call    fdprinx
        popl    %ecx
        #       NL
        pushl   %ecx
        leal    newline,%ecx
        movb    $1,     %dl
        call    fdprint
        popl    %ecx
        subl    $4,     %esi
        addl    $5,     %ecx
        decl    (%esp)
        jnz     1b
        popl    %edx
        popal
        ret
fdprint:pushl   %eax
        xorl    %eax,   %eax
        movb    $0x4,   %al
        int     $0x80
        popl    %eax
        ret
fdprintln:
        call    fdprint
fdln:
        leal    newline,%ecx
        movl    $1,     %edx
        call    fdprint
        ret
        #       fdprinx(fd=%ebx, num=%ecx)
fdprinx:pushl   %eax
        pushl   %edx
        pushl   %ecx
        pushl   $8
2:      roll    $0x04,  %ecx
        movb    %cl,    %al
        andb    $0x0F,  %al
        #       translate to char
        movb    hextabl(%eax),%al
        #       print
        pushl   %ecx
        pushl   %eax
        leal    (%esp), %ecx
        movl    $1,     %edx
        call    fdprint
        popl    %ecx
        popl    %ecx
        decl    (%esp)
        jnz     2b
        popl    %edx
        popl    %ecx
        popl    %edx
        popl    %eax
        ret
        #       print(buf=%ecx,cnt=%edx)
print:  pushl   %ebx
        xorl    %ebx,   %ebx
        movb    $0x1,   %bl
        call    fdprint
        popl    %ebx
        ret
println:pushal
        call    print
ln:     leal    newline,%ecx
        movl    $1,     %edx
        movl    $1,     %ebx
        call    fdprint
        popal
        ret
        #       error(buf=%ecx,cnt=%edx)
error:  pushl   %ebx
        xorl    %ebx,   %ebx
        movb    $0x2,   %bl
        call    fdprint
        popl    %ebx
        ret

