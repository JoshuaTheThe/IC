        # ----- HEAD
        #       bss/S
        #       all non constant data is
        #       not included in the binary
        # ----- SOURCE
        .section .bss
bss:    #       ALL FILE DATA
filedata:.space  MAX_SIZE
        #       CURRENT SAVED INDEX
index:   .space  4
saved:   .space  4
        #       The function table used for tokenisation
        #       256 possible values, sizeof(uintptr_t) == 4
toktab:  .space  4 * 256
