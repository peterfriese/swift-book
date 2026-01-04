// Use this import when using the package from the registry:
#import "@local/eightbyten:0.1.0": *

// Or use this import when developing the package locally:
// #import "../lib.typ": *

#mainmatter[
  #part("The Beginning")

  #include "chapters/01-introduction.typ"

  #part("The Features")

  #include "chapters/02-features.typ"
  #include "chapters/03-figures.typ"
]
