#import "@preview/marginalia:0.3.1" as marginalia
#import marginalia: note

// Helper for hidden tracking figures
#let tracking-figure(kind, caption, numbering: "1", supplement:auto) = {
  // We place it in a zero-height block to hide it visually but keep it in the DOM for outlines
  block(height: 0pt, width: 0pt,
    hide(figure(
      kind: kind,
      caption: caption,
      supplement: supplement,
      numbering: numbering,
      outlined: true,
      
    )[])
  )
}

// Helper to determine text alignment based on page side (Recto/Verso)
// Recto (Odd) -> Right text (Outer) / Left alignment in margin?
// The usage varies:
// In margins: content usually aligns towards the text block.
// In snippets: content in margin aligns towards the text block.
#let get-margin-align(loc) = {
  if calc.odd(loc.page()) { left } else { right }
}
