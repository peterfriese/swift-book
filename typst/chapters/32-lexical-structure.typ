#import "@local/eightbyten:0.1.0": *
#import "../utils.typ": grammar-block, experiment, important, deprecated, memo


#chapter("Lexical Structure", eyebrow: "Lowest-level syntax components")

The _lexical structure_ of Swift describes what sequence of characters
form valid tokens of the language.
These valid tokens form the lowest-level building blocks of the language
and are used to describe the rest of the language in subsequent chapters.
A token consists of an identifier, keyword, punctuation, literal, or operator.

In most cases, tokens are generated from the characters of a Swift source file
by considering the longest possible substring from the input text,
within the constraints of the grammar that are specified below.
This behavior is referred to as _longest match_
or _maximal munch_.

== Whitespace and Comments

Whitespace has two uses: to separate tokens in the source file
and to distinguish between prefix, postfix, and infix operators
(see LexicalStructure\#Operators),
but is otherwise ignored.
The following characters are considered whitespace:
space (U+0020),
line feed (U+000A),
carriage return (U+000D),
horizontal tab (U+0009),
vertical tab (U+000B),
form feed (U+000C)
and null (U+0000).



Comments are treated as whitespace by the compiler.
Single line comments begin with `//`
and continue until a line feed (U+000A)  or carriage return (U+000D).
Multiline comments begin with `/*` and end with `*/`.
Nesting multiline comments is allowed,
but the comment markers must be balanced.

Comments can contain additional formatting and markup,
as described in #link("https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode\_markup\_formatting\_ref/index.html")[Markup Formatting Reference].

#grammar-block(title: "Grammar of whitespace")[
_whitespace_ → _whitespace-item_ _whitespace_\_?\_ \
_whitespace-item_ → _line-break_ \
_whitespace-item_ → _inline-space_ \
_whitespace-item_ → _comment_ \
_whitespace-item_ → _multiline-comment_ \
_whitespace-item_ → U+0000, U+000B, or U+000C

_line-break_ → U+000A \
_line-break_ → U+000D \
_line-break_ → U+000D followed by U+000A

_inline-spaces_ → _inline-space_ _inline-spaces_\_?\_ \
_inline-space_ → U+0009 or U+0020

_comment_ → *`//`* _comment-text_ _line-break_ \
_multiline-comment_ → *`/*`* _multiline-comment-text_ *`*/`*

_comment-text_ → _comment-text-item_ _comment-text_\_?\_ \
_comment-text-item_ → Any Unicode scalar value except U+000A or U+000D

_multiline-comment-text_ → _multiline-comment-text-item_ _multiline-comment-text_\_?\_ \
_multiline-comment-text-item_ → _multiline-comment_ \
_multiline-comment-text-item_ → _comment-text-item_ \
_multiline-comment-text-item_ → Any Unicode scalar value except  *`/*`* or  *`*/`*
]

== Identifiers

_Identifiers_ begin with
an uppercase or lowercase letter A through Z,
an underscore (`_`),
a noncombining alphanumeric Unicode character
in the Basic Multilingual Plane,
or a character outside the Basic Multilingual Plane
that isn't in a Private Use Area.
After the first character,
digits and combining Unicode characters are also allowed.

Treat identifiers that begin with an underscore,
subscripts whose first argument label begins with an underscore,
and initializers whose first argument label begins with an underscore,
as internal,
even if their declaration has the `public` access-level modifier.
This convention lets framework authors mark part of an API
that clients must not interact with or depend on,
even though some limitation requires the declaration to be public.
In addition,
identifiers that begin with two underscores
are reserved for the Swift compiler and standard library.

