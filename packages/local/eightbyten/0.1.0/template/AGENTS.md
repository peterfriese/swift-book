# EightByTen Template Agent Guide

## Overview

This template uses the **EightByTen** package to create beautiful Tufte-style books in Typst. It features wide margins for sidenotes (`#note`), semantic book structure (Parts, Chapters), and automated table of contents and headers.

## Directory Structure

*   `main.typ`: The root document. Configures the package and includes content sections.
*   `frontmatter.typ`: Introduction, TOC, and other preliminary content.
*   `mainmatter.typ`: Core content, usually divided into Parts and Chapters.
*   `backmatter.typ`: Appendices, Bibliography, and Index.
*   `chapters/`: Recommended directory for individual chapter files.

## Configuration

In `main.typ`, the `#show: eightbyten.with(...)` rule controls the document settings.

```typ
#show: eightbyten.with(
  title: "My Awesome Book",
  authors: ("Jane Doe",),
  publisher: "Tech Press",
  isbn: "978-0-000-00000-0",
  // Design settings
  paper: "8in x 10in", // or "us-letter", "a4"
  fonts: (
    serif: "Linux Libertine",
    sans: "Inter",
    mono: "Fira Code"
  ),
  debug: false // Set to true to see layout frames
)
```

## Document Structure

Wrap your content in `frontmatter`, `mainmatter`, and `backmatter`.

```typ
#frontmatter[
  #dedication[To the reader.]
  #toc()
]

#mainmatter[
  #part("The Beginning")
  #include "chapters/01-introduction.typ"
]

#backmatter[
  #appendix-part("Appendices")
  #include "chapters/99-appendix.typ"
]
```

## Writing Content

### Chapters and Sections
Use standard Typst headings.

```typ
#chapter("Introduction")

= Section Header
== Subsection
```

### Marginalia
Tufte layouts rely heavily on the margin.

**Sidenotes:**
```typ
This is some text.#note[This is a sidenote that appears in the wide margin.]
```

**Margin Figures:**
```typ
#notefigure(
  image("figures/example.png"),
  caption: [This figure sits in the margin.]
)
```

### Layout Elements

**Wide Content:**
Use `#wideblock` to span the main column and the margin (e.g., for large tables or code).

```typ
#wideblock[
  #table(columns: 4, ...)
]
```

**Code Blocks:**
Standard markdown-like syntax, automatically styled with `codly`.

````typ
```rust
fn main() {
    println!("Hello World!");
}
```
````

## Compilation

To compile the book:
`typst compile main.typ`
