#import "@preview/marginalia:0.3.1" as marginalia
#import "structs.typ": chapter-eyebrow

#let book-header(fonts) = context {
  set text(font: fonts.sans)
  let page-num = counter(page).display()
  let headings = query(selector(heading.where(level: 1)))
  let is-chapter-page = headings.any(h => h.location().page() == here().page())

  // Ensure we don't try to render headers on the very first page if it's not a chapter page (e.g. title page)
  // though typically title pages have `header: none` set explicitly.
  if here().page() > 1 and not is-chapter-page {
     // We query for the nearest preceding chapter and section headings.
     // This allows us to display dynamic headers like "Chapter 2: Variables" or "2.3 Scope".
     let current-chapter = query(selector(heading.where(level: 1)).before(here()))
     let current-section = query(selector(heading.where(level: 2)).before(here()))
     
     if current-chapter.len() > 0 {
         let ch = current-chapter.last()
         // Don't show headers for Parts or Unnumbered chapters (unless special appendix)
         if (ch.has("label") and ch.label == <part>) or (ch.numbering == none and not (ch.has("label") and ch.label == <special-appendix>)) { return none }
     }

     if calc.odd(here().page()) {
       // Recto (Odd): "NN.M SECTION TITLE"
       let content = if current-section.len() > 0 {
         let sec = current-section.last()
         if sec.numbering != none {
            let result = counter(heading).at(sec.location())
            let num = numbering(sec.numbering, ..result)
            [#num #upper(sec.body)]
         } else {
            [#upper(sec.body)]
         }
       } else {
         "" 
       }
       
       marginalia.header(
         align(right, content), 
         align(right, page-num)
       ) 
     } else {
       // Verso (Even): "CHAPTER NN: CHAPTER TITLE" or "TITLE"
       let content = if current-chapter.len() > 0 {
         let ch = current-chapter.last()
         if ch.numbering != none {
            let result = counter(heading).at(ch.location())
            let num = numbering(ch.numbering, ..result)
            [#upper(ch.supplement) #num: #upper(ch.body)]
         } else {
            upper(ch.body)
         }
       } else {
         ""
       }

       marginalia.header(
         content, 
         page-num
       )
     }
  }
}