To use a reserved word as an identifier,
put a backtick (\`) before and after it.
For example, `class` isn't a valid identifier,
but `` `class` `` is valid.
The backticks aren't considered part of the identifier;
`` `x` `` and `x` have the same meaning.



Inside a closure with no explicit parameter names,
the parameters are implicitly named `$0`, `$1`, `$2`, and so on.
These names are valid identifiers within the scope of the closure.

The compiler synthesizes identifiers that begin with a dollar sign (`$`)
for properties that have a property wrapper projection.
Your code can interact with these identifiers,
but you can't declare identifiers with that prefix.
For more information, see the Attributes\#propertyWrapper section
of the Attributes chapter.





#grammar-block(title: "Grammar of an identifier")[
_identifier_ → _identifier-head_ _identifier-characters_\_?\_ \
_identifier_ → *#raw(" ` ")* _identifier-head_ _identifier-characters_\_?\_ *#raw(" ` ")* \
_identifier_ → _implicit-parameter-name_ \
_identifier_ → _property-wrapper-projection_ \
_identifier-list_ → _identifier_ | _identifier_ *`,`* _identifier-list_

_identifier-head_ → Upper- or lowercase letter A through Z \
_identifier-head_ → *`_`* \
_identifier-head_ → U+00A8, U+00AA, U+00AD, U+00AF, U+00B2–U+00B5, or U+00B7–U+00BA \
_identifier-head_ → U+00BC–U+00BE, U+00C0–U+00D6, U+00D8–U+00F6, or U+00F8–U+00FF \
_identifier-head_ → U+0100–U+02FF, U+0370–U+167F, U+1681–U+180D, or U+180F–U+1DBF \
_identifier-head_ → U+1E00–U+1FFF \
_identifier-head_ → U+200B–U+200D, U+202A–U+202E, U+203F–U+2040, U+2054, or U+2060–U+206F \
_identifier-head_ → U+2070–U+20CF, U+2100–U+218F, U+2460–U+24FF, or U+2776–U+2793 \
_identifier-head_ → U+2C00–U+2DFF or U+2E80–U+2FFF \
_identifier-head_ → U+3004–U+3007, U+3021–U+302F, U+3031–U+303F, or U+3040–U+D7FF \
_identifier-head_ → U+F900–U+FD3D, U+FD40–U+FDCF, U+FDF0–U+FE1F, or U+FE30–U+FE44 \
_identifier-head_ → U+FE47–U+FFFD \
_identifier-head_ → U+10000–U+1FFFD, U+20000–U+2FFFD, U+30000–U+3FFFD, or U+40000–U+4FFFD \
_identifier-head_ → U+50000–U+5FFFD, U+60000–U+6FFFD, U+70000–U+7FFFD, or U+80000–U+8FFFD \
_identifier-head_ → U+90000–U+9FFFD, U+A0000–U+AFFFD, U+B0000–U+BFFFD, or U+C0000–U+CFFFD \
_identifier-head_ → U+D0000–U+DFFFD or U+E0000–U+EFFFD

_identifier-character_ → Digit 0 through 9 \
_identifier-character_ → U+0300–U+036F, U+1DC0–U+1DFF, U+20D0–U+20FF, or U+FE20–U+FE2F \
_identifier-character_ → _identifier-head_ \
_identifier-characters_ → _identifier-character_ _identifier-characters_\_?\_

_implicit-parameter-name_ → *`$`* _decimal-digits_ \
_property-wrapper-projection_ → *`$`* _identifier-characters_
]

== Keywords and Punctuation

The following keywords are reserved and can't be used as identifiers,
unless they're escaped with backticks,
as described above in LexicalStructure\#Identifiers.
Keywords other than `inout`, `var`, and `let`
can be used as parameter names
in a function declaration or function call
without being escaped with backticks.
When a member has the same name as a keyword,
references to that member don't need to be escaped with backticks,
except when there's ambiguity between referring to the member
and using the keyword ---
for example, `self`, `Type`, and `Protocol`
have special meaning in an explicit member expression,
so they must be escaped with backticks in that context.











- Keywords used in declarations:
  `associatedtype`,
  `borrowing`,
  `class`,
  `consuming`,
  `deinit`,
  `enum`,
  `extension`,
  `fileprivate`,
  `func`,
  `import`,
  `init`,
  `inout`,
  `internal`,
  `let`,
  `nonisolated`,
  `open`,
  `operator`,
  `precedencegroup`,
  `private`,
  `protocol`,
  `public`,
  `rethrows`,
  `static`,
  `struct`,
  `subscript`,
  `typealias`,
  and `var`.



- Keywords used in statements:
  `break`,
  `case`,
  `catch`,
  `continue`,
  `default`,
  `defer`,
  `do`,
  `else`,
  `fallthrough`,
  `for`,
  `guard`,
  `if`,
  `in`,
  `repeat`,
  `return`,
  `switch`,
  `throw`,
  `where`,
  and `while`.
- Keywords used in expressions and types:
  `Any`,
  `as`,
  `await`,
  `catch`,
  `false`,
  `is`,
  `nil`,
  `rethrows`,
  `self`,
  `Self`,
  `super`,
  `throw`,
  `throws`,
  `true`,
  and `try`.
- Keywords used in patterns:
  `_`.
- Keywords that begin with a number sign (`#`):
  `#available`,
  `#colorLiteral`,
  `#else`,
  `#elseif`,
  `#endif`,
  `#fileLiteral`,
  `#if`,
  `#imageLiteral`,
  `#keyPath`,
  `#selector`,
  `#sourceLocation`,
  `#unavailable`.

#memo()[

Prior to Swift 5.9,
the following keywords were reserved:
`#column`,
`#dsohandle`,
`#error`,
`#fileID`,
`#filePath`,
`#file`,
`#function`,
`#line`,
and `#warning`.
These are now implemented as macros in the Swift standard library:
#link("https://developer.apple.com/documentation/swift/column(")[`column`]),
#link("https://developer.apple.com/documentation/swift/dsohandle(")[`dsohandle`]),
#link("https://developer.apple.com/documentation/swift/error(\_:")[`error(_:)`]),
#link("https://developer.apple.com/documentation/swift/fileID(")[`fileID`]),
#link("https://developer.apple.com/documentation/swift/filePath(")[`filePath`]),
#link("https://developer.apple.com/documentation/swift/file(")[`file`]),
#link("https://developer.apple.com/documentation/swift/function(")[`function`]),
#link("https://developer.apple.com/documentation/swift/line(")[`line`]),
and #link("https://developer.apple.com/documentation/swift/warning(\_:")[`warning(_:)`]).
]







