# TODO
[ ] variables/functions
[x] unary, &,*
[x] move assignment to be a suffix
[ ] symbol table — hash, insert, lookup
[ ] function prologue/epilogue — frame setup, arg mapping
[ ] LONG variable declaration — alloc stack slot, register symbol
[ ] LONG function declaration — emit label, prologue, parse body
[ ] identifier in expression — lookup symbol, emit load
[ ] assignment suffix — X : EXPR emits store to symbol's slot
[ ] IF codegen — label counter, test+jz, jmp, labels
[ ] WHILE codegen — label counter, loop label, test+jz, jmp
[ ] comparison operators — < > = emit cmp+setX+push
[ ] function call — lookup symbol, emit args, emit call
[ ] & addr-of — emit lea of symbol's slot
[ ] * dereference — emit movq (%rax)
[ ] ! logical not — emit testq+setz+movzx
[ ] main entry point — emit _start, call MAIN, exit with result
[ ] output file header — emit .global, .section .text preamble