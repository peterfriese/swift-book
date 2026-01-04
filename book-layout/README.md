# Book Layout

This directory contains the [Typst](https://typst.app/) source code responsible for the print layout of *The Swift Programming Language*.

## Purpose

While the content of the book is migrated from the `TSPL.docc` directory, this folder dictates **how** that content looks on the page. It defines the typography, margins, header styles, and overall structure of the PDF edition.

## Key Files

-   `main.typ`: The entry point for the PDF compilation. It imports all other modules.
-   `utils.typ`: Contains helper functions and definitions for styling specific elements (grammar blocks, experiments, etc.).
-   `frontmatter.typ`: Layout for the book's beginning (Dedication, TOC).
-   `mainmatter.typ`: Includes the transpiled chapters from `../generated/chapters/`.
-   `backmatter.typ`: Layout for the end of the book (Appendix, Index).
