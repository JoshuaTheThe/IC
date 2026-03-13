        # ----- HEAD
        #       token/S
        # ----- SOURCE
        .equ    token_eof,0
        .equ    token_number,1
        .equ    token_identifier,2
        .equ    token_kw_long,3         # LONG
        .equ    token_kw_if,4           # IF
        .equ    token_kw_while,5        # WHILE (actual=WHIL)
        .equ    token_kw_asm,6          # ASM
        .equ    token_kw_ret,7          # RETURN (actual=RETU)
        .equ    token_sym_plus,8        # +
        .equ    token_sym_subt,9        # -
        .equ    token_sym_aste,10       # *
        .equ    token_sym_slas,11       # /
        .equ    token_sym_ampe,12       # &
        .equ    token_sym_perc,13       # %
        .equ    token_sym_care,14       # ^
        .equ    token_sym_pipe,15       # |
        .equ    token_sym_bang,16       # !
        .equ    token_sym_less,17       # <
        .equ    token_sym_grea,18       # >
        .equ    token_sym_equa,19       # =
        .equ    token_sym_assi,20       # :
        .equ    token_sym_begi,21       # (
        .equ    token_sym_end,22        # )
        #       maximum length that is stored / distinguished
        #       this is so we can test with one comparison.
        #       that being cmpl %rs,    %rd
        .equ    max_identifier,4        
        #       grab next token
next:   call    get
        #       distpatch to function table
        call   *toktab(,%eax,4)
        ret
        #       TODO!
tkpanic:ret
