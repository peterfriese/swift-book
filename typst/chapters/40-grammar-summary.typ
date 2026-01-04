#import "@local/eightbyten:0.1.0": *
#import "../utils.typ": grammar-block, experiment, important, deprecated, memo


#chapter("Summary of the Grammar", eyebrow: "Complete formal grammar")



== Lexical Structure

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

_identifier-character_ → _decimal-digit_ \
_identifier-character_ → U+0300–U+036F, U+1DC0–U+1DFF, U+20D0–U+20FF, or U+FE20–U+FE2F \
_identifier-character_ → _identifier-head_ \
_identifier-characters_ → _identifier-character_ _identifier-characters_\_?\_

_implicit-parameter-name_ → *`$`* _decimal-digits_ \
_property-wrapper-projection_ → *`$`* _identifier-characters_
]

#grammar-block(title: "Grammar of a literal")[
_literal_ → _numeric-literal_ | _string-literal_ | _regular-expression-literal_ | _boolean-literal_ | _nil-literal_

_numeric-literal_ → *`-`*\_?\_ _integer-literal_ | *`-`*\_?\_ _floating-point-literal_ \
_boolean-literal_ → *`true`* | *`false`* \
_nil-literal_ → *`nil`*
]

#grammar-block(title: "Grammar of an integer literal")[
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

#grammar-block(title: "Grammar of a floating-point literal")[
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

#grammar-block(title: "Grammar of a regular expression literal")[
_regular-expression-literal_ → _regular-expression-literal-opening-delimiter_ _regular-expression_ _regular-expression-literal-closing-delimiter_ \
_regular-expression_ → Any regular expression

_regular-expression-literal-opening-delimiter_ → _extended-regular-expression-literal-delimiter_\_?\_ *`/`* \
_regular-expression-literal-closing-delimiter_ → *`/`* _extended-regular-expression-literal-delimiter_\_?\_

_extended-regular-expression-literal-delimiter_ → *`#`* _extended-regular-expression-literal-delimiter_\_?\_
]

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

== Types

#grammar-block(title: "Grammar of a type")[
_type_ → _function-type_ \
_type_ → _array-type_ \
_type_ → _dictionary-type_ \
_type_ → _type-identifier_ \
_type_ → _tuple-type_ \
_type_ → _optional-type_ \
_type_ → _implicitly-unwrapped-optional-type_ \
_type_ → _protocol-composition-type_ \
_type_ → _opaque-type_ \
_type_ → _metatype-type_ \
_type_ → _any-type_ \
_type_ → _self-type_ \
_type_ → *`(`* _type_ *`)`*
]

#grammar-block(title: "Grammar of a type annotation")[
_type-annotation_ → *`:`* _attributes_\_?\_ *`inout`*\_?\_ _type_
]

#grammar-block(title: "Grammar of a type identifier")[
_type-identifier_ → _type-name_ _generic-argument-clause_\_?\_ | _type-name_ _generic-argument-clause_\_?\_ *`.`* _type-identifier_ \
_type-name_ → _identifier_
]

#grammar-block(title: "Grammar of a tuple type")[
_tuple-type_ → *`(`* *`)`* | *`(`* _tuple-type-element_ *`,`* _tuple-type-element-list_ *`)`* \
_tuple-type-element-list_ → _tuple-type-element_ | _tuple-type-element_ *`,`* _tuple-type-element-list_ \
_tuple-type-element_ → _element-name_ _type-annotation_ | _type_ \
_element-name_ → _identifier_
]

#grammar-block(title: "Grammar of a function type")[
_function-type_ → _attributes_\_?\_ _function-type-argument-clause_ *`async`*\_?\_ _throws-clause_\_?\_ *`->`* _type_

_function-type-argument-clause_ → *`(`* *`)`* \
_function-type-argument-clause_ → *`(`* _function-type-argument-list_ *`...`*\_?\_ *`)`*

_function-type-argument-list_ → _function-type-argument_ | _function-type-argument_ *`,`* _function-type-argument-list_ \
_function-type-argument_ → _attributes_\_?\_ *`inout`*\_?\_ _type_ | _argument-label_ _type-annotation_ \
_argument-label_ → _identifier_

_throws-clause_ → *`throws`* | *`throws`* *`(`* _type_ *`)`*
]

#grammar-block(title: "Grammar of an array type")[
_array-type_ → *`[`* _type_ *`]`*
]

#grammar-block(title: "Grammar of a dictionary type")[
_dictionary-type_ → *`[`* _type_ *`:`* _type_ *`]`*
]

#grammar-block(title: "Grammar of an optional type")[
_optional-type_ → _type_ *`?`*
]

#grammar-block(title: "Grammar of an implicitly unwrapped optional type")[
_implicitly-unwrapped-optional-type_ → _type_ *`!`*
]

#grammar-block(title: "Grammar of a protocol composition type")[
_protocol-composition-type_ → _type-identifier_ *`&`* _protocol-composition-continuation_ \
_protocol-composition-continuation_ → _type-identifier_ | _protocol-composition-type_
]

#grammar-block(title: "Grammar of an opaque type")[
_opaque-type_ → *`some`* _type_
]

#grammar-block(title: "Grammar of a boxed protocol type")[
_boxed-protocol-type_ → *`any`* _type_
]

#grammar-block(title: "Grammar of a metatype type")[
_metatype-type_ → _type_ *`.`* *`Type`* | _type_ *`.`* *`Protocol`*
]

#grammar-block(title: "Grammar of an Any type")[
_any-type_ → *`Any`*
]

#grammar-block(title: "Grammar of a Self type")[
_self-type_ → *`Self`*
]

#grammar-block(title: "Grammar of a type inheritance clause")[
_type-inheritance-clause_ → *`:`* _type-inheritance-list_ \
_type-inheritance-list_ → _attributes_\_?\_ _type-identifier_ | _attributes_\_?\_ _type-identifier_ *`,`* _type-inheritance-list_
]

== Expressions

#grammar-block(title: "Grammar of an expression")[
_expression_ → _try-operator_\_?\_ _await-operator_\_?\_ _prefix-expression_ _infix-expressions_\_?\_
]

