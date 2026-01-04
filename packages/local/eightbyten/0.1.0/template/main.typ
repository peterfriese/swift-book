// Use this import when developing the package locally or using the template from the repo:
// #import "../lib.typ": *
// Use this import when using the package from the registry:
#import "@local/eightbyten:0.1.0": *

#show: eightbyten.with(
  title: "Book Template",
  authors: ("Your Name",),
  publisher: "Your Publisher",
  book: true,
  debug: false,
  isbn: "978-0-000-00000-0",
  repository: "https://github.com/your-username/your-repo",
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
