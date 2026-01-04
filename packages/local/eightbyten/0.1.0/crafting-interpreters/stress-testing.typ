#import "../lib.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#chapter("Stress Testing", eyebrow: "Layout Performance")

= Introduction

This chapter is automatically generated to stress-test the Table of Contents and ensure that the layout holds up under the weight of many sections, side notes, and code snippets. We'll be generating a large number of sections to fill up the pages and the index.

#let dummy-code = ```rust
fn main() {
    println!("Hello, robust layout!");
    let x = 42;
    // This is a comment that might wrap if the line is long enough
    // but the column is narrow.
}
```

#for i in range(1, 21) {
  [
    == Section #i: The Testing

    #lorem(40)

    #note[
      This is side note #i. It ensures that marginalia is working correctly across many pages and sections. #lorem(10)
    ]

    #lorem(30)

    #snippet(filename: "stress_test_" + str(i) + ".rs", info: "Iteration " + str(i))[
      #dummy-code
    ]

    #lorem(50)

    === Subsection #i.1: Granularity

    #lorem(60)
    
    #if calc.rem(i, 3) == 0 {
       design-note("Scalability Issue #" + str(i))
       lorem(40)
    }

    #if calc.rem(i, 5) == 0 {
       notefigure(
          rect(width: 100%, height: 4em, fill: luma(240), stroke: 1pt + luma(100))[
             #align(center+horizon)[Figure #i]
          ],
          caption: [A dummy figure to test the list of figures and caption layout.]
       )
    }
    
    #pagebreak(weak: true)
  ]
}

#challenges()

1. Verify that the Table of Contents handles 20+ new entries gracefully without flowing off the page or looking cluttered.
2. Check that the "List of Design Notes" picked up the periodic design notes generated in the loop.
3. Ensure that page numbers in the TOC are correct and aligned.