#grammar-block(title: "Grammar of a prefix expression")[
_prefix-expression_ → _prefix-operator_\_?\_ _postfix-expression_ \
_prefix-expression_ → _in-out-expression_
]

#grammar-block(title: "Grammar of an in-out expression")[
_in-out-expression_ → *`&`* _primary-expression_
]

#grammar-block(title: "Grammar of a try expression")[
_try-operator_ → *`try`* | *`try`* *`?`* | *`try`* *`!`*
]

#grammar-block(title: "Grammar of an await expression")[
_await-operator_ → *`await`*
]

#grammar-block(title: "Grammar of an infix expression")[
_infix-expression_ → _infix-operator_ _prefix-expression_ \
_infix-expression_ → _assignment-operator_ _try-operator_\_?\_ _await-operator_\_?\_ _prefix-expression_ \
_infix-expression_ → _conditional-operator_ _try-operator_\_?\_ _await-operator_\_?\_ _prefix-expression_ \
_infix-expression_ → _type-casting-operator_ \
_infix-expressions_ → _infix-expression_ _infix-expressions_\_?\_
]

#grammar-block(title: "Grammar of an assignment operator")[
_assignment-operator_ → *`=`*
]

#grammar-block(title: "Grammar of a conditional operator")[
_conditional-operator_ → *`?`* _expression_ *`:`*
]

#grammar-block(title: "Grammar of a type-casting operator")[
_type-casting-operator_ → *`is`* _type_ \
_type-casting-operator_ → *`as`* _type_ \
_type-casting-operator_ → *`as`* *`?`* _type_ \
_type-casting-operator_ → *`as`* *`!`* _type_
]

#grammar-block(title: "Grammar of a primary expression")[
_primary-expression_ → _identifier_ _generic-argument-clause_\_?\_ \
_primary-expression_ → _literal-expression_ \
_primary-expression_ → _self-expression_ \
_primary-expression_ → _superclass-expression_ \
_primary-expression_ → _conditional-expression_ \
_primary-expression_ → _closure-expression_ \
_primary-expression_ → _parenthesized-expression_ \
_primary-expression_ → _tuple-expression_ \
_primary-expression_ → _implicit-member-expression_ \
_primary-expression_ → _wildcard-expression_ \
_primary-expression_ → _macro-expansion-expression_ \
_primary-expression_ → _key-path-expression_ \
_primary-expression_ → _selector-expression_ \
_primary-expression_ → _key-path-string-expression_
]

#grammar-block(title: "Grammar of a literal expression")[
_literal-expression_ → _literal_ \
_literal-expression_ → _array-literal_ | _dictionary-literal_ | _playground-literal_

_array-literal_ → *`[`* _array-literal-items_\_?\_ *`]`* \
_array-literal-items_ → _array-literal-item_ *`,`*\_?\_ | _array-literal-item_ *`,`* _array-literal-items_ \
_array-literal-item_ → _expression_

_dictionary-literal_ → *`[`* _dictionary-literal-items_ *`]`* | *`[`* *`:`* *`]`* \
_dictionary-literal-items_ → _dictionary-literal-item_ *`,`*\_?\_ | _dictionary-literal-item_ *`,`* _dictionary-literal-items_ \
_dictionary-literal-item_ → _expression_ *`:`* _expression_

_playground-literal_ → *`#colorLiteral`* *`(`* *`red`* *`:`* _expression_ *`,`* *`green`* *`:`* _expression_ *`,`* *`blue`* *`:`* _expression_ *`,`* *`alpha`* *`:`* _expression_ *`)`* \
_playground-literal_ → *`#fileLiteral`* *`(`* *`resourceName`* *`:`* _expression_ *`)`* \
_playground-literal_ → *`#imageLiteral`* *`(`* *`resourceName`* *`:`* _expression_ *`)`*
]

#grammar-block(title: "Grammar of a self expression")[
_self-expression_ → *`self`* | _self-method-expression_ | _self-subscript-expression_ | _self-initializer-expression_

_self-method-expression_ → *`self`* *`.`* _identifier_ \
_self-subscript-expression_ → *`self`* *`[`* _function-call-argument-list_ *`]`* \
_self-initializer-expression_ → *`self`* *`.`* *`init`*
]

#grammar-block(title: "Grammar of a superclass expression")[
_superclass-expression_ → _superclass-method-expression_ | _superclass-subscript-expression_ | _superclass-initializer-expression_

_superclass-method-expression_ → *`super`* *`.`* _identifier_ \
_superclass-subscript-expression_ → *`super`* *`[`* _function-call-argument-list_ *`]`* \
_superclass-initializer-expression_ → *`super`* *`.`* *`init`*
]

#grammar-block(title: "Grammar of a conditional expression")[
_conditional-expression_ → _if-expression_ | _switch-expression_

_if-expression_ → *`if`* _condition-list_ *`{`* _statement_ *`}`* _if-expression-tail_ \
_if-expression-tail_ → *`else`* _if-expression_ \
_if-expression-tail_ → *`else`* *`{`* _statement_ *`}`*

_switch-expression_ → *`switch`* _expression_ *`{`* _switch-expression-cases_ *`}`* \
_switch-expression-cases_ → _switch-expression-case_ _switch-expression-cases_\_?\_ \
_switch-expression-case_ → _case-label_ _statement_ \
_switch-expression-case_ → _default-label_ _statement_
]

#grammar-block(title: "Grammar of a closure expression")[
_closure-expression_ → *`{`* _attributes_\_?\_ _closure-signature_\_?\_ _statements_\_?\_ *`}`*

_closure-signature_ → _capture-list_\_?\_ _closure-parameter-clause_ *`async`*\_?\_ _throws-clause_\_?\_ _function-result_\_?\_ *`in`* \
_closure-signature_ → _capture-list_ *`in`*

_closure-parameter-clause_ → *`(`* *`)`* | *`(`* _closure-parameter-list_ *`)`* | _identifier-list_ \
_closure-parameter-list_ → _closure-parameter_ | _closure-parameter_ *`,`* _closure-parameter-list_ \
_closure-parameter_ → _closure-parameter-name_ _type-annotation_\_?\_ \
_closure-parameter_ → _closure-parameter-name_ _type-annotation_ *`...`* \
_closure-parameter-name_ → _identifier_

