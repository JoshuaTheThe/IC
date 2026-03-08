# I
- a tiny programming language

## Notice
- comma and semi colon are aliases of eachother, use whichever you want

## Keywords
- LONG, IF, WHILE, RETURN

## Symbols
- to decide whether to call or not is whether the symbol is a function or variable
  - this does make function pointers not default, prefix with `&` to get address

```c
LONG X = 42,
LONG Y = X + 7, // one at a time
LONG ADD(A, B)( A + B, ),
LONG MAIN()(ADD(1,2)),

LONG P = &X;
LONG V = *P;
*P = 99;

IF(X == Y, then_expr, else_expr)
WHILE(C, B)
X + Y * (Z - 2)
!(X)        // logical not — nonzero becomes 0, zero becomes 1
&X  *X      // address-of, dereference
```

**Everything is an expression. Statements are expressions followed by `;`.**

---

## Compiler Architecture

Single-pass, no AST, no IR. Three phases sharing one linear read cursor:
```
[lexer] → token stream → [pratt parser + codegen] → asm text → stdout
```

Written in x86-64 Linux assembly. Output is GAS syntax piped to stdout, assembled externally with `cc` or `as`.

## Operators
| sym | fn |
|-----|----|
| `+` | add |
| `-` | subtract |
| `*` | multiply or dereference |
| `/` | divide |
| `%` | modulo |
| `&` | bitwise and or load effective address |
| `^` | bitwise xor |
| `\|` | bitwise or |
| `!` | unary logical not |
| `<` | less than |
| `>` | greater than |
| `==` | equal to |
| `=` | assign to |

## Why?
- Because assembly is fun!!
