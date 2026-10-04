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

#include "frontmatter.typ"
#include "mainmatter.typ"
#include "backmatter.typ"
