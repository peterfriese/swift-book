#import "../lib.typ": *

#show: eightbyten.with(
  title: "Eight By Ten Template",
  authors: ("Peter Friese",),
  publisher: "Published by One by One",
  book: true,
  isbn: "978-X-XXXX-XXXX-X",
  printer-info: "Printed in the Cloud.",
  fonts: (
    serif: "IBM Plex Serif",
    sans: "IBM Plex Sans",
    mono: "IBM Plex Mono"
  )
)

#include "frontmatter.typ"

#mainmatter[
  #part("The Basics")

  This part covers the basics. 

  #lorem(200)

  #include "garbage-collection.typ"

  #include "stress-testing.typ"

  #part("Advanced Concepts")

  #include "memory-management.typ"
]

#include "backmatter.typ"