- Keywords reserved in particular contexts:
  `associativity`,
  `async`,
  `convenience`,
  `didSet`,
  `dynamic`,
  `final`,
  `get`,
  `indirect`,
  `infix`,
  `lazy`,
  `left`,
  `mutating`,
  `none`,
  `nonmutating`,
  `optional`,
  `override`,
  `package`,
  `postfix`,
  `precedence`,
  `prefix`,
  `Protocol`,
  `required`,
  `right`,
  `set`,
  `some`,
  `Type`,
  `unowned`,
  `weak`,
  and `willSet`.
  Outside the context in which they appear in the grammar,
  they can be used as identifiers.



The following tokens are reserved as punctuation
and can't be used as custom operators:
`(`, `)`, `{`, `}`, `[`, `]`,
`.`, `,`, `:`, `;`, `=`, `@`, `#`,
`&` (as a prefix operator), `->`, #raw(" ` "),
`?`, and `!` (as a postfix operator).

== Literals

A _literal_ is the source code representation of a value of a type,
such as a number or string.

The following are examples of literals:

```swift
42               // Integer literal
3.14159          // Floating-point literal
"Hello, world!"  // String literal
/Hello, .*/      // Regular expression literal
true             // Boolean literal
```





A literal doesn't have a type on its own.
Instead, a literal is parsed as having infinite precision and Swift's type inference
attempts to infer a type for the literal. For example,
in the declaration `let x: Int8 = 42`,
Swift uses the explicit type annotation (`: Int8`) to infer
that the type of the integer literal `42` is `Int8`.
If there isn't suitable type information available,
Swift infers that the literal's type is one of the default literal types
defined in the Swift standard library
and listed in the table below.
When specifying the type annotation for a literal value,
the annotation's type must be a type that can be instantiated from that literal value.
That is, the type must conform to the Swift standard library protocols
listed in the table below.








#table(
  columns: 3,
  [* Literal *],
  [* Default type *],
  [* Protocol *],
  [Integer],
  [`Int`],
  [`ExpressibleByIntegerLiteral`],
  [Floating-point],
  [`Double`],
  [`ExpressibleByFloatLiteral`],
  [String],
  [`String`],
  [`ExpressibleByStringLiteral`, `ExpressibleByUnicodeScalarLiteral` for string literals that contain only a single Unicode scalar, `ExpressibleByExtendedGraphemeClusterLiteral` for string literals that contain only a single extended grapheme cluster],
  [Regular expression],
  [`Regex`],
  [None],
  [Boolean],
  [`Bool`],
  [`ExpressibleByBooleanLiteral`],
)


