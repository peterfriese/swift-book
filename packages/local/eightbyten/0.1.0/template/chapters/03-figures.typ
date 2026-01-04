#import "@local/eightbyten:0.1.0": *

#chapter("Figures", eyebrow: "Visuals")

Handling figures#index("Figures") correctly is crucial for technical books. `eightbyten` supports standard figures as well as margin figures.

== Standard Figures

Standard figures are placed in the main text column.

#figure(
  rect(width: 100%, height: 100pt, fill: luma(240), stroke: 1pt + luma(200))[
    #align(center+horizon)[A Standard Figure]
  ],
  caption: [This is a standard figure located in the main text column.]
)

== Note Figures

For smaller visuals or side illustrations, use `#notefigure`. These are placed in the margin, similar to `#note`.

#notefigure(
  rect(width: 100%, height: 80pt, fill: blue.lighten(80%), stroke: 1pt + blue.lighten(50%))[
    #align(center+horizon)[Margin Fig]
  ],
  caption: [A figure in the margin.]
)

#lorem(100)
