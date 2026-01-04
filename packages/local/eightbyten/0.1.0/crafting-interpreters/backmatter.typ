#import "../lib.typ": *

#backmatter[
  // Separate Part Page for Appendices (Unnumbered, Standalone styling)
  #appendix-part("Appendices")

  #appendix("Mathematical Proofs")
  Detailed proofs for the algorithms discussed in #index("Garbage Collection").

  #lorem(300)

  #special-appendix("Bibliography")
  A list of references and further reading.

  #lorem(100)

  #special-appendix("Glossary")
  Definitions of key terms like #index("Mark-Sweep") and #index("Generational GC").

  #lorem(200)

  #special-appendix("Index")
  #make-index(title: none, outlined: false)
]
