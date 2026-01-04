#import "@local/eightbyten:0.1.0": *
#import "../utils.typ": grammar-block, experiment, important, deprecated, memo


#chapter("Statements", eyebrow: "Grouping and control flow")

In Swift, there are three kinds of statements: simple statements, compiler control statements,
and control flow statements.
Simple statements are the most common and consist of either an expression or a declaration.
Compiler control statements allow the program to change aspects of the compiler's behavior
and include a conditional compilation block and a line control statement.

Control flow statements are used to control the flow of execution in a program.
There are several types of control flow statements in Swift, including
loop statements, branch statements, and control transfer statements.
Loop statements allow a block of code to be executed repeatedly,
branch statements allow a certain block of code to be executed
only when certain conditions are met,
and control transfer statements provide a way to alter the order in which code is executed.
In addition, Swift provides a `do` statement to introduce scope,
and catch and handle errors,
and a `defer` statement for running cleanup actions just before the current scope exits.

A semicolon (`;`) can optionally appear after any statement
and is used to separate multiple statements if they appear on the same line.

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



== Loop Statements

Loop statements allow a block of code to be executed repeatedly,
depending on the conditions specified in the loop.
Swift has three loop statements:
a `for`-`in` statement,
a `while` statement,
and a `repeat`-`while` statement.

Control flow in a loop statement can be changed by a `break` statement
and a `continue` statement and is discussed in Statements\#Break-Statement and
Statements\#Continue-Statement below.

#grammar-block(title: "Grammar of a loop statement")[
_loop-statement_ → _for-in-statement_ \
_loop-statement_ → _while-statement_ \
_loop-statement_ → _repeat-while-statement_
]

=== For-In Statement

A `for`-`in` statement allows a block of code to be executed
once for each item in a collection (or any type)
that conforms to the
#link("https://developer.apple.com/documentation/swift/sequence")[`Sequence`] protocol.

A `for`-`in` statement has the following form:

```swift
for item in collection {
   statements
}
```

The `makeIterator()` method is called on the _collection_ expression
to obtain a value of an iterator type --- that is,
a type that conforms to the
#link("https://developer.apple.com/documentation/swift/iteratorprotocol")[`IteratorProtocol`] protocol.
The program begins executing a loop
by calling the `next()` method on the iterator.
If the value returned isn't `nil`,
it's assigned to the _item_ pattern,
the program executes the _statements_,
and then continues execution at the beginning of the loop.
Otherwise, the program doesn't perform assignment or execute the _statements_,
and it's finished executing the `for`-`in` statement.

#grammar-block(title: "Grammar of a for-in statement")[
_for-in-statement_ → *`for`* *`case`*\_?\_ _pattern_ *`in`* _expression_ _where-clause_\_?\_ _code-block_
]

=== While Statement

A `while` statement allows a block of code to be executed repeatedly,
as long as a condition remains true.

A `while` statement has the following form:

```swift
while condition {
   statements
}
```

A `while` statement is executed as follows:

+ The _condition_ is evaluated.

   If `true`, execution continues to step 2.
   If `false`, the program is finished executing the `while` statement.
+ The program executes the _statements_, and execution returns to step 1.

Because the value of the _condition_ is evaluated before the _statements_ are executed,
the _statements_ in a `while` statement can be executed zero or more times.

The value of the _condition_
must be of type `Bool` or a type bridged to `Bool`.
The condition can also be an optional binding declaration,
as discussed in TheBasics\#Optional-Binding.

#grammar-block(title: "Grammar of a while statement")[
_while-statement_ → *`while`* _condition-list_ _code-block_

_condition-list_ → _condition_ | _condition_ *`,`* _condition-list_ \
_condition_ → _expression_ | _availability-condition_ | _case-condition_ | _optional-binding-condition_

_case-condition_ → *`case`* _pattern_ _initializer_ \
_optional-binding-condition_ → *`let`* _pattern_ _initializer_\_?\_ | *`var`* _pattern_ _initializer_\_?\_
]

=== Repeat-While Statement

A `repeat`-`while` statement allows a block of code to be executed one or more times,
as long as a condition remains true.

