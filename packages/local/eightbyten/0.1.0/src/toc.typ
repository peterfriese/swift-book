#import "structs.typ": part, appendix-part, chapter-eyebrow // We need labels actually. Labels are global? No, identifiers are global in typst? <part> is a label.

#let toc-entry(fonts, it) = {
    set text(font: fonts.sans)
    let el = it.element
    let body = if el.func() == heading { el.body } else if el.func() == figure { el.caption } else { it.body }
    
    // 0. Part entries: "PART n. TITLE" (No dots)
    if el.func() == heading and el.has("label") and el.label == <part> {
       let num = counter("part").at(el.location()).first()
       body = [PART #num. #upper(el.body)]
       body = strong(body)
    }

    // 0.1 Appendix Part entries: "TITLE" (No prefix, Uppercase, Bold)
    if el.func() == heading and el.has("label") and el.label == <appendix-part> {
       body = upper(el.body)
       body = strong(body)
    }

    // 1. Level 1 entries: Format as "Chapter X: " OR "Appendix X: "
    if el.func() == heading and el.level == 1 and not (el.has("label") and (el.label == <part> or el.label == <appendix-part>)) {
       if el.numbering != none {
         let num = counter(heading).at(el.location()).first()
         // let sup = if el.has("supplement") { el.supplement } else { "Chapter" }
         // Use context-aware supplement? typst headings usually have it.
         let sup = el.supplement
         if sup == auto { sup = "Chapter" } // fallback?
         
         // User requested "NOT prefixed with Chapter" for appendices.
         // If generic chapter, use "Chapter". If Appendix, use "Appendix".
         body = [#sup #num: #body]
       }
       body = strong(body)
    }

    // 2. Level 2+ entries: Add numbering if present
    if el.func() == heading and el.level > 1 and el.numbering != none {
       let counts = counter(heading).at(el.location())
       let num = numbering(el.numbering, ..counts)
       body = [#num #body]
    }

    // 3. Challenges and Design Notes (unnumbered L2) should be capitalized
    // Check headings (Main TOC)
    if el.func() == heading and el.level == 2 and el.numbering == none {
      body = upper(body)
    }
    
    // Standard TOC entry layout:
    // Use grid to strictly force side-by-side layout
    let separator-before = none
    let separator-after = none

    // Add space before ALL Level 1 entries (Chapters and Parts)
    // For Parts AND Appendix Parts, we force a column break to start fresh.
    if el.func() == heading and el.level == 1 {
       if el.has("label") and (el.label == <part> or el.label == <appendix-part>) {
         separator-before = colbreak(weak: true)
       } else {
         separator-before = v(1.5em, weak: true)
       }
    }

    separator-before
    
    block(link(el.location(), 
      grid(
        columns: (auto, 1fr, auto),
        gutter: 0.5em,
        body,
        // No dots for Parts
        if el.func() == heading and el.has("label") and el.label == <part> {
           none
        } else {
           align(bottom, box(width: 1fr, repeat[ . ]))
        },
        {
           let page-num = context counter(page).at(el.location()).first()
           if el.func() == heading and el.level == 1 {
             strong(page-num)
           } else {
             page-num
           }
        }
      )
    ))
    
    separator-after
}

// Wrapper for the main Table of Contents
#let toc(depth: 2) = {
  heading(level: 1, numbering: none, outlined: false)[Contents]
  columns(2, outline(title: none, depth: depth))
}
