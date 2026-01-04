#import "config.typ": default-fonts, default-colors, default-sizes, default-margins
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/marginalia:0.3.1" as marginalia
#import "structs.typ": chapter, part, appendix, special-appendix, appendix-part, chapter-eyebrow
#import "layout.typ": frontmatter, dedication, backmatter, mainmatter, current-sans-font, chapter-page-layout
#import "headers.typ": book-header
#import "toc.typ": toc-entry

#let eightbyten(
  title: "Eight by Ten",
  authors: (),
  publisher: "Published by One by One",
  isbn: "978-X-XXXX-XXXX-X",
  repository: "https://github.com/peterfriese/eightbyten",
  printer-info: "Printed in the Cloud.",
  fonts: default-fonts,
  paper: none,
  colors: default-colors, // Future use
  sizes: default-sizes,   // Passed to layout.typ
  book: true,
  debug: false,
  codly-support: true,
  body
) = {
  // Update state with current fonts/sizes so other modules can access them if needed
  // Parse paper argument
  let page-args = if type(paper) == str and "x" in paper {
    let parts = paper.split("x").map(s => eval(s.trim()))
    (width: parts.at(0), height: parts.at(1))
  } else if paper != none {
    (paper: paper)
  } else {
    (width: 8in, height: 10in)
  }

  set page(..page-args)

  // Calculate margins based on page width
  // Tufte-style ratios: Inner ~1/9, Outer ~2/9 (wide)
  // Our defaults: inner 0.875in, outer 2.6in on 8in width
  // Ratios: Inner ~11%, Outer ~32.5%
  let adaptive-margins = if "width" in page-args {
    let w = page-args.width
    (
      inner: (far: w * 0.123, width: 0pt, sep: 0pt),
      outer: (far: w * 0.074, width: w * 0.221, sep: w * 0.025)
    )
  } else {
    // Fallback to defaults or try to infer from standard sizes if needed?
    // For standard sizes (e.g. "a4"), we don't have width available nicely without a lookup.
    // We'll stick to defaults for standard sizes unless overriden.
    default-margins
  }
  
  // Conditionally initialize codly
  if codly-support {
    show: codly-init.with()
    codly(
      zebra-fill: none,
      display-name: false,
      display-icon: false,
      stroke: none,
      breakable: false,
    )
    
    // Code Block Spacing Fix:
    // We use `codly` for code blocks, which renders as a grid.
    // By default, the spacing is too loose. We tighten it by:
    // 1. Reducing paragraph leading within the block.
    // 2. Applying a negative row gutter to the grid layout.
    // RESTRICTION: We scope this to `block: true` to avoid breaking inline code line wrapping.
    show raw.where(block: true): set par(leading: 0.35em)
    show raw.where(block: true): set grid(row-gutter: -2pt)
  }


  
  // 1. Generate Title Page (Recto)
  if book {
     // Use relative margins for title page
     page(header: none, footer: none, margin: (x: 15%, y: 20%))[
       #v(1fr)
       #align(center)[
         #text(font: fonts.sans, weight: "bold", size: 36pt, title)
         
         #v(2em)
         
         #text(weight: "regular", size: 18pt, authors.join(", "))
       ]
       #v(2fr)
       #align(center)[
         #text(style: "italic", publisher)
       ]
     ]
     
     // Use margin: 0pt for x/top to keep control, but auto (default) for bottom to match book
     page(header: none, footer: none, margin: (x: 0pt, top: 0pt, bottom: auto))[
        #v(1fr)
        #pad(left: 15%)[
          #set text(size: 8pt, fill: luma(100))
          *#title* \
          Copyright © #datetime.today().year() #authors.join(", ") \
          All rights reserved.
          
          \
          *Fonts:* #fonts.serif, #fonts.sans, #fonts.mono \
          #if repository != none [
            *Source Code:* #repository \
          ]
          *ISBN:* #isbn \
          
          \
          #printer-info
        ]
     ]
  }

  set page(
    header: book-header(fonts)
  )

  // Set the document title and author.
  set document(author: authors, title: title)
  
  // Initialize marginalia for Tufte-style layout
  // Book mode enables mirrored margins (recto/verso).
  // TODO: Make these configurable via options or smart logic based on paper size
  if debug {
    show: marginalia.show-frame
  }

  set page(..page-args)

  show: marginalia.setup.with(
    inner: adaptive-margins.inner,
    outer: adaptive-margins.outer,
    book: book,
  )

  
  // Set basic text properties
  // Typography: IBM Plex Family
  set text(font: fonts.serif, lang: "en", size: sizes.body)
  show heading: set text(font: fonts.sans)
  show raw: set text(font: fonts.mono)
  
  set par(justify: true)
  set heading(numbering: "1.1")

  // TOC customization
  show outline.entry: it => toc-entry(fonts, it)

  show heading.where(level: 1): it => chapter-page-layout(fonts, sizes, it)
  
  // Just show the body
  body
}