A `repeat`-`while` statement has the following form:

```swift
repeat {
   statements
} while condition
```

A `repeat`-`while` statement is executed as follows:

+ The program executes the _statements_,
   and execution continues to step 2.
+ The _condition_ is evaluated.

   If `true`, execution returns to step 1.
   If `false`, the program is finished executing the `repeat`-`while` statement.

Because the value of the _condition_ is evaluated after the _statements_ are executed,
the _statements_ in a `repeat`-`while` statement are executed at least once.

The value of the _condition_
must be of type `Bool` or a type bridged to `Bool`.

#grammar-block(title: "Grammar of a repeat-while statement")[
_repeat-while-statement_ → *`repeat`* _code-block_ *`while`* _expression_
]

== Branch Statements

Branch statements allow the program to execute certain parts of code
depending on the value of one or more conditions.
The values of the conditions specified in a branch statement
control how the program branches and, therefore, what block of code is executed.
Swift has three branch statements:
an `if` statement, a `guard` statement, and a `switch` statement.

Control flow in an `if` statement or a `switch` statement can be changed by a `break` statement
and is discussed in Statements\#Break-Statement below.

#grammar-block(title: "Grammar of a branch statement")[
_branch-statement_ → _if-statement_ \
_branch-statement_ → _guard-statement_ \
_branch-statement_ → _switch-statement_
]

=== If Statement

An `if` statement is used for executing code
based on the evaluation of one or more conditions.

There are two basic forms of an `if` statement.
In each form, the opening and closing braces are required.

The first form allows code to be executed only when a condition is true
and has the following form:

```swift
if condition {
   statements
}
```

The second form of an `if` statement provides an additional _else clause_
(introduced by the `else` keyword)
and is used for executing one part of code when the condition is true
and another part of code when the same condition is false.
When a single else clause is present, an `if` statement has the following form:

```swift
if condition {
   statements to execute if condition is true
} else {
   statements to execute if condition is false
}
```

The else clause of an `if` statement can contain another `if` statement
to test more than one condition.
An `if` statement chained together in this way has the following form:

```swift
if condition 1 {
   statements to execute if condition 1 is true
} else if condition 2 {
   statements to execute if condition 2 is true
} else {
   statements to execute if both conditions are false
}
```

The value of any condition in an `if` statement
must be of type `Bool` or a type bridged to `Bool`.
The condition can also be an optional binding declaration,
as discussed in TheBasics\#Optional-Binding.

#grammar-block(title: "Grammar of an if statement")[
_if-statement_ → *`if`* _condition-list_ _code-block_ _else-clause_\_?\_ \
_else-clause_ → *`else`* _code-block_ | *`else`* _if-statement_
]

=== Guard Statement

A `guard` statement is used to transfer program control out of a scope
if one or more conditions aren't met.

A `guard` statement has the following form:

```swift
guard condition else {
   statements
}
```

The value of any condition in a `guard` statement
must be of type `Bool` or a type bridged to `Bool`.
The condition can also be an optional binding declaration,
as discussed in TheBasics\#Optional-Binding.

Any constants or variables assigned a value
from an optional binding declaration in a `guard` statement condition
can be used for the rest of the guard statement's enclosing scope.

The `else` clause of a `guard` statement is required,
and must either call a function with the `Never` return type
or transfer program control outside the guard statement's enclosing scope
using one of the following statements:

- `return`
- `break`
- `continue`
- `throw`

Control transfer statements are discussed in Statements\#Control-Transfer-Statements below.
For more information on functions with the `Never` return type,
see Declarations\#Functions-that-Never-Return.

#grammar-block(title: "Grammar of a guard statement")[
_guard-statement_ → *`guard`* _condition-list_ *`else`* _code-block_
]

=== Switch Statement

A `switch` statement allows certain blocks of code to be executed
depending on the value of a control expression.

A `switch` statement has the following form:

```swift
switch control expression {
case pattern 1:
    statements
case pattern 2 where condition:
    statements
case pattern 3 where condition,
    pattern 4 where condition:
    statements
default:
    statements
}
```

