// Use this import when using the package from the registry:
#import "@local/eightbyten:0.1.0": *

// Or use this import when developing the package locally:
// #import "../lib.typ": *

#mainmatter[
  #part("Welcome to Swift")
  Swift is a powerful and intuitive programming language for all Apple platforms. It's designed to give you more freedom than ever before. Swift is easy to use and open source, so anyone with an idea can create something incredible.

  This section serves as your entry point into the world of Swift. You will begin by exploring the high-level goals that drive the language's design—safety, speed, and expressiveness. Following that, a hands-on guided tour will walk you through the syntax and features effectively, allowing you to write your first Swift code in minutes. Whether you are new to programming or an experienced developer coming from other languages, this foundation sets the stage for everything that follows.


  #include "chapters/01-welcome-to-swift.typ"

  #part("Language Guide")
  The Language Guide is the heart of this book, offering a comprehensive and detailed exploration of Swift's features. It is structured to take you from the absolute basics—such as constants, variables, and common data types—all the way to advanced architectural concepts like protocol-oriented programming, concurrency, and memory safety.

  Each chapter is designed to be self-contained yet progressive, building on previous concepts to deepen your understanding. You will learn how to define functions, model complex data with structures and classes, handle errors gracefully, and utilize powerful modern features like macros. By mastering the topics in this guide, you will gain the fluency required to build robust, efficient, and elegant applications for any platform.


  #include "chapters/02-the-basics.typ"
  #include "chapters/03-basic-operators.typ"
  #include "chapters/04-strings-and-characters.typ"
  #include "chapters/05-collection-types.typ"
  #include "chapters/06-control-flow.typ"
  #include "chapters/07-functions.typ"
  #include "chapters/08-closures.typ"
  #include "chapters/09-enumerations.typ"
  #include "chapters/10-structures-and-classes.typ"
  #include "chapters/11-properties.typ"
  #include "chapters/12-methods.typ" 
  #include "chapters/13-subscripts.typ"
  #include "chapters/14-inheritance.typ"
  #include "chapters/15-initialization.typ"
  #include "chapters/16-deinitialization.typ"
  #include "chapters/17-optional-chaining.typ"
  #include "chapters/18-error-handling.typ"
  #include "chapters/19-concurrency.typ"
  #include "chapters/20-macros.typ"
  #include "chapters/21-type-casting.typ"
  #include "chapters/22-nested-types.typ"
  #include "chapters/23-extensions.typ"
  #include "chapters/24-protocols.typ"
  #include "chapters/25-generics.typ"
  #include "chapters/26-opaque-types.typ"
  #include "chapters/27-automatic-reference-counting.typ"
  #include "chapters/28-memory-safety.typ"
  #include "chapters/29-access-control.typ"
  #include "chapters/30-advanced-operators.typ"

  #part("Language Reference")
  For those who require absolute precision, the Language Reference provides the formal definition of the Swift programming language. Unlike the Guide, which focuses on teaching and usage, this section describes the exact grammar and structure of valid Swift code.

  Intended for compiler engineers, tool builders, and developers who need to resolve ambiguities, this reference breaks down the language into its lexical and syntactic components. From the rules governing whitespace and comments to the complete formal grammar of expressions and statements, this is the authoritative source for the technical implementation details of Swift. Use this section when you need to understand the "why" and "how" behind the compiler's interpretation of your code.


  #include "chapters/31-about-language-reference.typ"
  #include "chapters/32-lexical-structure.typ"
  #include "chapters/33-types.typ"
  #include "chapters/34-expressions.typ"
  #include "chapters/35-statements.typ"
  #include "chapters/36-declarations.typ"
  #include "chapters/37-attributes.typ"
  #include "chapters/38-patterns.typ"
  #include "chapters/39-generic-parameters-and-arguments.typ"
  #include "chapters/40-grammar-summary.typ"
]