For example, in the declaration `let str = "Hello, world"`,
the default inferred type of the string
literal `"Hello, world"` is `String`.
Also, `Int8` conforms to the `ExpressibleByIntegerLiteral` protocol,
and therefore it can be used in the type annotation for the integer literal `42`
in the declaration `let x: Int8 = 42`.



#grammar-block(title: "Grammar of a literal")[
_literal_ → _numeric-literal_ | _string-literal_ | _regular-expression-literal_ | _boolean-literal_ | _nil-literal_

_numeric-literal_ → _signed-integer-literal_ | _signed-floating-point-literal_ \
_boolean-literal_ → *`true`* | *`false`* \
_nil-literal_ → *`nil`*
]

=== Integer Literals

_Integer literals_ represent integer values of unspecified precision.
By default, integer literals are expressed in decimal;
you can specify an alternate base using a prefix.
Binary literals begin with `0b`,
octal literals begin with `0o`,
and hexadecimal literals begin with `0x`.

Decimal literals contain the digits `0` through `9`.
Binary literals contain `0` and `1`,
octal literals contain `0` through `7`,
and hexadecimal literals contain `0` through `9`
as well as `A` through `F` in upper- or lowercase.

Negative integers literals are expressed by prepending a minus sign (`-`)
to an integer literal, as in `-42`.

Underscores (`_`) are allowed between digits for readability,
but they're ignored and therefore don't affect the value of the literal.
Integer literals can begin with leading zeros (`0`),
but they're likewise ignored and don't affect the base or value of the literal.

Unless otherwise specified,
the default inferred type of an integer literal is the Swift standard library type `Int`.
The Swift standard library also defines types for various sizes of
signed and unsigned integers,
as described in TheBasics\#Integers.





#grammar-block(title: "Grammar of an integer literal")[
_signed-integer-literal_ → *`-`*\_?\_ _integer-literal_
_integer-literal_ → _binary-literal_ \
_integer-literal_ → _octal-literal_ \
_integer-literal_ → _decimal-literal_ \
_integer-literal_ → _hexadecimal-literal_

_binary-literal_ → *`0b`* _binary-digit_ _binary-literal-characters_\_?\_ \
_binary-digit_ → Digit 0 or 1 \
_binary-literal-character_ → _binary-digit_ | *`_`* \
_binary-literal-characters_ → _binary-literal-character_ _binary-literal-characters_\_?\_

_octal-literal_ → *`0o`* _octal-digit_ _octal-literal-characters_\_?\_ \
_octal-digit_ → Digit 0 through 7 \
_octal-literal-character_ → _octal-digit_ | *`_`* \
_octal-literal-characters_ → _octal-literal-character_ _octal-literal-characters_\_?\_

_decimal-literal_ → _decimal-digit_ _decimal-literal-characters_\_?\_ \
_decimal-digit_ → Digit 0 through 9 \
_decimal-digits_ → _decimal-digit_ _decimal-digits_\_?\_ \
_decimal-literal-character_ → _decimal-digit_ | *`_`* \
_decimal-literal-characters_ → _decimal-literal-character_ _decimal-literal-characters_\_?\_

_hexadecimal-literal_ → *`0x`* _hexadecimal-digit_ _hexadecimal-literal-characters_\_?\_ \
_hexadecimal-digit_ → Digit 0 through 9, a through f, or A through F \
_hexadecimal-literal-character_ → _hexadecimal-digit_ | *`_`* \
_hexadecimal-literal-characters_ → _hexadecimal-literal-character_ _hexadecimal-literal-characters_\_?\_
]

=== Floating-Point Literals

_Floating-point literals_ represent floating-point values of unspecified precision.

By default, floating-point literals are expressed in decimal (with no prefix),
but they can also be expressed in hexadecimal (with a `0x` prefix).

Decimal floating-point literals consist of a sequence of decimal digits
followed by either a decimal fraction, a decimal exponent, or both.
The decimal fraction consists of a decimal point (`.`)
followed by a sequence of decimal digits.
The exponent consists of an upper- or lowercase `e` prefix
followed by a sequence of decimal digits that indicates
what power of 10 the value preceding the `e` is multiplied by.
For example, `1.25e2` represents 1.25 x 10²,
which evaluates to `125.0`.
Similarly, `1.25e-2` represents 1.25 x 10⁻²,
which evaluates to `0.0125`.

