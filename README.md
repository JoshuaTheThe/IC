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

LONG p = &x;
LONG v = *p;
*p = 99;

// if — expression, evaluates to branch taken (0 if cond false, no else given)
IF(!(x - y), then_expr, else_expr)

// while — expression, evaluates to last body value, 0 if never entered
WHILE(cond, body)

// PEMDAS arithmetic + unary
x + y * (z - 2)
!(x)        // logical not — nonzero becomes 0, zero becomes 1
&x  *x      // address-of, dereference
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
