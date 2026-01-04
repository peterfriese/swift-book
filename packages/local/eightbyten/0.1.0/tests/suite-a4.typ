#import "../lib.typ": *

#show: eightbyten.with(
  title: "A4 Test Suite",
  authors: ("Test Bot",),
  publisher: "Test Publisher",
  book: true,
  isbn: "000-0-000-00000-0",
  printer-info: "Printed for testing.",
  paper: "a4",
  fonts: (
    serif: "IBM Plex Serif",
    sans: "IBM Plex Sans",
    mono: "IBM Plex Mono"
  )
)

#frontmatter[
  #dedication[
    To the regression gods.
  ]
  
  #toc()
]

#pagebreak()

// Codly is initialized by the template

#part("Part One")

#include "chapters/01-test.typ"

#appendix("Test Appendix")
This is an appendix.

#backmatter[
  #index("Test Term")
]