Hexadecimal floating-point literals consist of a `0x` prefix,
followed by an optional hexadecimal fraction,
followed by a hexadecimal exponent.
The hexadecimal fraction consists of a decimal point
followed by a sequence of hexadecimal digits.
The exponent consists of an upper- or lowercase `p` prefix
followed by a sequence of decimal digits that indicates
what power of 2 the value preceding the `p` is multiplied by.
For example, `0xFp2` represents 15 x 2²,
which evaluates to `60`.
Similarly, `0xFp-2` represents 15 x 2⁻²,
which evaluates to `3.75`.

Negative floating-point literals are expressed by prepending a minus sign (`-`)
to a floating-point literal, as in `-42.5`.

Underscores (`_`) are allowed between digits for readability,
but they're ignored and therefore don't affect the value of the literal.
Floating-point literals can begin with leading zeros (`0`),
but they're likewise ignored and don't affect the base or value of the literal.

Unless otherwise specified,
the default inferred type of a floating-point literal is the Swift standard library type `Double`,
which represents a 64-bit floating-point number.
The Swift standard library also defines a `Float` type,
which represents a 32-bit floating-point number.

#grammar-block(title: "Grammar of a floating-point literal")[
_signed-floating-point-literal_ → > *`-`*\_?\_ _floating-point-literal_
_floating-point-literal_ → _decimal-literal_ _decimal-fraction_\_?\_ _decimal-exponent_\_?\_ \
_floating-point-literal_ → _hexadecimal-literal_ _hexadecimal-fraction_\_?\_ _hexadecimal-exponent_

_decimal-fraction_ → *`.`* _decimal-literal_ \
_decimal-exponent_ → _floating-point-e_ _sign_\_?\_ _decimal-literal_

_hexadecimal-fraction_ → *`.`* _hexadecimal-digit_ _hexadecimal-literal-characters_\_?\_ \
_hexadecimal-exponent_ → _floating-point-p_ _sign_\_?\_ _decimal-literal_

_floating-point-e_ → *`e`* | *`E`* \
_floating-point-p_ → *`p`* | *`P`* \
_sign_ → *`+`* | *`-`*
]

=== String Literals

A string literal is a sequence of characters surrounded by quotation marks.
A single-line string literal is surrounded by double quotation marks
and has the following form:

```swift
"characters"
```

