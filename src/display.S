        # DISPLAY/S
        # DISPLAY LIBRARY, TO PRINT NUMBERS AND STRINGS TO THE CONSOLE

        # Panic
_IC_P:  write   $stdout, (_S0), $(_S0E-_S0)
_IC_PH: return  %rax

        # Print Integer
_IC_PI: ret
