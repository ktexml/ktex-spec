# Overview

KTex is an extensible markup language that simplifies the process of preparing
texts for publication.

## Problems

Before delving into the specifics, let's first explore the primary problems that
KTex aims to resolve. These problems help illustrate the key features of KTex
and reflect the fundamental design principles that guide its development.

### Single Base

The first problem that KTex aims to address is providing publishers with a
single, reliable base to manage various publication formats, each with its
unique requirements. The benefits of having a unified base for all publications
are evident: it eases proofreading, guarantees uniformity across formats, and
saves time and resources.

### Extensibility

Publishers frequently have specific requirements, including unique fonts, text
styling, and layouts. KTex is not a fixed markup language; rather, it functions
as a flexible framework that can be expanded to accommodate a wide range of
needs.

### Modularity

KTex is modular by design. Publishers can use external modules to further
enhance KTex, or develop their own modules for use across different KTex
projects or for sharing with other publishers. In fact, the core of KTex is
primarily a collection of modules, with only a minimal layer of immutable code.

### Writing Style

KTex simplifies the task of ensuring a consistent writing style across
publications. For instance, if a publisher requires the use of the Oxford comma
in all publications, this can be readily enforced by integrating the
`ktex-chicago-style` module. This module alone offers thousands of checks, all
of which can be enabled or disabled according to preference.