String literals can't contain
an unescaped double quotation mark (`"`),
an unescaped backslash (`\`),
a carriage return, or a line feed.

A multiline string literal is surrounded by three double quotation marks
and has the following form:

```swift
"""
characters
"""
```

Unlike a single-line string literal,
a multiline string literal can contain
unescaped double quotation marks (`"`), carriage returns, and line feeds.
It can't contain three unescaped double quotation marks next to each other.

The line break after the `"""`
that begins the multiline string literal
isn't part of the string.
The line break before the `"""`
that ends the literal is also not part of the string.
To make a multiline string literal
that begins or ends with a line feed,
write a blank line as its first or last line.

A multiline string literal can be indented
using any combination of spaces and tabs;
this indentation isn't included in the string.
The `"""` that ends the literal
determines the indentation:
Every nonblank line in the literal must begin
with exactly the same indentation
that appears before the closing `"""`;
there's no conversion between tabs and spaces.
You can include additional spaces and tabs after that indentation;
those spaces and tabs appear in the string.

Line breaks in a multiline string literal are
normalized to use the line feed character.
Even if your source file has a mix of carriage returns and line feeds,
all of the line breaks in the string will be the same.

In a multiline string literal,
writing a backslash (`\`) at the end of a line
omits that line break from the string.
Any whitespace between the backslash and the line break
is also omitted.
You can use this syntax
to hard wrap a multiline string literal in your source code,
without changing the value of the resulting string.

Special characters
can be included in string literals
of both the single-line and multiline forms
using the following escape sequences:

- Null character (`\0`)
- Backslash (`\\`)
- Horizontal tab (`\t`)
- Line feed (`\n`)
- Carriage return (`\r`)
- Double quotation mark (`\"`)
- Single quotation mark (`\'`)
- Unicode scalar (`\u{`_n_`}`),
  where _n_ is a hexadecimal number
  that has one to eight digits



The value of an expression can be inserted into a string literal
by placing the expression in parentheses after a backslash (`\`).
The interpolated expression can contain a string literal,
but can't contain an unescaped backslash,
a carriage return, or a line feed.

For example, all of the following string literals have the same value:

```swift
"1 2 3"
"1 2 \("3")"
"1 2 \(3)"
"1 2 \(1 + 2)"
let x = 3; "1 2 \(x)"
```





A string delimited by extended delimiters is a sequence of characters
surrounded by quotation marks and a balanced set of one or more number signs (`#`).
A string delimited by extended delimiters has the following forms:

```swift
#"characters"#

#"""
characters
"""#
```

Special characters in a string delimited by extended delimiters
appear in the resulting string as normal characters
rather than as special characters.
You can use extended delimiters to create strings with characters
that would ordinarily have a special effect
such as generating a string interpolation,
starting an escape sequence,
or terminating the string.

The following example shows a string literal
and a string delimited by extended delimiters
that create equivalent string values:

```swift
let string = #"\(x) \ " \u{2603}"#
let escaped = "\\(x) \\ \" \\u{2603}"
print(string)
// Prints "\(x) \ " \u{2603}".
print(string == escaped)
// Prints "true".
```



If you use more than one number sign to form
a string delimited by extended delimiters,
don't place whitespace in between the number signs:



```swift
print(###"Line 1\###nLine 2"###) // OK
print(# # #"Line 1\# # #nLine 2"# # #) // Error
```



Multiline string literals that you create using extended delimiters
have the same indentation requirements as regular multiline string literals.

The default inferred type of a string literal is `String`.
For more information about the `String` type,
see StringsAndCharacters
and #link("https://developer.apple.com/documentation/swift/string")[`String`].

String literals that are concatenated by the `+` operator
are concatenated at compile time.
For example, the values of `textA` and `textB`
in the example below are identical ---
no runtime concatenation is performed.

#grammar-block(title: "Grammar of a string literal")[
_string-literal_ → _static-string-literal_ | _interpolated-string-literal_

_string-literal-opening-delimiter_ → _extended-string-literal-delimiter_\_?\_ *`"`* \
_string-literal-closing-delimiter_ → *`"`* _extended-string-literal-delimiter_\_?\_

_static-string-literal_ → _string-literal-opening-delimiter_ _quoted-text_\_?\_ _string-literal-closing-delimiter_ \
_static-string-literal_ → _multiline-string-literal-opening-delimiter_ _multiline-quoted-text_\_?\_ _multiline-string-literal-closing-delimiter_

_multiline-string-literal-opening-delimiter_ → _extended-string-literal-delimiter_\_?\_ *`"""`* \
_multiline-string-literal-closing-delimiter_ → *`"""`* _extended-string-literal-delimiter_\_?\_ \
_extended-string-literal-delimiter_ → *`#`* _extended-string-literal-delimiter_\_?\_

_quoted-text_ → _quoted-text-item_ _quoted-text_\_?\_ \
_quoted-text-item_ → _escaped-character_ \
_quoted-text-item_ → Any Unicode scalar value except  *`"`*,  *`\`*, U+000A, or U+000D

_multiline-quoted-text_ → _multiline-quoted-text-item_ _multiline-quoted-text_\_?\_ \
_multiline-quoted-text-item_ → _escaped-character_ \
_multiline-quoted-text-item_ → Any Unicode scalar value except  *`\`* \
_multiline-quoted-text-item_ → _escaped-newline_

_interpolated-string-literal_ → _string-literal-opening-delimiter_ _interpolated-text_\_?\_ _string-literal-closing-delimiter_ \
_interpolated-string-literal_ → _multiline-string-literal-opening-delimiter_ _multiline-interpolated-text_\_?\_ _multiline-string-literal-closing-delimiter_

_interpolated-text_ → _interpolated-text-item_ _interpolated-text_\_?\_ \
_interpolated-text-item_ → *`\(`* _expression_ *`)`* | _quoted-text-item_

_multiline-interpolated-text_ → _multiline-interpolated-text-item_ _multiline-interpolated-text_\_?\_ \
_multiline-interpolated-text-item_ → *`\(`* _expression_ *`)`* | _multiline-quoted-text-item_

_escape-sequence_ → *`\`* _extended-string-literal-delimiter_ \
_escaped-character_ → _escape-sequence_ *`0`* | _escape-sequence_ *`\`* | _escape-sequence_ *`t`* | _escape-sequence_ *`n`* | _escape-sequence_ *`r`* | _escape-sequence_ *`"`* | _escape-sequence_ *`'`* \
_escaped-character_ → _escape-sequence_ *`u`* *`{`* _unicode-scalar-digits_ *`}`* \
_unicode-scalar-digits_ → Between one and eight hexadecimal digits

_escaped-newline_ → _escape-sequence_ _inline-spaces_\_?\_ _line-break_
]
```swift
let textA = "Hello " + "world"
let textB = "Hello world"
```





=== Regular Expression Literals

A regular expression literal is a sequence of characters
surrounded by slashes (`/`) with the following form:

```swift
/regular expression/
```

Regular expression literals
must not begin with an unescaped tab or space,
and they can't contain
an unescaped slash (`/`),
a carriage return, or a line feed.

Within a regular expression literal,
a backslash is understood as a part of that regular expression,
not just as an escape character like in string literals.
It indicates that the following special character
should be interpreted literally,
or that the following nonspecial character
should be interpreted in a special way.
For example,
`/\(/` matches a single left parenthesis
and `/\d/` matches a single digit.



A regular expression literal delimited by extended delimiters
is a sequence of characters surrounded by slashes (`/`)
and a balanced set of one or more number signs (`#`).
A regular expression literal
delimited by extended delimiters has the following forms:

```swift
#/regular expression/#

#/
regular expression
/#
```

A regular expression literal that uses extended delimiters
can begin with an unescaped space or tab,
contain unescaped slashes (`/`),
and span across multiple lines.
For a multiline regular expression literal,
the opening delimiter must be at the end of a line,
and the closing delimiter must be on its own line.
Inside a multiline regular expression literal,
the extended regular expression syntax is enabled by default ---
specifically, whitespace is ignored and comments are allowed.



If you use more than one number sign to form
a regular expression literal delimited by extended delimiters,
don't place whitespace in between the number signs:

```swift
let regex1 = ##/abc/##       // OK
let regex2 = # #/abc/# #     // Error
```



If you need to make an empty regular expression literal,
you must use the extended delimiter syntax.

#grammar-block(title: "Grammar of a regular expression literal")[
_regular-expression-literal_ → _regular-expression-literal-opening-delimiter_ _regular-expression_ _regular-expression-literal-closing-delimiter_ \
_regular-expression_ → Any regular expression

_regular-expression-literal-opening-delimiter_ → _extended-regular-expression-literal-delimiter_\_?\_ *`/`* \
_regular-expression-literal-closing-delimiter_ → *`/`* _extended-regular-expression-literal-delimiter_\_?\_

_extended-regular-expression-literal-delimiter_ → *`#`* _extended-regular-expression-literal-delimiter_\_?\_
]

== Operators

The Swift standard library defines a number of operators for your use,
many of which are discussed in BasicOperators
and AdvancedOperators.
The present section describes which characters can be used to define custom operators.

Custom operators can begin with one of the ASCII characters
`/`, `=`, `-`, `+`, `!`, `*`, `%`, `<`, `>`,
`&`, `|`, `^`, `?`, or `~`, or one of the Unicode characters
defined in the grammar below
(which include characters from the
_Mathematical Operators_, _Miscellaneous Symbols_, and _Dingbats_
Unicode blocks, among others).
After the first character,
combining Unicode characters are also allowed.

You can also define custom operators
that begin with a dot (`.`).
These operators can contain additional dots.
For example, `.+.` is treated as a single operator.
If an operator doesn't begin with a dot,
it can't contain a dot elsewhere.
For example, `+.+` is treated as
the `+` operator followed by the `.+` operator.



Although you can define custom operators that contain a question mark (`?`),
they can't consist of a single question mark character only.
Additionally, although operators can contain an exclamation point (`!`),
postfix operators can't begin with either a question mark or an exclamation point.





#memo()[
The tokens `=`, `->`, `//`, `/*`, `*/`, `.`,
the prefix operators `<`, `&`, and `?`,
the infix operator `?`,
and the postfix operators `>`, `!`, and `?` are reserved.
These tokens can't be overloaded, nor can they be used as custom operators.
]

