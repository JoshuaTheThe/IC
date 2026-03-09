        # SYMBOL TABLE MANAGER
.equ sym_var,   0
.equ sym_fun,   1

.equ sym_name,  0       # +0,  31 bytes
.equ sym_info,  31      # +31, 1 byte
.equ sym_off,   32      # +32, 2 bytes
.equ sym_fnidx, 34      # +34, 2 bytes

_IC_SYM_CREATE:
        movq    _SYMCNT,        %rdx
        shlq    $6,             %rdx
        leaq    _SYMTABLE(%rdx),%rdi
        leaq    _ID,            %rsi
        movq    $31,            %rcx
        repe    movsb                       # name
        movb    %r11b,          (%rdi)      # info
        movw    %r10w,          1(%rdi)     # offset
        movw    %r9w,           3(%rdi)     # fn index
        incq    _SYMCNT
        ret

_IC_SYM_LOOKUP:
        xorq    %rcx,   %rcx
.LSL:   cmpq    _SYMCNT,        %rcx
        je      _IC_PP
        movq    %rcx,   %rdx
        shlq    $6,     %rdx
        leaq    _SYMTABLE(%rdx),%rdi
        leaq    _ID,    %rsi
        movq    $31,    %r9
        repe    cmpsb
        je      .LSLFOUND
        incq    %rcx
        jmp     .LSL
.LSLFOUND:
        leaq    _SYMTABLE(%rdx),%rax
        ret
