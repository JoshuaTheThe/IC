        # ----- HEAD
        #       token_keynum.S
        #       tokenise numbers, keywords and identifiers
        # ----- SOURCE
tknumber:
        call    unget
        movl    $token_number, %eax
        ret
tkident:
        call    unget
        movl    $token_identifier, %eax
        ret