The whitespace around an operator is used to determine
whether an operator is used as a prefix operator, a postfix operator,
or an infix operator. This behavior has the following rules:

- If an operator has whitespace around both sides or around neither side,
  it's treated as an infix operator.
  As an example, the `+++` operator in `a+++b` and `a +++ b` is treated as an infix operator.
- If an operator has whitespace on the left side only,
  it's treated as a prefix unary operator.
  As an example, the `+++` operator in `a +++b` is treated as a prefix unary operator.
- If an operator has whitespace on the right side only,
  it's treated as a postfix unary operator.
  As an example, the `+++` operator in `a+++ b` is treated as a postfix unary operator.
- If an operator has no whitespace on the left but is followed immediately by a dot (`.`),
  it's treated as a postfix unary operator.
  As an example, the  `+++` operator in `a+++.b` is treated as a postfix unary operator
  (`a+++ .b` rather than `a +++ .b`).

For the purposes of these rules,
the characters `(`, `[`, and `{` before an operator,
the characters `)`, `]`, and `}` after an operator,
and the characters `,`, `;`, and `:`
are also considered whitespace.

If the `!` or `?` predefined operator has no whitespace on the left,
it's treated as a postfix operator,
regardless of whether it has whitespace on the right.
To use the `?` as the optional-chaining operator,
it must not have whitespace on the left.
To use it in the ternary conditional (`?` `:`) operator,
it must have whitespace around both sides.

