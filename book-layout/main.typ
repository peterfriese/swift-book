#import "@local/eightbyten:0.2.0": *
#import "../generated/version.typ": *

// Dynamic title: subtitle on Title Page (page 1), clean title on Colophon (page 2)
#let title-content = context {
  if here().page() == 1 [
    The Swift Programming Language
    #v(0.6em)
    #text(size: 18pt, weight: "regular", fill: luma(80))[#edition-title]
  ] else [
    The Swift Programming Language
  ]
}

#let colophon-info = [
  #if xcode-version != none and xcode-version != "" [
    *Edition:* Swift #swift-version (#xcode-version) \
  ] else [
    *Edition:* Swift #swift-version \
  ]
  #if release-tag != none and release-tag != "" [
    *Release:* #release-tag \
  ]
  *Published:* #published-date
]

// Override codly to debug raw block issues
// #show raw: it => it

#show figure.where(kind: "experiment"): it => it.body

// Keep code blocks of reasonable length intact on one page
#show raw.where(block: true): it => {
  let line-count = it.text.split("\n").len()
  if line-count < 25 {
    block(breakable: false, it)
  } else {
    it
  }
}

// Micro-typography polish
#set text(hyphenate: true)
#set list(tight: true)
#set enum(tight: true)

#show: eightbyten.with(
  title: title-content,
  authors: ("Apple Inc.",),
  publisher: "Swift.org",
  book: true,
  debug: false,
  isbn: "978-0-000-00000-0",
  repository: "https://github.com/apple/swift-book",
  // repository: none, // Set to none to hide the source code line
  printer-info: colophon-info,
  fonts: (
    serif: "IBM Plex Serif",
    sans: "IBM Plex Sans",
    mono: "IBM Plex Mono"
  ),
  paper: "8in x 10in"
)

// Suppress running headers on pages before the first numbered chapter
#set page(
  header: context {
    let current-chapter = query(selector(heading.where(level: 2)).before(here()))
    if current-chapter.len() == 0 {
      none
    } else {
      book-header((
        serif: "IBM Plex Serif",
        sans: "IBM Plex Sans",
        mono: "IBM Plex Mono"
      ))
    }
  }
)

#include "frontmatter.typ"
#include "mainmatter.typ"
#include "backmatter.typ"