_capture-list_ → *`[`* _capture-list-items_ *`]`* \
_capture-list-items_ → _capture-list-item_ | _capture-list-item_ *`,`* _capture-list-items_ \
_capture-list-item_ → _capture-specifier_\_?\_ _identifier_ \
_capture-list-item_ → _capture-specifier_\_?\_ _identifier_ *`=`* _expression_ \
_capture-list-item_ → _capture-specifier_\_?\_ _self-expression_ \
_capture-specifier_ → *`weak`* | *`unowned`* | *`unowned(safe)`* | *`unowned(unsafe)`*
]

#grammar-block(title: "Grammar of an implicit member expression")[
_implicit-member-expression_ → *`.`* _identifier_ \
_implicit-member-expression_ → *`.`* _identifier_ *`.`* _postfix-expression_
]

#grammar-block(title: "Grammar of a parenthesized expression")[
_parenthesized-expression_ → *`(`* _expression_ *`)`*
]

#grammar-block(title: "Grammar of a tuple expression")[
_tuple-expression_ → *`(`* *`)`* | *`(`* _tuple-element_ *`,`* _tuple-element-list_ *`)`* \
_tuple-element-list_ → _tuple-element_ | _tuple-element_ *`,`* _tuple-element-list_ \
_tuple-element_ → _expression_ | _identifier_ *`:`* _expression_
]

#grammar-block(title: "Grammar of a wildcard expression")[
_wildcard-expression_ → *`_`*
]

#grammar-block(title: "Grammar of a macro-expansion expression")[
_macro-expansion-expression_ → *`#`* _identifier_ _generic-argument-clause_\_?\_ _function-call-argument-clause_\_?\_ _trailing-closures_\_?\_
]

#grammar-block(title: "Grammar of a key-path expression")[
_key-path-expression_ → *`\`* _type_\_?\_ *`.`* _key-path-components_ \
_key-path-components_ → _key-path-component_ | _key-path-component_ *`.`* _key-path-components_ \
_key-path-component_ → _identifier_ _key-path-postfixes_\_?\_ | _key-path-postfixes_

_key-path-postfixes_ → _key-path-postfix_ _key-path-postfixes_\_?\_ \
_key-path-postfix_ → *`?`* | *`!`* | *`self`* | *`[`* _function-call-argument-list_ *`]`*
]

#grammar-block(title: "Grammar of a selector expression")[
_selector-expression_ → *`#selector`* *`(`* _expression_ *`)`* \
_selector-expression_ → *`#selector`* *`(`* *`getter:`* _expression_ *`)`* \
_selector-expression_ → *`#selector`* *`(`* *`setter:`* _expression_ *`)`*
]

#grammar-block(title: "Grammar of a key-path string expression")[
_key-path-string-expression_ → *`#keyPath`* *`(`* _expression_ *`)`*
]

#grammar-block(title: "Grammar of a postfix expression")[
_postfix-expression_ → _primary-expression_ \
_postfix-expression_ → _postfix-expression_ _postfix-operator_ \
_postfix-expression_ → _function-call-expression_ \
_postfix-expression_ → _initializer-expression_ \
_postfix-expression_ → _explicit-member-expression_ \
_postfix-expression_ → _postfix-self-expression_ \
_postfix-expression_ → _subscript-expression_ \
_postfix-expression_ → _forced-value-expression_ \
_postfix-expression_ → _optional-chaining-expression_
]

#grammar-block(title: "Grammar of a function call expression")[
_function-call-expression_ → _postfix-expression_ _function-call-argument-clause_ \
_function-call-expression_ → _postfix-expression_ _function-call-argument-clause_\_?\_ _trailing-closures_

_function-call-argument-clause_ → *`(`* *`)`* | *`(`* _function-call-argument-list_ *`)`* \
_function-call-argument-list_ → _function-call-argument_ | _function-call-argument_ *`,`* _function-call-argument-list_ \
_function-call-argument_ → _expression_ | _identifier_ *`:`* _expression_ \
_function-call-argument_ → _operator_ | _identifier_ *`:`* _operator_

_trailing-closures_ → _closure-expression_ _labeled-trailing-closures_\_?\_ \
_labeled-trailing-closures_ → _labeled-trailing-closure_ _labeled-trailing-closures_\_?\_ \
_labeled-trailing-closure_ → _identifier_ *`:`* _closure-expression_
]

#grammar-block(title: "Grammar of an initializer expression")[
_initializer-expression_ → _postfix-expression_ *`.`* *`init`* \
_initializer-expression_ → _postfix-expression_ *`.`* *`init`* *`(`* _argument-names_ *`)`*
]

#grammar-block(title: "Grammar of an explicit member expression")[
_explicit-member-expression_ → _postfix-expression_ *`.`* _decimal-digits_ \
_explicit-member-expression_ → _postfix-expression_ *`.`* _identifier_ _generic-argument-clause_\_?\_ \
_explicit-member-expression_ → _postfix-expression_ *`.`* _identifier_ *`(`* _argument-names_ *`)`* \
_explicit-member-expression_ → _postfix-expression_ _conditional-compilation-block_

_argument-names_ → _argument-name_ _argument-names_\_?\_ \
_argument-name_ → _identifier_ *`:`*
]

#grammar-block(title: "Grammar of a postfix self expression")[
_postfix-self-expression_ → _postfix-expression_ *`.`* *`self`*
]

#grammar-block(title: "Grammar of a subscript expression")[
_subscript-expression_ → _postfix-expression_ *`[`* _function-call-argument-list_ *`]`*
]

#grammar-block(title: "Grammar of a forced-value expression")[
_forced-value-expression_ → _postfix-expression_ *`!`*
]

#grammar-block(title: "Grammar of an optional-chaining expression")[
_optional-chaining-expression_ → _postfix-expression_ *`?`*
]

== Statements

#grammar-block(title: "Grammar of a statement")[
_statement_ → _expression_ *`;`*\_?\_ \
_statement_ → _declaration_ *`;`*\_?\_ \
_statement_ → _loop-statement_ *`;`*\_?\_ \
_statement_ → _branch-statement_ *`;`*\_?\_ \
_statement_ → _labeled-statement_ *`;`*\_?\_ \
_statement_ → _control-transfer-statement_ *`;`*\_?\_ \
_statement_ → _defer-statement_ *`;`*\_?\_ \
_statement_ → _do-statement_ *`;`*\_?\_ \
_statement_ → _compiler-control-statement_ \
_statements_ → _statement_ _statements_\_?\_
]