The _control expression_ of the `switch` statement is evaluated
and then compared with the patterns specified in each case.
If a match is found,
the program executes the _statements_ listed within the scope of that case.
The scope of each case can't be empty.
As a result, you must include at least one statement
following the colon (`:`) of each case label. Use a single `break` statement
if you don't intend to execute any code in the body of a matched case.

The values of expressions your code can branch on are very flexible. For example,
in addition to the values of scalar types, such as integers and characters,
your code can branch on the values of any type, including floating-point numbers, strings,
tuples, instances of custom classes, and optionals.
The value of the _control expression_ can even be matched to the value of a case in an enumeration
and checked for inclusion in a specified range of values.
For examples of how to use these various types of values in `switch` statements,
see ControlFlow\#Switch in ControlFlow.

A `switch` case can optionally contain a `where` clause after each pattern.
A _where clause_ is introduced by the `where` keyword followed by an expression,
and is used to provide an additional condition
before a pattern in a case is considered matched to the _control expression_.
If a `where` clause is present, the _statements_ within the relevant case
are executed only if the value of the _control expression_
matches one of the patterns of the case and the expression of the `where` clause evaluates to `true`.
For example, a _control expression_ matches the case in the example below
only if it's a tuple that contains two elements of the same value, such as `(1, 1)`.

```swift
case let (x, y) where x == y:
```



As the above example shows, patterns in a case can also bind constants
using the `let` keyword (they can also bind variables using the `var` keyword).
These constants (or variables) can then be referenced in a corresponding `where` clause
and throughout the rest of the code within the scope of the case.
If the case contains multiple patterns that match the control expression,
all of the patterns must contain the same constant or variable bindings,
and each bound variable or constant must have the same type
in all of the case's patterns.



A `switch` statement can also include a default case, introduced by the `default` keyword.
The code within a default case is executed only if no other cases match the control expression.
A `switch` statement can include only one default case,
which must appear at the end of the `switch` statement.

Although the actual execution order of pattern-matching operations,
and in particular the evaluation order of patterns in cases, is unspecified,
pattern matching in a `switch` statement behaves
as if the evaluation is performed in source order --- that is,
the order in which they appear in source code.
As a result, if multiple cases contain patterns that evaluate to the same value,
and thus can match the value of the control expression,
the program executes only the code within the first matching case in source order.





==== Switch Statements Must Be Exhaustive

In Swift,
every possible value of the control expression’s type
must match the value of at least one pattern of a case.
When this simply isn’t feasible
(for example, when the control expression’s type is `Int`),
you can include a default case to satisfy the requirement.

==== Switching Over Future Enumeration Cases

A _nonfrozen enumeration_ is a special kind of enumeration
that may gain new enumeration cases in the future ---
even after you compile and ship an app.
Switching over a nonfrozen enumeration requires extra consideration.
When a library's authors mark an enumeration as nonfrozen,
they reserve the right to add new enumeration cases,
and any code that interacts with that enumeration
_must_ be able to handle those future cases without being recompiled.
Code that's compiled in library evolution mode,
code in the Swift standard library,
Swift overlays for Apple frameworks,
and C and Objective-C code can declare nonfrozen enumerations.
For information about frozen and nonfrozen enumerations,
see Attributes\#frozen.

When switching over a nonfrozen enumeration value,
you always need to include a default case,
even if every case of the enumeration already has a corresponding switch case.
You can apply the `@unknown` attribute to the default case,
which indicates that the default case should match only enumeration cases
that are added in the future.
Swift produces a warning
if the default case matches
any enumeration case that's known at compile time.
This future warning informs you that the library author
added a new case to the enumeration
that doesn't have a corresponding switch case.

The following example switches over all three existing cases of
the Swift standard library's #link("https://developer.apple.com/documentation/swift/mirror/ancestorrepresentation")[`Mirror.AncestorRepresentation`]
enumeration.
If you add additional cases in the future,
the compiler generates a warning to indicate
that you need to update the switch statement
to take the new cases into account.

