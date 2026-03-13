        # ----- HEAD
        #       token_sym/S
        # ----- SOURCE
tkeof:  movl    $token_eof, %eax
        ret
tkend:
        movl    $token_sym_end,%eax
        ret
tkbegi:
        movl    $token_sym_begi,%eax
        ret
tkplus:
        movl    $token_sym_plus,%eax
        ret
tksubt:
        movl    $token_sym_subt,%eax
        ret
tkaste:
        movl    $token_sym_aste,%eax
        ret
tkslas:
        movl    $token_sym_slas,%eax
        ret
tkampe:
        movl    $token_sym_ampe,%eax
        ret
tkperc:
        movl    $token_sym_perc,%eax
        ret
tkcare:
        movl    $token_sym_care,%eax
        ret
tkpipe:
        movl    $token_sym_pipe,%eax
        ret
tkbang:
        movl    $token_sym_bang,%eax
        ret
tkless:
        movl    $token_sym_less,%eax
        ret
tkgrea:
        movl    $token_sym_grea,%eax
        ret
tkequa:
        movl    $token_sym_equa,%eax
        ret
tkassi:
        movl    $token_sym_assi,%eax
        ret