#grammar-block(title: "Grammar of a loop statement")[
_loop-statement_ → _for-in-statement_ \
_loop-statement_ → _while-statement_ \
_loop-statement_ → _repeat-while-statement_
]

#grammar-block(title: "Grammar of a for-in statement")[
_for-in-statement_ → *`for`* *`case`*\_?\_ _pattern_ *`in`* _expression_ _where-clause_\_?\_ _code-block_
]

#grammar-block(title: "Grammar of a while statement")[
_while-statement_ → *`while`* _condition-list_ _code-block_

_condition-list_ → _condition_ | _condition_ *`,`* _condition-list_ \
_condition_ → _expression_ | _availability-condition_ | _case-condition_ | _optional-binding-condition_

_case-condition_ → *`case`* _pattern_ _initializer_ \
_optional-binding-condition_ → *`let`* _pattern_ _initializer_\_?\_ | *`var`* _pattern_ _initializer_\_?\_
]

#grammar-block(title: "Grammar of a repeat-while statement")[
_repeat-while-statement_ → *`repeat`* _code-block_ *`while`* _expression_
]

#grammar-block(title: "Grammar of a branch statement")[
_branch-statement_ → _if-statement_ \
_branch-statement_ → _guard-statement_ \
_branch-statement_ → _switch-statement_
]

#grammar-block(title: "Grammar of an if statement")[
_if-statement_ → *`if`* _condition-list_ _code-block_ _else-clause_\_?\_ \
_else-clause_ → *`else`* _code-block_ | *`else`* _if-statement_
]

#grammar-block(title: "Grammar of a guard statement")[
_guard-statement_ → *`guard`* _condition-list_ *`else`* _code-block_
]

#grammar-block(title: "Grammar of a switch statement")[
_switch-statement_ → *`switch`* _expression_ *`{`* _switch-cases_\_?\_ *`}`* \
_switch-cases_ → _switch-case_ _switch-cases_\_?\_ \
_switch-case_ → _case-label_ _statements_ \
_switch-case_ → _default-label_ _statements_ \
_switch-case_ → _conditional-switch-case_

_case-label_ → _attributes_\_?\_ *`case`* _case-item-list_ *`:`* \
_case-item-list_ → _pattern_ _where-clause_\_?\_ | _pattern_ _where-clause_\_?\_ *`,`* _case-item-list_ \
_default-label_ → _attributes_\_?\_ *`default`* *`:`*

_where-clause_ → *`where`* _where-expression_ \
_where-expression_ → _expression_

_conditional-switch-case_ → _switch-if-directive-clause_ _switch-elseif-directive-clauses_\_?\_ _switch-else-directive-clause_\_?\_ _endif-directive_ \
_switch-if-directive-clause_ → _if-directive_ _compilation-condition_ _switch-cases_\_?\_ \
_switch-elseif-directive-clauses_ → _elseif-directive-clause_ _switch-elseif-directive-clauses_\_?\_ \
_switch-elseif-directive-clause_ → _elseif-directive_ _compilation-condition_ _switch-cases_\_?\_ \
_switch-else-directive-clause_ → _else-directive_ _switch-cases_\_?\_
]

#grammar-block(title: "Grammar of a labeled statement")[
_labeled-statement_ → _statement-label_ _loop-statement_ \
_labeled-statement_ → _statement-label_ _if-statement_ \
_labeled-statement_ → _statement-label_ _switch-statement_ \
_labeled-statement_ → _statement-label_ _do-statement_

_statement-label_ → _label-name_ *`:`* \
_label-name_ → _identifier_
]

#grammar-block(title: "Grammar of a control transfer statement")[
_control-transfer-statement_ → _break-statement_ \
_control-transfer-statement_ → _continue-statement_ \
_control-transfer-statement_ → _fallthrough-statement_ \
_control-transfer-statement_ → _return-statement_ \
_control-transfer-statement_ → _throw-statement_
]

#grammar-block(title: "Grammar of a break statement")[
_break-statement_ → *`break`* _label-name_\_?\_
]

#grammar-block(title: "Grammar of a continue statement")[
_continue-statement_ → *`continue`* _label-name_\_?\_
]

#grammar-block(title: "Grammar of a fallthrough statement")[
_fallthrough-statement_ → *`fallthrough`*
]

#grammar-block(title: "Grammar of a return statement")[
_return-statement_ → *`return`* _expression_\_?\_
]

#grammar-block(title: "Grammar of a throw statement")[
_throw-statement_ → *`throw`* _expression_
]

#grammar-block(title: "Grammar of a defer statement")[
_defer-statement_ → *`defer`* _code-block_
]

#grammar-block(title: "Grammar of a do statement")[
_do-statement_ → *`do`* _throws-clause_\_?\_ _code-block_ _catch-clauses_\_?\_ \
_catch-clauses_ → _catch-clause_ _catch-clauses_\_?\_ \
_catch-clause_ → *`catch`* _catch-pattern-list_\_?\_ _code-block_ \
_catch-pattern-list_ → _catch-pattern_ | _catch-pattern_ *`,`* _catch-pattern-list_ \
_catch-pattern_ → _pattern_ _where-clause_\_?\_
]

#grammar-block(title: "Grammar of a compiler control statement")[
_compiler-control-statement_ → _conditional-compilation-block_ \
_compiler-control-statement_ → _line-control-statement_ \
_compiler-control-statement_ → _diagnostic-statement_
]

#grammar-block(title: "Grammar of a conditional compilation block")[
_conditional-compilation-block_ → _if-directive-clause_ _elseif-directive-clauses_\_?\_ _else-directive-clause_\_?\_ _endif-directive_

_if-directive-clause_ → _if-directive_ _compilation-condition_ _statements_\_?\_ \
_elseif-directive-clauses_ → _elseif-directive-clause_ _elseif-directive-clauses_\_?\_ \
_elseif-directive-clause_ → _elseif-directive_ _compilation-condition_ _statements_\_?\_ \
_else-directive-clause_ → _else-directive_ _statements_\_?\_ \
_if-directive_ → *`#if`* \
_elseif-directive_ → *`#elseif`* \
_else-directive_ → *`#else`* \
_endif-directive_ → *`#endif`*