```swift
let representation: Mirror.AncestorRepresentation = .generated
switch representation {
case .customized:
    print("Use the nearest ancestor’s implementation.")
case .generated:
    print("Generate a default mirror for all ancestor classes.")
case .suppressed:
    print("Suppress the representation of all ancestor classes.")
@unknown default:
    print("Use a representation that was unknown when this code was compiled.")
}
// Prints "Generate a default mirror for all ancestor classes."
```



==== Execution Does Not Fall Through Cases Implicitly

After the code within a matched case has finished executing,
the program exits from the `switch` statement.
Program execution doesn't continue or "fall through" to the next case or default case.
That said, if you want execution to continue from one case to the next,
explicitly include a `fallthrough` statement,
which simply consists of the `fallthrough` keyword,
in the case from which you want execution to continue.
For more information about the `fallthrough` statement,
see Statements\#Fallthrough-Statement below.

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



== Labeled Statement

You can prefix a loop statement, an `if` statement, a `switch` statement,
or a `do` statement with a _statement label_,
which consists of the name of the label followed immediately by a colon (:).
Use statement labels with `break` and `continue` statements to be explicit
about how you want to change control flow in a loop statement or a `switch` statement,
as discussed in Statements\#Break-Statement and
Statements\#Continue-Statement below.

The scope of a labeled statement is the entire statement following the statement label.
You can nest labeled statements, but the name of each statement label must be unique.

For more information and to see examples
of how to use statement labels,
see ControlFlow\#Labeled-Statements in ControlFlow.



#grammar-block(title: "Grammar of a labeled statement")[
_labeled-statement_ → _statement-label_ _loop-statement_ \
_labeled-statement_ → _statement-label_ _if-statement_ \
_labeled-statement_ → _statement-label_ _switch-statement_ \
_labeled-statement_ → _statement-label_ _do-statement_

_statement-label_ → _label-name_ *`:`* \
_label-name_ → _identifier_
]

== Control Transfer Statements

Control transfer statements can change the order in which code in your program is executed
by unconditionally transferring program control from one piece of code to another.
Swift has five control transfer statements: a `break` statement, a `continue` statement,
a `fallthrough` statement, a `return` statement, and a `throw` statement.

#grammar-block(title: "Grammar of a control transfer statement")[
_control-transfer-statement_ → _break-statement_ \
_control-transfer-statement_ → _continue-statement_ \
_control-transfer-statement_ → _fallthrough-statement_ \
_control-transfer-statement_ → _return-statement_ \
_control-transfer-statement_ → _throw-statement_
]

=== Break Statement

A `break` statement ends program execution of a loop,
an `if` statement, or a `switch` statement.
A `break` statement can consist of only the `break` keyword,
or it can consist of the `break` keyword followed by the name of a statement label,
as shown below.

```swift
break
break label name
```

When a `break` statement is followed by the name of a statement label,
it ends program execution of the loop,
`if` statement, or `switch` statement named by that label.

When a `break` statement isn't followed by the name of a statement label,
it ends program execution of the `switch` statement or the innermost enclosing loop
statement in which it occurs.
You can't use an unlabeled `break` statement to break out of an `if` statement.

In both cases, program control is then transferred to the first line
of code following the enclosing loop or `switch` statement, if any.

For examples of how to use a `break` statement,
see ControlFlow\#Break and ControlFlow\#Labeled-Statements
in ControlFlow.

#grammar-block(title: "Grammar of a break statement")[
_break-statement_ → *`break`* _label-name_\_?\_
]

=== Continue Statement

A `continue` statement ends program execution of the current iteration of a loop
statement but doesn't stop execution of the loop statement.
A `continue` statement can consist of only the `continue` keyword,
or it can consist of the `continue` keyword followed by the name of a statement label,
as shown below.

```swift
continue
continue label name
```

When a `continue` statement is followed by the name of a statement label,
it ends program execution of the current iteration
of the loop statement named by that label.

When a `continue` statement isn't followed by the name of a statement label,
it ends program execution of the current iteration
of the innermost enclosing loop statement in which it occurs.

