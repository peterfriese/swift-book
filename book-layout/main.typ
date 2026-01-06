#import "@local/eightbyten:0.2.0": *

// Override codly to debug raw block issues
// #show raw: it => it

#show figure.where(kind: "experiment"): it => it.body

#show: eightbyten.with(
  title: "The Swift Programming Language",
  authors: ("Apple Inc.",),
  publisher: "Swift.org",
  book: true,
  debug: false,
  isbn: "978-0-000-00000-0",
  repository: "https://github.com/apple/swift-book",
  // repository: none, // Set to none to hide the source code line
  printer-info: "Printed in the Void.",
  fonts: (
    serif: "IBM Plex Serif",
    sans: "IBM Plex Sans",
    mono: "IBM Plex Mono"
  ),
  paper: "8in x 10in"
)

#include "frontmatter.typ"
#include "mainmatter.typ"
#include "backmatter.typ"