_compilation-condition_ → _platform-condition_ \
_compilation-condition_ → _identifier_ \
_compilation-condition_ → _boolean-literal_ \
_compilation-condition_ → *`(`* _compilation-condition_ *`)`* \
_compilation-condition_ → *`!`* _compilation-condition_ \
_compilation-condition_ → _compilation-condition_ *`&&`* _compilation-condition_ \
_compilation-condition_ → _compilation-condition_ *`||`* _compilation-condition_

_platform-condition_ → *`os`* *`(`* _operating-system_ *`)`* \
_platform-condition_ → *`arch`* *`(`* _architecture_ *`)`* \
_platform-condition_ → *`swift`* *`(`* *`>=`* _swift-version_ *`)`* | *`swift`* *`(`* *`<`* _swift-version_ *`)`* \
_platform-condition_ → *`compiler`* *`(`* *`>=`* _swift-version_ *`)`* | *`compiler`* *`(`* *`<`* _swift-version_ *`)`* \
_platform-condition_ → *`canImport`* *`(`* _import-path_ *`)`* \
_platform-condition_ → *`targetEnvironment`* *`(`* _environment_ *`)`*

_operating-system_ → *`macOS`* | *`iOS`* | *`watchOS`* | *`tvOS`* | *`visionOS`* | *`Linux`* | *`Windows`* \
_architecture_ → *`i386`* | *`x86_64`* | *`arm`* | *`arm64`* \
_swift-version_ → _decimal-digits_ _swift-version-continuation_\_?\_ \
_swift-version-continuation_ → *`.`* _decimal-digits_ _swift-version-continuation_\_?\_ \
_environment_ → *`simulator`* | *`macCatalyst`*
]

#grammar-block(title: "Grammar of a line control statement")[
_line-control-statement_ → *`#sourceLocation`* *`(`* *`file:`* _file-path_ *`,`* *`line:`* _line-number_ *`)`* \
_line-control-statement_ → *`#sourceLocation`* *`(`* *`)`* \
_line-number_ → A decimal integer greater than zero \
_file-path_ → _static-string-literal_
]

#grammar-block(title: "Grammar of an availability condition")[
_availability-condition_ → *`#available`* *`(`* _availability-arguments_ *`)`* \
_availability-condition_ → *`#unavailable`* *`(`* _availability-arguments_ *`)`* \
_availability-arguments_ → _availability-argument_ | _availability-argument_ *`,`* _availability-arguments_ \
_availability-argument_ → _platform-name_ _platform-version_ \
_availability-argument_ → *`*`*

_platform-name_ → *`iOS`* | *`iOSApplicationExtension`* \
_platform-name_ → *`macOS`* | *`macOSApplicationExtension`* \
_platform-name_ → *`macCatalyst`* | *`macCatalystApplicationExtension`* \
_platform-name_ → *`watchOS`* | *`watchOSApplicationExtension`* \
_platform-name_ → *`tvOS`* | *`tvOSApplicationExtension`* \
_platform-name_ → *`visionOS`* | *`visionOSApplicationExtension`* \
_platform-version_ → _decimal-digits_ \
_platform-version_ → _decimal-digits_ *`.`* _decimal-digits_ \
_platform-version_ → _decimal-digits_ *`.`* _decimal-digits_ *`.`* _decimal-digits_
]

== Declarations

#grammar-block(title: "Grammar of a declaration")[
_declaration_ → _import-declaration_ \
_declaration_ → _constant-declaration_ \
_declaration_ → _variable-declaration_ \
_declaration_ → _typealias-declaration_ \
_declaration_ → _function-declaration_ \
_declaration_ → _enum-declaration_ \
_declaration_ → _struct-declaration_ \
_declaration_ → _class-declaration_ \
_declaration_ → _actor-declaration_ \
_declaration_ → _protocol-declaration_ \
_declaration_ → _initializer-declaration_ \
_declaration_ → _deinitializer-declaration_ \
_declaration_ → _extension-declaration_ \
_declaration_ → _subscript-declaration_ \
_declaration_ → _operator-declaration_ \
_declaration_ → _precedence-group-declaration_
]

#grammar-block(title: "Grammar of a top-level declaration")[
_top-level-declaration_ → _statements_\_?\_
]

#grammar-block(title: "Grammar of a code block")[
_code-block_ → *`{`* _statements_\_?\_ *`}`*
]

#grammar-block(title: "Grammar of an import declaration")[
_import-declaration_ → _attributes_\_?\_ *`import`* _import-kind_\_?\_ _import-path_

_import-kind_ → *`typealias`* | *`struct`* | *`class`* | *`enum`* | *`protocol`* | *`let`* | *`var`* | *`func`* \
_import-path_ → _identifier_ | _identifier_ *`.`* _import-path_
]

#grammar-block(title: "Grammar of a constant declaration")[
_constant-declaration_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`let`* _pattern-initializer-list_

_pattern-initializer-list_ → _pattern-initializer_ | _pattern-initializer_ *`,`* _pattern-initializer-list_ \
_pattern-initializer_ → _pattern_ _initializer_\_?\_ \
_initializer_ → *`=`* _expression_
]

#grammar-block(title: "Grammar of a variable declaration")[
_variable-declaration_ → _variable-declaration-head_ _pattern-initializer-list_ \
_variable-declaration_ → _variable-declaration-head_ _variable-name_ _type-annotation_ _code-block_ \
_variable-declaration_ → _variable-declaration-head_ _variable-name_ _type-annotation_ _getter-setter-block_ \
_variable-declaration_ → _variable-declaration-head_ _variable-name_ _type-annotation_ _getter-setter-keyword-block_ \
_variable-declaration_ → _variable-declaration-head_ _variable-name_ _initializer_ _willSet-didSet-block_ \
_variable-declaration_ → _variable-declaration-head_ _variable-name_ _type-annotation_ _initializer_\_?\_ _willSet-didSet-block_

_variable-declaration-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`var`* \
_variable-name_ → _identifier_