In both cases, program control is then transferred to the condition
of the enclosing loop statement.

In a `for` statement,
the increment expression is still evaluated after the `continue` statement is executed,
because the increment expression is evaluated after the execution of the loop's body.

For examples of how to use a `continue` statement,
see ControlFlow\#Continue and ControlFlow\#Labeled-Statements
in ControlFlow.

#grammar-block(title: "Grammar of a continue statement")[
_continue-statement_ → *`continue`* _label-name_\_?\_
]

=== Fallthrough Statement

A `fallthrough` statement consists of the `fallthrough` keyword
and occurs only in a case block of a `switch` statement.
A `fallthrough` statement causes program execution to continue
from one case in a `switch` statement to the next case.
Program execution continues to the next case
even if the patterns of the case label don't match
the value of the `switch` statement's control expression.

A `fallthrough` statement can appear anywhere inside a `switch` statement,
not just as the last statement of a case block,
but it can't be used in the final case block.
It also can't transfer control into a case block
whose pattern contains value binding patterns.

For an example of how to use a `fallthrough` statement in a `switch` statement,
see ControlFlow\#Control-Transfer-Statements
in ControlFlow.

#grammar-block(title: "Grammar of a fallthrough statement")[
_fallthrough-statement_ → *`fallthrough`*
]

=== Return Statement

A `return` statement occurs in the body of a function or method definition
and causes program execution to return to the calling function or method.
Program execution continues at the point immediately following the function or method call.

A `return` statement can consist of only the `return` keyword,
or it can consist of the `return` keyword followed by an expression, as shown below.

```swift
return
return expression
```

When a `return` statement is followed by an expression,
the value of the expression is returned to the calling function or method.
If the value of the expression doesn't match the value of the return type
declared in the function or method declaration,
the expression's value is converted to the return type
before it's returned to the calling function or method.

#memo()[
As described in Declarations\#Failable-Initializers, a special form of the `return` statement (`return nil`)
can be used in a failable initializer to indicate initialization failure.
]



When a `return` statement isn't followed by an expression,
it can be used only to return from a function or method that doesn't return a value
(that is, when the return type of the function or method is `Void` or `()`).

#grammar-block(title: "Grammar of a return statement")[
_return-statement_ → *`return`* _expression_\_?\_
]

=== Throw Statement

A `throw` statement occurs in the body of a throwing function or method,
or in the body of a closure expression whose type is marked with the `throws` keyword.

A `throw` statement causes a program to end execution of the current scope
and begin error propagation to its enclosing scope.
The error that's thrown continues to propagate until it's handled by a `catch` clause
of a `do` statement.

A `throw` statement consists of the `throw` keyword
followed by an expression, as shown below.

```swift
throw expression
```

The value of the _expression_ must have a type that conforms to
the `Error` protocol.
If the `do` statement or function that contains the `throw` statement
declares the type of errors it throws,
the value of the _expression_ must be an instance of that type.

For an example of how to use a `throw` statement,
see ErrorHandling\#Propagating-Errors-Using-Throwing-Functions
in ErrorHandling.

#grammar-block(title: "Grammar of a throw statement")[
_throw-statement_ → *`throw`* _expression_
]

== Defer Statement

A `defer` statement is used for executing code
just before transferring program control outside of the scope
that the `defer` statement appears in.

A `defer` statement has the following form:

```swift
defer {
    statements
}
```

The statements within the `defer` statement are executed
no matter how program control is transferred.
This means that a `defer` statement can be used, for example,
to perform manual resource management such as closing file descriptors,
and to perform actions that need to happen even if an error is thrown.

The _statements_ in the `defer` statement
are executed at the end of the scope that encloses the `defer` statement.

```swift
func f(x: Int) {
  defer { print("First defer") }

  if x < 10 {
    defer { print("Second defer") }
    print("End of if")
  }

  print("End of function")
}
f(x: 5)
// Prints "End of if".
// Prints "Second defer".
// Prints "End of function".
// Prints "First defer".
```



In the code above,
the `defer` in the `if` statement
executes before the `defer` declared in the function `f`
because the scope of the `if` statement ends
before the scope of the function.

