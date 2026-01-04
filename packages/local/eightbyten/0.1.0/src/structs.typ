#import "@preview/marginalia:0.3.1" as marginalia
#let note(body, ..args) = {
  marginalia.note(..args, numbering: none)[
    #set text(size: 8pt)
    #body
  ]
}
#import "utils.typ" as utils: tracking-figure, get-margin-align

#let chapter-eyebrow = state("chapter-eyebrow", none)

#let chapter(title, eyebrow: none, numbering: "1.", outlined: true) = {
  chapter-eyebrow.update(eyebrow)
  heading(level: 1, numbering: numbering, outlined: outlined)[#title]
}

#let part(title) = {
  // Reset chapter counter when starting a new part? 
  // Customarily parts might reset chapters, but user didn't ask. 
  // We'll just step the part counter.
  chapter-eyebrow.update(none)
  counter("part").step()
  [#heading(level: 1, supplement: "Part", numbering: none)[#title] <part>]
}

#let appendix(title) = {
  // Appendices use Roman numbering (I, II...) per user request
  chapter-eyebrow.update(none)
  heading(level: 1, numbering: "I", supplement: "Appendix")[#title]
}

#let special-appendix(title) = {
  // Special unnumbered appendices (Glossary, Index, Bibliography)
  // These should appear in TOC and have headers, but no numbering.
  chapter-eyebrow.update(none)
  [#heading(level: 1, numbering: none, supplement: "Appendix")[#title] <special-appendix>]
}

#let appendix-part(title) = {
  // Unnumbered part page for Appendices (no "PART n" prefix)
  chapter-eyebrow.update(none)
  [#heading(level: 1, numbering: none, supplement: "Part")[#title] <appendix-part>]
}

// Define the snippet function
#let snippet(filename: "", info: "", body) = {
  block(breakable: false, width: 100%, {
    // Use marginalia note for the side content
    note(
      dy: 1.9em, // Vertical adjustment to align baseline
      context {
        let alignment = utils.get-margin-align(here())
        
        align(alignment)[
          #block(below: 0.3em)[#strong(filename)]
          #if info != "" {
            text(style: "italic", size: 0.8em, fill: luma(100))[#info]
          }
        ]
      }
    )
    
    // Render the body with left AND right borders
    block(
      stroke: (left: 1pt + luma(200), right: 1pt + luma(200)),
      inset: (left: 1em, right: 1em, y: 0.5em),
      width: 100%,
      body
    )
  })
}

#let notefigure = marginalia.notefigure.with(
  show-caption: (_, caption) => {
    set text(size: 8pt)
    if type(caption) == content and caption.has("body") {
      caption.body
    } else {
      caption
    }
  }
)

#let design-note(title) = {
  // Unnumbered heading visually
  heading(level: 2, numbering: none)[Design Note: #title]
  // Hidden figure for list generation
  tracking-figure("design-note", title, supplement: none, numbering: none)
}

#let challenges() = {
  // Unnumbered heading visually
  heading(level: 2, numbering: none)[Challenges]
  
  // Hidden figure for list generation
  // Use context to grab the actual Chapter number (Heading Level 1 counter)
  context {
    let ch-num = counter(heading).at(here()).first()
    // Force the numbering to return the specific chapter number string
    tracking-figure("challenge", "Challenges", supplement: "Chapter", numbering: _ => str(ch-num))
  }
}

#let list-of-design-notes = {
  heading(level: 1, numbering: none, outlined: false)[List of Design Notes]
  columns(2, outline(title: none, target: figure.where(kind: "design-note")))
}

#let list-of-challenges = {
  heading(level: 1, numbering: none, outlined: false)[List of Challenges]
  columns(2, outline(title: none, target: figure.where(kind: "challenge")))
}

// Custom Quote/Epigraph Environment
#let blockquote(attribution: none, body) = {
  pad(y: 1.5em)[
    #block[
      #set text(style: "italic")
      // Hanging opening quote placed to the left of the content
      #place(dx: -0.5em)[“]#body”
    ]
    #if attribution != none {
      align(right)[
        #set text(style: "normal")
        --- #attribution
      ]
    }
  ]
}
