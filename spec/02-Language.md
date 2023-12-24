# Language

Clients use the KTex markup language to prepare texts for publication. We refer
to such texts as source documents. A document is built from a sequence of
blocks, which optionally use operators to modify their content, and from
definition of these operators.

The source text of a KTex document must be a sequence of {SourceCharacter}.
These characters must be described by a sequence of {Token} and {Ignored}
lexical grammars. The lexical token sequence, omitting {Ignored}, must be
described by a single {Document} syntactic grammar.

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

## Source Text

SourceCharacter :: "Any Unicode scalar value"

### Lexical Tokens

Token ::

- Word
- Punctuation
- etc.

### Ignored Tokens

Ignored ::

- UnicodeBOM
- Whitespace
- LineTerminator
- Comment

## Document

Document ::

- Block+