If multiple `defer` statements appear in the same scope,
the order they appear is the reverse of the order they're executed.
Executing the last `defer` statement in a given scope first
means that statements inside that last `defer` statement
can refer to resources that will be cleaned up by other `defer` statements.

```swift
func f() {
    defer { print("First defer") }
    defer { print("Second defer") }
    print("End of function")
}
f()
// Prints "End of function".
// Prints "Second defer".
// Prints "First defer".
```



The statements in the `defer` statement can't
transfer program control outside of the `defer` statement.

#grammar-block(title: "Grammar of a defer statement")[
_defer-statement_ → *`defer`* _code-block_
]

== Do Statement

The `do` statement is used to introduce a new scope
and can optionally contain one or more `catch` clauses,
which contain patterns that match against defined error conditions.
Variables and constants declared in the scope of a `do` statement
can be accessed only within that scope.

A `do` statement in Swift is similar to
curly braces (`{}`) in C used to delimit a code block,
and doesn't incur a performance cost at runtime.

A `do` statement has the following form:

```swift
do {
    try expression
    statements
} catch pattern 1 {
    statements
} catch pattern 2 where condition {
    statements
} catch pattern 3, pattern 4 where condition {
    statements
} catch {
    statements
}
```

A `do` statement can optionally specify the type of error it throws,
which has the following form:

```swift
do throws(type) {
    try expression
} catch <#pattern> {
    statements
} catch {
    statements
}
```

If the `do` statement includes a `throws` clause,
the `do` block can throw errors of only the specified _type_.
The _type_ must be
a concrete type that conforms to the `Error` protocol,
an opaque type that conforms to the `Error` protocol,
or the boxed protocol type `any Error`.
If the `do` statement doesn't specify the type of error it throws,
Swift infers the error type as follows:

- If every `throws` statement and `try` expression in the `do` code block
  is nested inside of an exhaustive error-handling mechanism,
  then Swift infers that the `do` statement is nonthrowing.

- If the `do` code block contains code that throws
  errors of only a single type
  outside of exhaustive error handling,
  other than throwing `Never`,
  then Swift infers that the `do` statement throws that concrete error type.

- If the `do` code block contains code that throws
  errors of more than a single type
  outside of exhaustive error handling,
  then Swift infers that the `do` statement throws `any Error`.

For more information about working with errors that have explicit types,
see ErrorHandling\#Specifying-the-Error-Type.

If any statement in the `do` code block throws an error,
program control is transferred
to the first `catch` clause whose pattern matches the error.
If none of the clauses match,
the error propagates to the surrounding scope.
If an error is unhandled at the top level,
program execution stops with a runtime error.

Like a `switch` statement,
the compiler attempts to infer whether `catch` clauses are exhaustive.
If such a determination can be made, the error is considered handled.
Otherwise, the error can propagate out of the containing scope,
which means
the error must be handled by an enclosing `catch` clause
or the containing function must be declared with `throws`.

A `catch` clause that has multiple patterns
matches the error if any of its patterns match the error.
If a `catch` clause contains multiple patterns,
all of the patterns must contain the same constant or variable bindings,
and each bound variable or constant must have the same type
in all of the `catch` clause's patterns.



To ensure that an error is handled,
use a `catch` clause with a pattern that matches all errors,
such as a wildcard pattern (`_`).
If a `catch` clause doesn't specify a pattern,
the `catch` clause matches and binds any error to a local constant named `error`.
For more information about the patterns you can use in a `catch` clause,
see Patterns.

To see an example of how to use a `do` statement with several `catch` clauses,
see ErrorHandling\#Handling-Errors.

#grammar-block(title: "Grammar of a do statement")[
_do-statement_ → *`do`* _throws-clause_\_?\_ _code-block_ _catch-clauses_\_?\_ \
_catch-clauses_ → _catch-clause_ _catch-clauses_\_?\_ \
_catch-clause_ → *`catch`* _catch-pattern-list_\_?\_ _code-block_ \
_catch-pattern-list_ → _catch-pattern_ | _catch-pattern_ *`,`* _catch-pattern-list_ \
_catch-pattern_ → _pattern_ _where-clause_\_?\_
]

