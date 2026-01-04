// Use this import when using the package from the registry:
#import "@local/eightbyten:0.1.0": *
#import "utils.typ": part


// Or use this import when developing the package locally:
// #import "../lib.typ": *

#mainmatter[
  #include "../generated/book_content.typ"
]
