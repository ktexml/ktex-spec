# Language

Clients use the KTex markup language to prepare texts for publication. We refer
to such texts as source documents. A document is built from a sequence of
blocks, which optionally use operators to modify their content.

The source text of a KTex document must be a sequence of {SourceCharacter}s.
These characters must be described by a sequence of {Token} lexical grammars.
The lexical token sequence, omitting {Ignored}, must be described by a single
{Document} syntactic grammar.

**Lexical Analysis and Syntax Parse**

The source text of a KTex document is first converted into a sequence of lexical
tokens, {Token}, and ignored tokens, {Ignored}. The source text is scanned from
left to right, repeatedly taking the next possible sequence of code-points
allowed by the lexical grammar productions as the next token. This sequence of
lexical tokens are then scanned from left to right to produce an abstract syntax
tree (AST) according to the {Document} syntactical grammar.

Lexical grammar productions in this document use lookahead restrictions to
remove ambiguity and ensure a single valid lexical analysis. A lexical token is
only valid if not followed by a character in its lookahead restriction.

In addition, lexical grammar production is sensitive to the _context_, or
current state, of the lexer. Lexer context has the following properties:

- `isLineStart`, a `Boolean` flag, which is set to `true` at the start of a new
  line. This property is not turned off until an encounter with a non-whitespace
  character.
- `isOperator`, a `Boolean` flag, which is set to `true` only within "operator
  context" (explained later).

## Source Text

SourceCharacter :: "Any UTF-8 character"

KTex documents are interpreted from a source text, which is a sequence of
{SourceCharacter}, each {SourceCharacter} being a UTF-8 character, informally
referred to as a _"character"_ through most of this specification.

### White Space

WhiteSpace ::

- [if not isOperator] "Horizontal Tab (0x09)"
- [if not isOperator] "Space (0x20)"

InsignificantWhiteSpace ::

- [if isOperator] "Horizontal Tab (0x09)"
- [if isOperator] "Space (0x20)"

TODO: review this definition

White space is used to separate {Word}s and improve legibility of source text
and act as separator between tokens, and any amount of white space may appear
before or after any token. White space tokens usually are not significant to the
semantic meaning of a KTex {Document}, however white space characters may appear
within a {String} or {Comment} token, and are significant within _"preserving"_
blocks.

### Line Terminator

LineTerminator ::

- [if not isOperator] "New Line (0x0A)"
- [if not isOperator] "Carriage Return (0x0D)" [lookahead != "New Line (0x0A)"]
- [if not isOperator] "Carriage Return (0x0D)" "New Line (0x0A)"

InsignificantLineTerminator ::

- [if isOperator] "New Line (0x0A)"
- [if isOperator] "Carriage Return (0x0D)" [lookahead != "New Line (0x0A)"]
- [if isOperator] "Carriage Return (0x0D)" "New Line (0x0A)"

Line terminators are used to split text into lines and two, or more, consecutive
line terminators are treated as separators between blocks. Single line
terminator is insignificant for _"floating"_ blocks, but significant for
_"line-preserving"_ and _"preserving"_ blocks.

### Comment

Comment :: CommentStart CommentCharacter\* [lookahead != CommentCharacter]

CommentCharacter :: SourceCharacter but not LineTerminator

CommentStart :: `%` "when" context.isLineStart "is" true

A line in KTex source documents may be transformed into a comment, by putting
{`%`} marker at the start of the line. Note, that leading white space characters
before the {`%`} marker does not affect the comment. But if the {`%`} marker is
preceded by any number non-whitespace characters, then the {`%`} marker and the
rest of the line is treated as a normal text.

### Lexical Tokens

Token ::

- WhiteSpace
- LineTerminator
- Operator
- Punctuator
- Name
- IntValue
- FloatValue
- StringValue
- Word
- Punctuation

Tokens are later used as terminal symbols in KTex syntactic grammars.

### Ignored Tokens

Ignored ::

- UnicodeBOM
- InsignificantWhiteSpace
- InsignificantLineTerminator
- Comment

UnicodeBOM :: "Byte Order Mark (0xFEFF)"

## Operator

TODO

## Document

Document ::

- Block+
