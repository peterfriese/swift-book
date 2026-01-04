# Design Decisions

## 1. Architectural Philosophy

The **EightByTen** package is designed with a strict separation between implementation, configuration, and presentation.

### Module Structure (`src` vs `template`)
- **`src/`**: Contains the core logic. Users should rarely need to touch these files.
  - `lib.typ`: The public API surface.
  - `template.typ`: The main entry point logic (`eightbyten`).
  - `layout.typ`: Page geometry, headers/footers.
  - `structs.typ`: Semantic components (chapters, parts, blocks).
  - `config.typ`: Default values (SSOT).
- **`template/`**: A "starter kit" for users. This demonstrates how to consume the package.
- **`thumbnails/`**: Assets for package registry.

### Import Strategy
We use a dual-import strategy to facilitate both local development and registry usage:
- **Local Dev**: Referenced via relative paths (`../lib.typ`).
- **Registry**: Referenced via versioned namespace (`@preview/eightbyten:x.x.x`).
- **Template Usage**: The template uses `@local` imports to simulate how a real user would import the installed package.

## 2. Layout Engine (Tufte Style)

The defining feature of this package is its "Eight by Ten" (Tufte-inspired) layout.

### Marginalia
We utilize the `marginalia` package to manage the complex geometry required for side notes and margin figures.
- **Decision**: Use `marginalia` instead of custom grid layouts to leverage existing solutions for collision detection and margin placement.
- **Trade-off**: This adds a dependency but significantly reduces maintenance burden for layout calculations.

### Geometric Rigor
- **Asymmetric Margins**: Wide outer margins are enforced for marginalia.
- **Mirroring**: Margins automatically mirror on Recto/Verso pages when `book: true` is set.
- **Base Unit**: All vertical rhythm is loosely based on the font size and line height (standard 1.2-1.4em leading).

## 3. Typography

- **Font Family**: We chose the **IBM Plex** family (Serif, Sans, Mono) as the default.
  - *Reasoning*: It provides a complete, cohesive set of weights and styles that work perfectly together for technical content.
  - *Fallback*: Users can override this via the `fonts` dictionary parameter.

## 4. Configuration Strategy

Configuration is passed top-down via the `eightbyten()` show rule.
- **Parameter Dictionary**: Instead of dozens of individual arguments, we group related settings (fonts, colors, sizes) into dictionaries.
- **Defaults**: `config.typ` holds the Single Source of Truth for defaults.
- **Reasoning**: This keeps the function signature clean and allows for easy extension of configuration options without breaking API changes.

## 5. Build System

We use `just` as a command runner to standardize workflows.
- `just install`: Installs the local version to `@local`.
- `just verify-template`: Compiles the template using the installed `@local` version to ensure the package structure is correct before publishing.
- `just thumbnails`: Automates asset generation to ensure the README always looks fresh.

## 6. Dependency Management

- **Codly**: We integrate `codly` for code blocks but wrap it conditionally.
  - *Feature*: `codly-support: boolean` allows users to opt-out if they prefer native raw blocks or another highlighter.
- **In-dexter**: Used for generating the back-of-book index.

## 7. Future Considerations

- **Color Themes**: The infrastructure is in place (`colors` dict) but not fully utilized. Future versions will support dark mode and custom palettes.
- **Dynamic Margins**: Currently, margins are relatively static based on paper size. We plan to make them purely calculated based on ratio.
