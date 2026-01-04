#import "@preview/marginalia:0.3.1" as marginalia
#import "structs.typ": chapter-eyebrow
#import "config.typ": default-sizes, default-margins

#let current-sans-font = state("current-sans-font", "IBM Plex Sans")

#let chapter-page-layout(fonts, sizes, it) = {
    pagebreak(to: "odd")
    v(20%)
    
    set text(font: fonts.sans)
    
    if (it.has("label") and (it.label == <part> or it.label == <appendix-part>)) {
      // Part / Appendix Part Layout
      marginalia.header(
        align(bottom + left)[
          #context { none }
          #text(size: sizes.h1, weight: "semibold")[#it.body]
        ],
        align(bottom + left)[
           // "PART" shouldn't affect the height/alignment of the block relative to the Title.
           // We place it, or ensure the Number determines the baseline.
           // Only show "PART" label and number if it is a numbered Part (not Appendix Part)
           #if it.numbering != none and it.label == <part> {
             v(0pt) // Anchor
             place(top + left, dy: -20pt)[#text(size: 14pt, weight: "regular")[PART]]
             text(size: sizes.h1-lg, weight: "extralight", fill: text.fill.lighten(30%))[
               #counter("part").display()
             ]
           } else {
             // For Appendix Part (Unnumbered), just empty space on the right?
             // Or maybe we want the "Appendices" title to span? 
             // Current logic keeps it in the left marginalia block, which is distinct.
             none
           }
        ]
      )
    } else if (it.has("supplement") and it.supplement == "Appendix") or (it.has("label") and it.label == <special-appendix>) {
      // Appendix Layout (Regular & Special)
      // Goal: Title on Left. Optional "Appendix I" eyebrow on Left. NO Right Margin Number.
      marginalia.header(
        align(bottom + left)[
          #context {
             // For Regular Numbered Appendices, render "Appendix I" as eyebrow
             if it.numbering != none {
                let num = counter(heading).display(it.numbering)
                text(size: 14pt, weight: "regular", fill: black.lighten(20%))[Appendix #num]
                v(0.5em) // Spacing between eyebrow and title
             }
          }
          #text(size: sizes.h1, weight: "semibold")[#it.body]
        ],
        none // Suppress right margin content completely
      )
    } else {
      // Standard Chapter Layout
      marginalia.header(
        align(bottom + left)[
          #context {
            let eyebrow = chapter-eyebrow.get()
            if eyebrow != none {
              text(size: sizes.eyebrow, weight: "regular", tracking: 1pt, fill: black.lighten(20%))[#upper(eyebrow)]
              v(-20pt)
            }
          }
          #text(size: sizes.h1, weight: "semibold")[#it.body]
        ],
        align(bottom + left)[
           #if it.numbering != none {
              text(size: sizes.h1-lg, weight: "extralight", fill: text.fill.lighten(30%))[
                 #counter(heading).display()
              ]
           }
        ]
      )
    }

    v(20%)
  }

#let mainmatter(body) = {
  pagebreak(to: "odd")
  set page(numbering: "1", footer: none)
  counter(page).update(1)
  body
}

#let backmatter(body) = {
  // Semantic wrapper for backmatter content
  // Enforce Arabic page numbering, but suppress default footer
  set page(numbering: "1", footer: none)
  // Reset heading counter so Appendices start at 1
  counter(heading).update(0)
  body
}

// Helper for Front Matter (TOC, Lists, etc.)
// Sets margins for maximum space, but lets lists handle their own column layout
// Also configures "i" (Roman) numbering and simple headers
#let frontmatter(body) = {
  set page(
    numbering: "i",
    margin: default-margins.frontmatter, // Narrower, symmetric margins.
    footer: none, // No footer (page number is in header)
    header: context {
      set text(font: current-sans-font.get(), size: 9pt)
      let page-num = counter(page).display()
      
      // Outer side only:
      // Recto (Odd) -> Right
      // Verso (Even) -> Left
      let align-side = if calc.odd(here().page()) { right } else { left }
      
      align(align-side, page-num)
    }
  )
  body
}

// Dedication Page Helper
#let dedication(body) = {
  page(header: none, footer: none, margin: default-margins.frontmatter)[
    #v(1fr)
    #align(center + horizon)[
      #text(style: "italic", size: 12pt, body)
    ]
    #v(2fr)
  ]
}