If one of the arguments to an infix operator is a regular expression literal,
then the operator must have whitespace around both sides.

In certain constructs, operators with a leading `<` or `>`
may be split into two or more tokens. The remainder is treated the same way
and may be split again.
As a result, you don't need to add whitespace
to disambiguate between the closing `>` characters in constructs like
`Dictionary<String, Array<Int>>`.
In this example, the closing `>` characters aren't treated as a single token
that may then be misinterpreted as a bit shift `>>` operator.



To learn how to define new, custom operators,
see AdvancedOperators\#Custom-Operators and Declarations\#Operator-Declaration.
To learn how to overload existing operators,
see AdvancedOperators\#Operator-Methods.



#grammar-block(title: "Grammar of operators")[
_operator_ → _operator-head_ _operator-characters_\_?\_ \
_operator_ → _dot-operator-head_ _dot-operator-characters_

_operator-head_ → *`/`* | *`=`* | *`-`* | *`+`* | *`!`* | *`*`* | *`%`* | *`<`* | *`>`* | *`&`* | *`|`* | *`^`* | *`~`* | *`?`* \
_operator-head_ → U+00A1–U+00A7 \
_operator-head_ → U+00A9 or U+00AB \
_operator-head_ → U+00AC or U+00AE \
_operator-head_ → U+00B0–U+00B1 \
_operator-head_ → U+00B6, U+00BB, U+00BF, U+00D7, or U+00F7 \
_operator-head_ → U+2016–U+2017 \
_operator-head_ → U+2020–U+2027 \
_operator-head_ → U+2030–U+203E \
_operator-head_ → U+2041–U+2053 \
_operator-head_ → U+2055–U+205E \
_operator-head_ → U+2190–U+23FF \
_operator-head_ → U+2500–U+2775 \
_operator-head_ → U+2794–U+2BFF \
_operator-head_ → U+2E00–U+2E7F \
_operator-head_ → U+3001–U+3003 \
_operator-head_ → U+3008–U+3020 \
_operator-head_ → U+3030

_operator-character_ → _operator-head_ \
_operator-character_ → U+0300–U+036F \
_operator-character_ → U+1DC0–U+1DFF \
_operator-character_ → U+20D0–U+20FF \
_operator-character_ → U+FE00–U+FE0F \
_operator-character_ → U+FE20–U+FE2F \
_operator-character_ → U+E0100–U+E01EF \
_operator-characters_ → _operator-character_ _operator-characters_\_?\_

_dot-operator-head_ → *`.`* \
_dot-operator-character_ → *`.`* | _operator-character_ \
_dot-operator-characters_ → _dot-operator-character_ _dot-operator-characters_\_?\_

_infix-operator_ → _operator_ \
_prefix-operator_ → _operator_ \
_postfix-operator_ → _operator_
]




