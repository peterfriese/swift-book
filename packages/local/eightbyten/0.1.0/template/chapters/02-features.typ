#import "@local/eightbyten:0.1.0": *

#chapter("Features", eyebrow: "Showcase")

This chapter demonstrates the key features of the `eightbyten` package, including marginalia, code snippets, and special blocks.

== Marginalia

You can add side notes using the `#note`#index("Marginalia") command. #note[This is a margin note. It's great for adding context without breaking the flow of the main text.] These notes appear in the wide margins, characteristic of the Tufte#index("Tufte") style.

#lorem(50)

== Code Snippets

For code examples, use the `#snippet` function. It wraps the code block and adds a filename and optional info string in the margin.

#snippet(filename: "hello.rs", info: "Rust Example")[
```rust
fn main() {
    println!("Hello, World!");
}
```
]

== Wide Blocks

Sometimes content needs more space. The `#wideblock` function allows content to span the full width of the text block plus the margin.

#wideblock(
  rect(width: 100%, height: 60pt, fill: luma(240), stroke: 1pt + luma(200))[
    #align(center+horizon)[This content spans the full available width.]
  ]
)

== Blockquotes

You can use the `#blockquote` function to feature a quote.

#blockquote(attribution: "The Author")[
  Simplicity is the ultimate sophistication.
]

== Admonitions

You can also use special "Design Notes" and "Challenges" blocks, which are automatically collected into lists in the frontmatter.

#design-note("Consistency")
Consistency is key in design. Use the same spacing and typography throughout your book to create a cohesive experience.

#lorem(40)

#challenges()

1.  Try adding a new chapter to this template.
2.  Experiment with different fonts in `main.typ`.
3.  Add a new "Design Note" and check the frontmatter.
