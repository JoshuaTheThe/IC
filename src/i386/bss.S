        # ----- HEAD
        #       bss/S
        #       all non constant data is
        #       not included in the binary
        # ----- SOURCE
        .section .bss
bss:    #       ALL FILE DATA
filedata:.space  MAX_SIZE
filesize:.space  4
        #       CURRENT SAVED INDEX
index:   .space  4
saved:   .space  4
        #       The function table used for tokenisation
        #       256 possible values, sizeof(uintptr_t) == 4
toktab:  .space  4 * 256
ident:   .space  max_identifier
identlen:.space  4
number:  .space  4
