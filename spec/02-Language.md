# Language

The KTex markup language is used to prepare document. A document is built from a
sequence of blocks, which are built using operators.

The source text of a KTex document must be a sequence of {SourceCharacter}s.
These characters must be described by a sequence of {Token} lexical grammars.
The lexical token sequence, omitting {Ignored}, must be described by a single
{Document} syntactic grammar.

**Lexical Analysis and Syntax Parse**

The source text of a KTex document is first converted into a sequence of lexical
tokens, {Token}, and ignored tokens, {Ignored}. This sequence of lexical tokens
are then scanned from left to right to produce an abstract syntax tree (AST)
according to the {Document} syntactical grammar.

In this document, lexical grammar productions employ lookahead restrictions to
eliminate ambiguity and guarantee a singular, valid lexical analysis. Moreover,
the production of lexical grammar is influenced by the value of these two flags:

- `isLineStart`: a `Boolean` flag set to `true` at the beginning of a new line.
  This property remains active until a non-whitespace character is encountered.
- `isOperator`: a `Boolean` flag set to `true` only within an "operator context"
  (explained later).

## Source Text

SourceCharacter :: "Any UTF-8 character"

KTex documents are derived from a source text, composed of a sequence of
{SourceCharacter}s. Each {SourceCharacter} represents a UTF-8 character, which
is informally referred to as a "_character_" throughout this specification.

### Ignored Tokens

Ignored ::

- UnicodeBOM
- Comment

UnicodeBOM :: "Byte Order Mark (0xFEFF)"

### Comment

Comment :: [if isLineStart] `%` CommentCharacter\* [lookahead !=
CommentCharacter]

CommentCharacter :: SourceCharacter but not LineTerminator

In KTex source documents, a line can be converted into a comment by placing a
{`%`} marker at the beginning of the line. It's important to note that leading
whitespace characters before the {`%`} marker do not influence the comment.
However, if the {`%`} marker is preceded by any number of non-whitespace
characters, then the {`%`} marker and the remainder of the line are treated as
regular text.

### Lexical Tokens

Token ::

- WhiteSpace
- LineTerminator
- Punctuator
- OperatorName
- Punctuation
- Word
- Name
- IntValue
- FloatValue
- StringValue

Tokens are later used as terminal symbols in KTex syntactic grammars.

### White Space

WhiteSpace :: WhiteSpaceChar+ [lookahead != WhiteSpaceChar]

WhiteSpaceChar ::

- "Horizontal Tab (0x09)"
- "Space (0x20)"

White space is utilized to separate {Word}s and {Token}s, enhancing the
readability of the source text. While white space characters generally do not
contribute to the semantic meaning of a {Document}, they can appear within a
{String} or {Comment} token, and are significant within "preserving" blocks.

Note: {WhiteSpace} consists of multiple white space characters.

### Line Terminator

LineTerminator ::

- NewLineChar
- CarriageReturnChar [lookahead != NewLineChar]
- CarriageReturnChar NewLineChar

NewLineChar :: "New Line (0x0A)"

CarriageReturnChar :: "Carriage Return (0x0D)"

Line terminators divide text into lines. Two or more consecutive line
terminators act as separators between blocks. A single line terminator is
insignificant for "_floating_" blocks, but significant for "_line-preserving_"
and "_preserving_" blocks.

### Punctuator

Punctuator[isOperator] :: one of `=`

Punctuator[!isOperator] :: one of `{` `}` `[` `]`

### Operator Name

OperatorName[!isOperator] :: `\` Name

TODO: do we need last char?

### Punctuation

Punctuation[!isOperator] ::

- PunctuationChar
- Period
- Ellipsis
- Dash
- EscapedBracket

PunctuationChar :: one of

- `?` `!` `,` `:` `;` `(` `)`
- `"` `“` `”` `„` `«` `»`
- `'` `‘` `’` `‚` `‹` `›`
- `–` `—` `…`

Period :: PeriodChar [lookahead != `..`]

Dash ::

- HyphenChar HyphenChar [lookahead != HyphenChar]
- HyphenChar HyphenChar HyphenChar

Ellipsis :: PeriodChar PeriodChar PeriodChar

EscapedBracket :: `\` BracketChar

BracketChar :: one of `[` `]` `{` `}`

PeriodChar :: `.`

HyphenChar :: `-`

### Words

Word :: [if not isOperator] WordStart WordBody\*

WordStart :: one of WordCharacter Apostrophe

WordBody :: one of WordCharacter Apostrophe Hyphen

Hyphen :: HyphenChar [lookahead != HyphenChar]

Apostrophe :: `\` `'`

WordCharacter :: "any character from alphabet"

Alphabet configuration is defined by implementation. The default alphabet is the
set of all Latin letters and Arabic numerals.

Note: {Apostrophe} should be escaped to avoid ambiguity with the single {Quote}.

### Name

Name[!isOperator] :: NameStart NameContinue\* [lookahead != NameContinue]

NameStart ::

- Letter
- `_`

NameContinue ::

- Letter
- Digit
- `_`

Letter :: one of

- `a` `b` `c` `d` `e` `f` `g` `h` `i` `j` `k` `l` `m`
- `n` `o` `p` `q` `r` `s` `t` `u` `v` `w` `x` `y` `z`
- `A` `B` `C` `D` `E` `F` `G` `H` `I` `J` `K` `L` `M`
- `N` `O` `P` `Q` `R` `S` `T` `U` `V` `W` `X` `Y` `Z`

Digit :: one of `0` `1` `2` `3` `4` `5` `6` `7` `8` `9`

### Int Value

IntValue[isOperator] :: IntegerPart [lookahead != {Digit, `.`, NameStart}]

IntegerPart ::

- Sign? 0
- Sign? NonZeroDigit Digit\*

Sign :: one of `-` `+`

NonZeroDigit :: Digit but not `0`

### Float Value

FloatValue[isOperator] ::

- IntegerPart FractionalPart ExponentPart [lookahead != {Digit, `.`, NameStart}]
- IntegerPart FractionalPart [lookahead != {Digit, `.`, NameStart}]
- IntegerPart ExponentPart [lookahead != {Digit, `.`, NameStart}]

FractionalPart :: `.` Digit+

ExponentPart :: ExponentIndicator Sign? Digit+

ExponentIndicator :: one of `e` `E`

### String Value

StringValue[isOperator] :: `"` StringChar\* `"`

StringChar ::

- SourceCharacter but not `"` or `\` or LineTerminator
- `\` EscapedCharacter

EscapedCharacter :: one of `"` `\`

## Operators

TODO

## Document

Document ::

- Block+