_getter-setter-block_ → _code-block_ \
_getter-setter-block_ → *`{`* _getter-clause_ _setter-clause_\_?\_ *`}`* \
_getter-setter-block_ → *`{`* _setter-clause_ _getter-clause_ *`}`* \
_getter-clause_ → _attributes_\_?\_ _mutation-modifier_\_?\_ *`get`* _code-block_ \
_setter-clause_ → _attributes_\_?\_ _mutation-modifier_\_?\_ *`set`* _setter-name_\_?\_ _code-block_ \
_setter-name_ → *`(`* _identifier_ *`)`*

_getter-setter-keyword-block_ → *`{`* _getter-keyword-clause_ _setter-keyword-clause_\_?\_ *`}`* \
_getter-setter-keyword-block_ → *`{`* _setter-keyword-clause_ _getter-keyword-clause_ *`}`* \
_getter-keyword-clause_ → _attributes_\_?\_ _mutation-modifier_\_?\_ *`get`* \
_setter-keyword-clause_ → _attributes_\_?\_ _mutation-modifier_\_?\_ *`set`*

_willSet-didSet-block_ → *`{`* _willSet-clause_ _didSet-clause_\_?\_ *`}`* \
_willSet-didSet-block_ → *`{`* _didSet-clause_ _willSet-clause_\_?\_ *`}`* \
_willSet-clause_ → _attributes_\_?\_ *`willSet`* _setter-name_\_?\_ _code-block_ \
_didSet-clause_ → _attributes_\_?\_ *`didSet`* _setter-name_\_?\_ _code-block_
]

#grammar-block(title: "Grammar of a type alias declaration")[
_typealias-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`typealias`* _typealias-name_ _generic-parameter-clause_\_?\_ _typealias-assignment_ \
_typealias-name_ → _identifier_ \
_typealias-assignment_ → *`=`* _type_
]

#grammar-block(title: "Grammar of a function declaration")[
_function-declaration_ → _function-head_ _function-name_ _generic-parameter-clause_\_?\_ _function-signature_ _generic-where-clause_\_?\_ _function-body_\_?\_

_function-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`func`* \
_function-name_ → _identifier_ | _operator_

_function-signature_ → _parameter-clause_ *`async`*\_?\_ _throws-clause_\_?\_ _function-result_\_?\_ \
_function-signature_ → _parameter-clause_ *`async`*\_?\_ *`rethrows`* _function-result_\_?\_ \
_function-result_ → *`->`* _attributes_\_?\_ _type_ \
_function-body_ → _code-block_

_parameter-clause_ → *`(`* *`)`* | *`(`* _parameter-list_ *`)`* \
_parameter-list_ → _parameter_ | _parameter_ *`,`* _parameter-list_ \
_parameter_ → _external-parameter-name_\_?\_ _local-parameter-name_ _parameter-type-annotation_ _default-argument-clause_\_?\_ \
_parameter_ → _external-parameter-name_\_?\_ _local-parameter-name_ _parameter-type-annotation_ \
_parameter_ → _external-parameter-name_\_?\_ _local-parameter-name_ _parameter-type-annotation_ *`...`*

_external-parameter-name_ → _identifier_ \
_local-parameter-name_ → _identifier_ \
_parameter-type-annotation_ → *`:`* _attributes_\_?\_ _parameter-modifier_\_?\_ _type_ \
_parameter-modifier_ → *`inout`* | *`borrowing`* | *`consuming`*
_default-argument-clause_ → *`=`* _expression_
]

#grammar-block(title: "Grammar of an enumeration declaration")[
_enum-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ _union-style-enum_ \
_enum-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ _raw-value-style-enum_

_union-style-enum_ → *`indirect`*\_?\_ *`enum`* _enum-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ *`{`* _union-style-enum-members_\_?\_ *`}`* \
_union-style-enum-members_ → _union-style-enum-member_ _union-style-enum-members_\_?\_ \
_union-style-enum-member_ → _declaration_ | _union-style-enum-case-clause_ | _compiler-control-statement_ \
_union-style-enum-case-clause_ → _attributes_\_?\_ *`indirect`*\_?\_ *`case`* _union-style-enum-case-list_ \
_union-style-enum-case-list_ → _union-style-enum-case_ | _union-style-enum-case_ *`,`* _union-style-enum-case-list_ \
_union-style-enum-case_ → _enum-case-name_ _tuple-type_\_?\_ \
_enum-name_ → _identifier_ \
_enum-case-name_ → _identifier_

_raw-value-style-enum_ → *`enum`* _enum-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_ _generic-where-clause_\_?\_ *`{`* _raw-value-style-enum-members_ *`}`* \
_raw-value-style-enum-members_ → _raw-value-style-enum-member_ _raw-value-style-enum-members_\_?\_ \
_raw-value-style-enum-member_ → _declaration_ | _raw-value-style-enum-case-clause_ | _compiler-control-statement_ \
_raw-value-style-enum-case-clause_ → _attributes_\_?\_ *`case`* _raw-value-style-enum-case-list_ \
_raw-value-style-enum-case-list_ → _raw-value-style-enum-case_ | _raw-value-style-enum-case_ *`,`* _raw-value-style-enum-case-list_ \
_raw-value-style-enum-case_ → _enum-case-name_ _raw-value-assignment_\_?\_ \
_raw-value-assignment_ → *`=`* _raw-value-literal_ \
_raw-value-literal_ → _numeric-literal_ | _static-string-literal_ | _boolean-literal_
]

#grammar-block(title: "Grammar of a structure declaration")[
_struct-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`struct`* _struct-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _struct-body_ \
_struct-name_ → _identifier_ \
_struct-body_ → *`{`* _struct-members_\_?\_ *`}`*

_struct-members_ → _struct-member_ _struct-members_\_?\_ \
_struct-member_ → _declaration_ | _compiler-control-statement_
]

#grammar-block(title: "Grammar of a class declaration")[
_class-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`final`*\_?\_ *`class`* _class-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _class-body_ \
_class-declaration_ → _attributes_\_?\_ *`final`* _access-level-modifier_\_?\_ *`class`* _class-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _class-body_ \
_class-name_ → _identifier_ \
_class-body_ → *`{`* _class-members_\_?\_ *`}`*

_class-members_ → _class-member_ _class-members_\_?\_ \
_class-member_ → _declaration_ | _compiler-control-statement_
]

