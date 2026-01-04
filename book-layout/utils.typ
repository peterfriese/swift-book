
// Reusable utilities for The Swift Programming Language book

#import "@local/eightbyten:0.1.0": note

#let grammar-block(title: none, body) = {
  block(
    stroke: (left: 4pt + luma(200)), 
    inset: 1em, 
    fill: luma(250), 
    radius: 4pt,
    width: 100%,
    {
      let content = body
      if content.has("children") {
        let kids = content.children
        // Strip leading whitespace (space or parbreak) to allow
        // cleaner source code formatting (e.g. starting content on new line)
        while kids.len() > 0 and (kids.first() == [ ] or kids.first() == parbreak()) {
            kids = kids.slice(1)
        }
        content = kids.join()
      }
      if title != none { note(title) }
      content
    }
  )
}

#let admonition-icon(svg) = box(
  height: 1em, // Reduced relative size to match text better
  baseline: 15%, // Shift baseline down to align optical center with text cap-height
  image(
    bytes(svg.replace("currentColor", "#4a4a4a")), // Use dark gray hex directly
    format: "svg"
  )
)

#let experiment-svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M10 2v7.31L4.89 20.26a1 1 0 0 0 .86 1.49h12.5a1 1 0 0 0 .86-1.49L14 9.31V2'/><path d='M8 2h8'/><path d='M9.53 16h4.94'/></svg>"

#let important-svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z'/><path d='M12 9v4'/><path d='M12 17h.01'/></svg>"

#let deprecated-svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><path d='M3 6h18'/><path d='M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6'/><path d='M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2'/></svg>"

#let note-svg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><circle cx='12' cy='12' r='10'/><path d='M12 16v-4'/><path d='M12 8h.01'/></svg>"

#let experiment(body, caption: "Experiment", dy: 18pt) = {
  figure(
    kind: "experiment",
    supplement: "Experiment",
    caption: caption, 
    outlined: true,
    note(
      move(dy: dy, grid(
        columns: (1.5em, 1fr),
        gutter: 0.5em,
        align(center + top, admonition-icon(experiment-svg)),
        align(left)[*Experiment*\ #body]
      ))
    )
  )
}

#let important(body, dy: 18pt) = {
  note(
    move(dy: dy, grid(
      columns: (1.5em, 1fr),
      gutter: 0.5em,
      align(center + top, admonition-icon(important-svg)),
      align(left)[*Important*\ #body]
    ))
  )
}

#let deprecated(body, dy: 18pt) = {
  note(
    move(dy: dy, grid(
      columns: (1.5em, 1fr),
      gutter: 0.5em,
      align(center + top, admonition-icon(deprecated-svg)),
      align(left)[*Deprecated*\ #body]
    ))
  )
}

#let memo(body, dy: 18pt) = {
  note(
    move(dy: dy, grid(
      columns: (1.5em, 1fr),
      gutter: 0.5em,
      align(center + top, admonition-icon(note-svg)),
      align(left)[*Note*\ #body]
    ))
  )
}


#let part(title) = {
  pagebreak(weak: true)
  heading(level: 1, numbering: none, outlined: true, title)
}