== Compiler Control Statements

Compiler control statements allow the program to change aspects of the compiler's behavior.
Swift has three compiler control statements:
a conditional compilation block
a line control statement,
and a compile-time diagnostic statement.

#grammar-block(title: "Grammar of a compiler control statement")[
_compiler-control-statement_ → _conditional-compilation-block_ \
_compiler-control-statement_ → _line-control-statement_ \
_compiler-control-statement_ → _diagnostic-statement_
]

=== Conditional Compilation Block

A conditional compilation block allows code to be conditionally compiled
depending on the value of one or more compilation conditions.

Every conditional compilation block begins with the `#if` compilation directive
and ends with the `#endif` compilation directive.
A simple conditional compilation block has the following form:

```swift
#if compilation condition
    statements
#endif
```

Unlike the condition of an `if` statement,
the _compilation condition_ is evaluated at compile time.
As a result,
the _statements_ are compiled and executed only if the _compilation condition_
evaluates to `true` at compile time.

The _compilation condition_ can include the `true` and `false` Boolean literals,
an identifier used with the `-D` command line flag, or any of the platform
conditions listed in the table below.









#table(
  columns: 2,
  [* Platform condition *],
  [* Valid arguments *],
  [`os()`],
  [`macOS`, `iOS`, `watchOS`, `tvOS`, `visionOS`, `Linux`, `Windows`],
  [`arch()`],
  [`arm`, `arm64`, `i386`, `wasm32`, `x86_64`,],
  [`swift()`],
  [`>=` or `<` followed by a version number],
  [`compiler()`],
  [`>=` or `<` followed by a version number],
  [`canImport()`],
  [A module name],
  [`targetEnvironment()`],
  [`simulator`, `macCatalyst`],
)






The version number for the `swift()` and `compiler()` platform conditions
consists of a major number, optional minor number, optional patch number, and so on,
with a dot (`.`) separating each part of the version number.
There must not be whitespace between the comparison operator and the version number.
The version for `compiler()` is the compiler version,
regardless of the Swift version setting passed to the compiler.
The version for `swift()` is the language version currently being compiled.
For example, if you compile your code using the Swift 5 compiler in Swift 4.2 mode,
the compiler version is 5 and the language version is 4.2.
With those settings,
the following code prints all three messages:

```swift
#if compiler(>=5)
print("Compiled with the Swift 5 compiler or later")
#endif
#if swift(>=4.2)
print("Compiled in Swift 4.2 mode or later")
#endif
#if compiler(>=5) && swift(<5)
print("Compiled with the Swift 5 compiler or later in a Swift mode earlier than 5")
#endif
// Prints "Compiled with the Swift 5 compiler or later".
// Prints "Compiled in Swift 4.2 mode or later".
// Prints "Compiled with the Swift 5 compiler or later in a Swift mode earlier than 5".
```





The argument for the `canImport()` platform condition
is the name of a module that may not be present on all platforms.
The module can include periods (`.`) in its name.
This condition tests whether it's possible to import the module,
but doesn't actually import it.
If the module is present, the platform condition returns `true`;
otherwise, it returns `false`.







The `targetEnvironment()` platform condition
returns `true` when code is being compiled for the specified environment;
otherwise, it returns `false`.

#memo()[
The `arch(arm)` platform condition doesn't return `true` for ARM 64 devices.
The `arch(i386)` platform condition returns `true`
when code is compiled for the 32–bit iOS simulator.
]







You can combine and negate compilation conditions using the logical operators
`&&`, `||`, and `!`
and use parentheses for grouping.
These operators have the same associativity and precedence as the
logical operators that are used to combine ordinary Boolean expressions.

Similar to an `if` statement,
you can add multiple conditional branches to test for different compilation conditions.
You can add any number of additional branches using `#elseif` clauses.
You can also add a final additional branch using an `#else` clause.
Conditional compilation blocks that contain multiple branches
have the following form:

#memo()[
Each statement in the body of a conditional compilation block is parsed
even if it's not compiled.
However, there's an exception
if the compilation condition includes a `swift()` or `compiler()` platform condition:
The statements are parsed
only if the language or compiler version matches
what is specified in the platform condition.
This exception ensures that an older compiler doesn't attempt to parse
syntax introduced in a newer version of Swift.
]
```swift
#if compilation condition 1
    statements to compile if compilation condition 1 is true
#elseif compilation condition 2
    statements to compile if compilation condition 2 is true
#else
    statements to compile if both compilation conditions are false
#endif
```

For information about how you can wrap
explicit member expressions in conditional compilation blocks,
see Expressions\#Explicit-Member-Expression.

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
_architecture_ → *`arm`* | *`arm64`* | *`i386`* | *`wasm32`* | *`x86_64`* \
_swift-version_ → _decimal-digits_ _swift-version-continuation_\_?\_ \
_swift-version-continuation_ → *`.`* _decimal-digits_ _swift-version-continuation_\_?\_ \
_environment_ → *`simulator`* | *`macCatalyst`*
]



=== Line Control Statement

A line control statement is used to specify a line number and filename
that can be different from the line number and filename of the source code being compiled.
Use a line control statement to change the source code location
used by Swift for diagnostic and debugging purposes.

A line control statement has the following forms:

```swift
#sourceLocation(file: file path, line: line number)
#sourceLocation()
```

The first form of a line control statement changes the values
of the `#line`, `#file`, `#fileID`, and `#filePath`
literal expressions, beginning with the line of code following the line control statement.
The _line number_ changes the value of `#line`,
and is any integer literal greater than zero.
The _file path_ changes the value of `#file`, `#fileID`, and `#filePath`,
and is a string literal.
The specified string becomes the value of `#filePath`,
and the last path component of the string is used by the value of `#fileID`.
For information about `#file`, `#fileID`, and `#filePath`,
see Expressions\#Literal-Expression.

The second form of a line control statement, `#sourceLocation()`,
resets the source code location back to the default line numbering and file path.

#grammar-block(title: "Grammar of a line control statement")[
_line-control-statement_ → *`#sourceLocation`* *`(`* *`file:`* _file-path_ *`,`* *`line:`* _line-number_ *`)`* \
_line-control-statement_ → *`#sourceLocation`* *`(`* *`)`* \
_line-number_ → A decimal integer greater than zero \
_file-path_ → _static-string-literal_
]

=== Compile-Time Diagnostic Statement

Prior to Swift 5.9,
the `#warning` and `#error` statements emit a diagnostic during compilation.
This behavior is now provided by
the `warning(_:)` and `error(_:)` macros in the Swift standard library.




== Availability Condition

An _availability condition_ is used as a condition of an `if`, `while`,
and `guard` statement to query the availability of APIs at runtime,
based on specified platforms arguments.

An availability condition has the following form:

```swift
if #available(platform name version, ..., *) {
    statements to execute if the APIs are available
} else {
    fallback statements to execute if the APIs are unavailable
}
```

You use an availability condition to execute a block of code,
depending on whether the APIs you want to use are available at runtime.
The compiler uses the information from the availability condition
when it verifies that the APIs in that block of code are available.

The availability condition takes a comma-separated list of platform names and versions.
Use `iOS`, `macOS`, `watchOS`, `tvOS` and `visionOS` for the platform names,
and include the corresponding version numbers.
The `*` argument is required and specifies that, on any other platform,
the body of the code block guarded by the availability condition
executes on the minimum deployment target specified by your target.

Unlike Boolean conditions, you can't combine availability conditions using
logical operators like `&&` and `||`.
Instead of using `!` to negate an availability condition,
use an unavailability condition, which has the following form:

```swift
if #unavailable(platform name version, ...) {
    fallback statements to execute if the APIs are unavailable
} else {
    statements to execute if the APIs are available
}
```

The `#unavailable` form is syntactic sugar that negates the condition.
In an unavailability condition,
the `*` argument is implicit and must not be included.
It has the same meaning as the `*` argument in an availability condition.

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