#grammar-block(title: "Grammar of an actor declaration")[
_actor-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`actor`* _actor-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _actor-body_ \
_actor-name_ → _identifier_ \
_actor-body_ → *`{`* _actor-members_\_?\_ *`}`*

_actor-members_ → _actor-member_ _actor-members_\_?\_ \
_actor-member_ → _declaration_ | _compiler-control-statement_
]

#grammar-block(title: "Grammar of a protocol declaration")[
_protocol-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`protocol`* _protocol-name_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _protocol-body_ \
_protocol-name_ → _identifier_ \
_protocol-body_ → *`{`* _protocol-members_\_?\_ *`}`*

_protocol-members_ → _protocol-member_ _protocol-members_\_?\_ \
_protocol-member_ → _protocol-member-declaration_ | _compiler-control-statement_

_protocol-member-declaration_ → _protocol-property-declaration_ \
_protocol-member-declaration_ → _protocol-method-declaration_ \
_protocol-member-declaration_ → _protocol-initializer-declaration_ \
_protocol-member-declaration_ → _protocol-subscript-declaration_ \
_protocol-member-declaration_ → _protocol-associated-type-declaration_ \
_protocol-member-declaration_ → _typealias-declaration_
]

#grammar-block(title: "Grammar of a protocol property declaration")[
_protocol-property-declaration_ → _variable-declaration-head_ _variable-name_ _type-annotation_ _getter-setter-keyword-block_
]

#grammar-block(title: "Grammar of a protocol method declaration")[
_protocol-method-declaration_ → _function-head_ _function-name_ _generic-parameter-clause_\_?\_ _function-signature_ _generic-where-clause_\_?\_
]

#grammar-block(title: "Grammar of a protocol initializer declaration")[
_protocol-initializer-declaration_ → _initializer-head_ _generic-parameter-clause_\_?\_ _parameter-clause_ _throws-clause_\_?\_ _generic-where-clause_\_?\_ \
_protocol-initializer-declaration_ → _initializer-head_ _generic-parameter-clause_\_?\_ _parameter-clause_ *`rethrows`* _generic-where-clause_\_?\_
]

#grammar-block(title: "Grammar of a protocol subscript declaration")[
_protocol-subscript-declaration_ → _subscript-head_ _subscript-result_ _generic-where-clause_\_?\_ _getter-setter-keyword-block_
]

#grammar-block(title: "Grammar of a protocol associated type declaration")[
_protocol-associated-type-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`associatedtype`* _typealias-name_ _type-inheritance-clause_\_?\_ _typealias-assignment_\_?\_ _generic-where-clause_\_?\_
]

#grammar-block(title: "Grammar of an initializer declaration")[
_initializer-declaration_ → _initializer-head_ _generic-parameter-clause_\_?\_ _parameter-clause_ *`async`*\_?\_ _throws-clause_\_?\_ _generic-where-clause_\_?\_ _initializer-body_ \
_initializer-declaration_ → _initializer-head_ _generic-parameter-clause_\_?\_ _parameter-clause_ *`async`*\_?\_ *`rethrows`* _generic-where-clause_\_?\_ _initializer-body_ \
_initializer-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`init`* \
_initializer-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`init`* *`?`* \
_initializer-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`init`* *`!`* \
_initializer-body_ → _code-block_
]

#grammar-block(title: "Grammar of a deinitializer declaration")[
_deinitializer-declaration_ → _attributes_\_?\_ *`deinit`* _code-block_
]

#grammar-block(title: "Grammar of an extension declaration")[
_extension-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`extension`* _type-identifier_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _extension-body_ \
_extension-body_ → *`{`* _extension-members_\_?\_ *`}`*

_extension-members_ → _extension-member_ _extension-members_\_?\_ \
_extension-member_ → _declaration_ | _compiler-control-statement_
]

#grammar-block(title: "Grammar of a subscript declaration")[
_subscript-declaration_ → _subscript-head_ _subscript-result_ _generic-where-clause_\_?\_ _code-block_ \
_subscript-declaration_ → _subscript-head_ _subscript-result_ _generic-where-clause_\_?\_ _getter-setter-block_ \
_subscript-declaration_ → _subscript-head_ _subscript-result_ _generic-where-clause_\_?\_ _getter-setter-keyword-block_ \
_subscript-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`subscript`* _generic-parameter-clause_\_?\_ _parameter-clause_ \
_subscript-result_ → *`->`* _attributes_\_?\_ _type_
]

#grammar-block(title: "Grammar of a macro declaration")[
_macro-declaration_ → _macro-head_ _identifier_ _generic-parameter-clause_\_?\_ _macro-signature_ _macro-definition_\_?\_ _generic-where-clause_ \
_macro-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`macro`*  \
_macro-signature_ → _parameter-clause_ _macro-function-signature-result_\_?\_ \
_macro-function-signature-result_ → *`->`* _type_ \
_macro-definition_ → *`=`* _expression_
]

#grammar-block(title: "Grammar of an operator declaration")[
_operator-declaration_ → _prefix-operator-declaration_ | _postfix-operator-declaration_ | _infix-operator-declaration_

_prefix-operator-declaration_ → *`prefix`* *`operator`* _operator_ \
_postfix-operator-declaration_ → *`postfix`* *`operator`* _operator_ \
_infix-operator-declaration_ → *`infix`* *`operator`* _operator_ _infix-operator-group_\_?\_

_infix-operator-group_ → *`:`* _precedence-group-name_
]

#grammar-block(title: "Grammar of a precedence group declaration")[
_precedence-group-declaration_ → *`precedencegroup`* _precedence-group-name_ *`{`* _precedence-group-attributes_\_?\_ *`}`*

_precedence-group-attributes_ → _precedence-group-attribute_ _precedence-group-attributes_\_?\_ \
_precedence-group-attribute_ → _precedence-group-relation_ \
_precedence-group-attribute_ → _precedence-group-assignment_ \
_precedence-group-attribute_ → _precedence-group-associativity_

_precedence-group-relation_ → *`higherThan`* *`:`* _precedence-group-names_ \
_precedence-group-relation_ → *`lowerThan`* *`:`* _precedence-group-names_

_precedence-group-assignment_ → *`assignment`* *`:`* _boolean-literal_

_precedence-group-associativity_ → *`associativity`* *`:`* *`left`* \
_precedence-group-associativity_ → *`associativity`* *`:`* *`right`* \
_precedence-group-associativity_ → *`associativity`* *`:`* *`none`*

_precedence-group-names_ → _precedence-group-name_ | _precedence-group-name_ *`,`* _precedence-group-names_ \
_precedence-group-name_ → _identifier_
]

#grammar-block(title: "Grammar of a declaration modifier")[
_declaration-modifier_ → *`class`* | *`convenience`* | *`dynamic`* | *`final`* | *`infix`* | *`lazy`* | *`optional`* | *`override`* | *`postfix`* | *`prefix`* | *`required`* | *`static`* | *`unowned`* | *`unowned`* *`(`* *`safe`* *`)`* | *`unowned`* *`(`* *`unsafe`* *`)`* | *`weak`* \
_declaration-modifier_ → _access-level-modifier_ \
_declaration-modifier_ → _mutation-modifier_ \
_declaration-modifier_ → _actor-isolation-modifier_ \
_declaration-modifiers_ → _declaration-modifier_ _declaration-modifiers_\_?\_

_access-level-modifier_ → *`private`* | *`private`* *`(`* *`set`* *`)`* \
_access-level-modifier_ → *`fileprivate`* | *`fileprivate`* *`(`* *`set`* *`)`* \
_access-level-modifier_ → *`internal`* | *`internal`* *`(`* *`set`* *`)`* \
_access-level-modifier_ → *`package`* | *`package`* *`(`* *`set`* *`)`* \
_access-level-modifier_ → *`public`* | *`public`* *`(`* *`set`* *`)`* \
_access-level-modifier_ → *`open`* | *`open`* *`(`* *`set`* *`)`*

_mutation-modifier_ → *`mutating`* | *`nonmutating`*

_actor-isolation-modifier_ → *`nonisolated`*
]

== Attributes

#grammar-block(title: "Grammar of an attribute")[
_attribute_ → *`@`* _attribute-name_ _attribute-argument-clause_\_?\_ \
_attribute-name_ → _identifier_ \
_attribute-argument-clause_ → *`(`* _balanced-tokens_\_?\_ *`)`* \
_attributes_ → _attribute_ _attributes_\_?\_

_balanced-tokens_ → _balanced-token_ _balanced-tokens_\_?\_ \
_balanced-token_ → *`(`* _balanced-tokens_\_?\_ *`)`* \
_balanced-token_ → *`[`* _balanced-tokens_\_?\_ *`]`* \
_balanced-token_ → *`{`* _balanced-tokens_\_?\_ *`}`* \
_balanced-token_ → Any identifier, keyword, literal, or operator \
_balanced-token_ → Any punctuation except  *`(`*,  *`)`*,  *`[`*,  *`]`*,  *`{`*, or  *`}`*
]

== Patterns

#grammar-block(title: "Grammar of a pattern")[
_pattern_ → _wildcard-pattern_ _type-annotation_\_?\_ \
_pattern_ → _identifier-pattern_ _type-annotation_\_?\_ \
_pattern_ → _value-binding-pattern_ \
_pattern_ → _tuple-pattern_ _type-annotation_\_?\_ \
_pattern_ → _enum-case-pattern_ \
_pattern_ → _optional-pattern_ \
_pattern_ → _type-casting-pattern_ \
_pattern_ → _expression-pattern_
]

#grammar-block(title: "Grammar of a wildcard pattern")[
_wildcard-pattern_ → *`_`*
]

#grammar-block(title: "Grammar of an identifier pattern")[
_identifier-pattern_ → _identifier_
]

#grammar-block(title: "Grammar of a value-binding pattern")[
_value-binding-pattern_ → *`var`* _pattern_ | *`let`* _pattern_
]

#grammar-block(title: "Grammar of a tuple pattern")[
_tuple-pattern_ → *`(`* _tuple-pattern-element-list_\_?\_ *`)`* \
_tuple-pattern-element-list_ → _tuple-pattern-element_ | _tuple-pattern-element_ *`,`* _tuple-pattern-element-list_ \
_tuple-pattern-element_ → _pattern_ | _identifier_ *`:`* _pattern_
]

#grammar-block(title: "Grammar of an enumeration case pattern")[
_enum-case-pattern_ → _type-identifier_\_?\_ *`.`* _enum-case-name_ _tuple-pattern_\_?\_
]

#grammar-block(title: "Grammar of an optional pattern")[
_optional-pattern_ → _identifier-pattern_ *`?`*
]

#grammar-block(title: "Grammar of a type casting pattern")[
_type-casting-pattern_ → _is-pattern_ | _as-pattern_ \
_is-pattern_ → *`is`* _type_ \
_as-pattern_ → _pattern_ *`as`* _type_
]

#grammar-block(title: "Grammar of an expression pattern")[
_expression-pattern_ → _expression_
]

== Generic Parameters and Arguments

#grammar-block(title: "Grammar of a generic parameter clause")[
_generic-parameter-clause_ → *`<`* _generic-parameter-list_ *`>`* \
_generic-parameter-list_ → _generic-parameter_ | _generic-parameter_ *`,`* _generic-parameter-list_ \
_generic-parameter_ → _type-name_ \
_generic-parameter_ → _type-name_ *`:`* _type-identifier_ \
_generic-parameter_ → _type-name_ *`:`* _protocol-composition-type_

_generic-where-clause_ → *`where`* _requirement-list_ \
_requirement-list_ → _requirement_ | _requirement_ *`,`* _requirement-list_ \
_requirement_ → _conformance-requirement_ | _same-type-requirement_

_conformance-requirement_ → _type-identifier_ *`:`* _type-identifier_ \
_conformance-requirement_ → _type-identifier_ *`:`* _protocol-composition-type_ \
_same-type-requirement_ → _type-identifier_ *`==`* _type_
]

#grammar-block(title: "Grammar of a generic argument clause")[
_generic-argument-clause_ → *`<`* _generic-argument-list_ *`>`* \
_generic-argument-list_ → _generic-argument_ | _generic-argument_ *`,`* _generic-argument-list_ \
_generic-argument_ → _type_
]




