#import "@local/eightbyten:0.1.0": *
#import "../utils.typ": grammar-block, experiment, important, deprecated, memo


#chapter("Declarations", eyebrow: "Introducing new names")

A _declaration_ introduces a new name or construct into your program.
For example, you use declarations to introduce functions and methods,
to introduce variables and constants,
and to define enumeration, structure, class, and protocol types.
You can also use a declaration to extend the behavior
of an existing named type and to import symbols into your program that are declared elsewhere.

In Swift, most declarations are also definitions in the sense that they're implemented
or initialized at the same time they're declared. That said, because protocols don't
implement their members, most protocol members are declarations only. For convenience
and because the distinction isn't that important in Swift,
the term _declaration_ covers both declarations and definitions.

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
_declaration_ → _macro-declaration_ \
_declaration_ → _operator-declaration_ \
_declaration_ → _precedence-group-declaration_
]

== Top-Level Code

The top-level code in a Swift source file consists of zero or more statements,
declarations, and expressions.
By default, variables, constants, and other named declarations that are declared
at the top-level of a source file are accessible to code
in every source file that's part of the same module.
You can override this default behavior
by marking the declaration with an access-level modifier,
as described in Declarations\#Access-Control-Levels.

There are two kinds of top-level code:
top-level declarations and executable top-level code.
Top-level declarations consist of only declarations,
and are allowed in all Swift source files.
Executable top-level code contains statements and expressions,
not just declarations,
and is allowed only as the top-level entry point for the program.

The Swift code you compile to make an executable
can contain at most one of the following approaches
to mark the top-level entry point,
regardless of how the code is organized into files and modules:
a file that contains top-level executable code,
a `main.swift` file,
the `main` attribute,
the `NSApplicationMain` attribute,
or the `UIApplicationMain` attribute.

#grammar-block(title: "Grammar of a top-level declaration")[
_top-level-declaration_ → _statements_\_?\_
]

== Code Blocks

A _code block_ is used by a variety of declarations and control structures
to group statements together.
It has the following form:

```swift
{
   statements
}
```

The _statements_ inside a code block include declarations,
expressions, and other kinds of statements and are executed in order
of their appearance in source code.





#grammar-block(title: "Grammar of a code block")[
_code-block_ → *`{`* _statements_\_?\_ *`}`*
]

== Import Declaration

An _import declaration_ lets you access symbols
that are declared outside the current file.
The basic form imports the entire module;
it consists of the `import` keyword followed by a module name:

```swift
import module
```

Providing more detail limits which symbols are imported ---
you can specify a specific submodule
or a specific declaration within a module or submodule.
When this detailed form is used,
only the imported symbol
(and not the module that declares it)
is made available in the current scope.

#grammar-block(title: "Grammar of an import declaration")[
_import-declaration_ → _attributes_\_?\_ *`import`* _import-kind_\_?\_ _import-path_

_import-kind_ → *`typealias`* | *`struct`* | *`class`* | *`enum`* | *`protocol`* | *`let`* | *`var`* | *`func`* \
_import-path_ → _identifier_ | _identifier_ *`.`* _import-path_
]
```swift
import import kind module.symbol name
import module.submodule
```

== Constant Declaration

A _constant declaration_ introduces a constant named value into your program.
Constant declarations are declared using the `let` keyword and have the following form:

```swift
let constant name: type = expression
```

A constant declaration defines an immutable binding between the _constant name_
and the value of the initializer _expression_;
after the value of a constant is set, it can't be changed.
That said, if a constant is initialized with a class object,
the object itself can change,
but the binding between the constant name and the object it refers to can't.

When a constant is declared at global scope,
it must be initialized with a value.
When a constant declaration occurs in the context of a function or method,
it can be initialized later,
as long as it's guaranteed to have a value set
before the first time its value is read.
If the compiler can prove that the constant's value is never read,
the constant isn't required to have a value set at all.
This analysis is called _definite initialization_ ---
the compiler proves that a value is definitely set before being read.

#memo()[

Definite initialization
can't construct proofs that require domain knowledge,
and its ability to track state across conditionals has a limit.
If you can determine that constant always has a value set,
but the compiler can't prove this is the case,
try simplifying the code paths that set the value,
or use a variable declaration instead.
]



When a constant declaration occurs in the context of a class or structure
declaration, it's considered a _constant property_.
Constant declarations aren't computed properties and therefore don't have getters
or setters.

If the _constant name_ of a constant declaration is a tuple pattern,
the name of each item in the tuple is bound to the corresponding value
in the initializer _expression_.

```swift
let (firstNumber, secondNumber) = (10, 42)
```



In this example,
`firstNumber` is a named constant for the value `10`,
and `secondNumber` is a named constant for the value `42`.
Both constants can now be used independently:

```swift
print("The first number is \(firstNumber).")
// Prints "The first number is 10."
print("The second number is \(secondNumber).")
// Prints "The second number is 42."
```



The type annotation (`:` _type_) is optional in a constant declaration
when the type of the _constant name_ can be inferred,
as described in Types\#Type-Inference.

To declare a constant type property,
mark the declaration with the `static` declaration modifier.
A constant type property of a class is always implicitly final;
you can't mark it with the `class` or `final` declaration modifier
to allow or disallow overriding by subclasses.
Type properties are discussed in Properties\#Type-Properties.



For more information about constants and for guidance about when to use them,
see TheBasics\#Constants-and-Variables and Properties\#Stored-Properties.

#grammar-block(title: "Grammar of a constant declaration")[
_constant-declaration_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`let`* _pattern-initializer-list_

_pattern-initializer-list_ → _pattern-initializer_ | _pattern-initializer_ *`,`* _pattern-initializer-list_ \
_pattern-initializer_ → _pattern_ _initializer_\_?\_ \
_initializer_ → *`=`* _expression_
]

== Variable Declaration

A _variable declaration_ introduces a variable named value into your program
and is declared using the `var` keyword.

Variable declarations have several forms that declare different kinds
of named, mutable values,
including stored and computed variables and properties,
stored variable and property observers, and static variable properties.
The appropriate form to use depends on
the scope at which the variable is declared and the kind of variable you intend to declare.

#memo()[
You can also declare properties in the context of a protocol declaration,
as described in Declarations\#Protocol-Property-Declaration.
]

You can override a property in a subclass by marking the subclass's property declaration
with the `override` declaration modifier, as described in Inheritance\#Overriding.

=== Stored Variables and Stored Variable Properties

The following form declares a stored variable or stored variable property:

```swift
var variable name: type = expression
```

You define this form of a variable declaration at global scope, the local scope
of a function, or in the context of a class or structure declaration.
When a variable declaration of this form is declared at global scope or the local
scope of a function, it's referred to as a _stored variable_.
When it's declared in the context of a class or structure declaration,
it's referred to as a _stored variable property_.

The initializer _expression_ can't be present in a protocol declaration,
but in all other contexts, the initializer _expression_ is optional.
That said, if no initializer _expression_ is present,
the variable declaration must include an explicit type annotation (`:` _type_).

As with constant declarations,
if a variable declaration omits the initializer _expression_,
the variable must have a value set before the first time it is read.
Also like constant declarations,
if the _variable name_ is a tuple pattern,
the name of each item in the tuple is bound to the corresponding value
in the initializer _expression_.

As their names suggest, the value of a stored variable or a stored variable property
is stored in memory.

=== Computed Variables and Computed Properties

The following form declares a computed variable or computed property:

```swift
var variable name: type {
   get {
      statements
   }
   set(setter name) {
      statements
   }
}
```

You define this form of a variable declaration at global scope, the local scope
of a function, or in the context of a class, structure, enumeration, or extension declaration.
When a variable declaration of this form is declared at global scope or the local
scope of a function, it's referred to as a _computed variable_.
When it's declared in the context of a class,
structure, or extension declaration,
it's referred to as a _computed property_.

The getter is used to read the value,
and the setter is used to write the value.
The setter clause is optional,
and when only a getter is needed, you can omit both clauses and simply
return the requested value directly,
as described in Properties\#Read-Only-Computed-Properties.
But if you provide a setter clause, you must also provide a getter clause.

The _setter name_ and enclosing parentheses is optional.
If you provide a setter name, it's used as the name of the parameter to the setter.
If you don't provide a setter name, the default parameter name to the setter is `newValue`,
as described in Properties\#Shorthand-Setter-Declaration.

Unlike stored named values and stored variable properties,
the value of a computed named value or a computed property isn't stored in memory.

For more information and to see examples of computed properties,
see Properties\#Computed-Properties.

=== Stored Variable Observers and Property Observers

You can also declare a stored variable or property with `willSet` and `didSet` observers.
A stored variable or property declared with observers has the following form:

```swift
var variable name: type = expression {
   willSet(setter name) {
      statements
   }
   didSet(setter name) {
      statements
   }
}
```

You define this form of a variable declaration at global scope, the local scope
of a function, or in the context of a class or structure declaration.
When a variable declaration of this form is declared at global scope or the local
scope of a function, the observers are referred to as _stored variable observers_.
When it's declared in the context of a class or structure declaration,
the observers are referred to as _property observers_.

You can add property observers to any stored property. You can also add property
observers to any inherited property (whether stored or computed) by overriding
the property within a subclass, as described in Inheritance\#Overriding-Property-Observers.

The initializer _expression_ is optional in the context of a class or structure declaration,
but required elsewhere. The _type_ annotation is optional
when the type can be inferred from the initializer _expression_.
This expression is evaluated the first time you read the property's value.
If you overwrite the property's initial value without reading it,
this expression is evaluated before the first time you write to the property.



The `willSet` and `didSet` observers provide a way to observe (and to respond appropriately)
when the value of a variable or property is being set.
The observers aren't called when the variable or property
is first initialized.
Instead, they're called only when the value is set outside of an initialization context.

A `willSet` observer is called just before the value of the variable or property
is set. The new value is passed to the `willSet` observer as a constant,
and therefore it can't be changed in the implementation of the `willSet` clause.
The `didSet` observer is called immediately after the new value is set. In contrast
to the `willSet` observer, the old value of the variable or property
is passed to the `didSet` observer in case you still need access to it. That said,
if you assign a value to a variable or property within its own `didSet` observer clause,
that new value that you assign will replace the one that was just set and passed to
the `willSet` observer.

The _setter name_ and enclosing parentheses in the `willSet` and `didSet` clauses are optional.
If you provide setter names,
they're used as the parameter names to the `willSet` and `didSet` observers.
If you don't provide setter names,
the default parameter name to the `willSet` observer is `newValue`
and the default parameter name to the `didSet` observer is `oldValue`.

The `didSet` clause is optional when you provide a `willSet` clause.
Likewise, the `willSet` clause is optional when you provide a `didSet` clause.

If the body of the `didSet` observer refers to the old value,
the getter is called before the observer,
to make the old value available.
Otherwise, the new value is stored without calling the superclass's getter.
The example below shows a computed property that's defined by the superclass
and overridden by its subclasses to add an observer.

```swift
class Superclass {
    private var xValue = 12
    var x: Int {
        get { print("Getter was called"); return xValue }
        set { print("Setter was called"); xValue = newValue }
    }
}

// This subclass doesn't refer to oldValue in its observer, so the
// superclass's getter is called only once to print the value.
class New: Superclass {
    override var x: Int {
        didSet { print("New value \(x)") }
    }
}
let new = New()
new.x = 100
// Prints "Setter was called".
// Prints "Getter was called".
// Prints "New value 100".

// This subclass refers to oldValue in its observer, so the superclass's
// getter is called once before the setter, and again to print the value.
class NewAndOld: Superclass {
    override var x: Int {
        didSet { print("Old value \(oldValue) - new value \(x)") }
    }
}
let newAndOld = NewAndOld()
newAndOld.x = 200
// Prints "Getter was called".
// Prints "Setter was called".
// Prints "Getter was called".
// Prints "Old value 12 - new value 200".
```



For more information and to see an example of how to use property observers,
see Properties\#Property-Observers.



=== Type Variable Properties

To declare a type variable property,
mark the declaration with the `static` declaration modifier.
Classes can mark type computed properties with the `class` declaration modifier instead
to allow subclasses to override the superclass’s implementation.
Type properties are discussed in Properties\#Type-Properties.

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



== Type Alias Declaration

A _type alias declaration_ introduces a named alias of an existing type into your program.
Type alias declarations are declared using the `typealias` keyword and have the following form:

```swift
typealias name = existing type
```

After a type alias is declared, the aliased _name_ can be used
instead of the _existing type_ everywhere in your program.
The _existing type_ can be a named type or a compound type.
Type aliases don't create new types;
they simply allow a name to refer to an existing type.

A type alias declaration can use generic parameters
to give a name to an existing generic type. The type alias
can provide concrete types for some or all of the generic parameters
of the existing type.
For example:

```swift
typealias StringDictionary<Value> = Dictionary<String, Value>

// The following dictionaries have the same type.
var dictionary1: StringDictionary<Int> = [:]
var dictionary2: Dictionary<String, Int> = [:]
```



When a type alias is declared with generic parameters, the constraints on those
parameters must match exactly the constraints on the existing type's generic parameters.
For example:

```swift
typealias DictionaryOfInts<Key: Hashable> = Dictionary<Key, Int>
```



Because the type alias and the existing type can be used interchangeably,
the type alias can't introduce additional generic constraints.

A type alias can forward an existing type's generic parameters
by omitting all generic parameters from the declaration.
For example,
the `Diccionario` type alias declared here
has the same generic parameters and constraints as `Dictionary`.

```swift
typealias Diccionario = Dictionary
```







Inside a protocol declaration,
a type alias can give a shorter and more convenient name
to a type that's used frequently.
For example:

```swift
protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    typealias Element = Iterator.Element
}

func sum<T: Sequence>(_ sequence: T) -> Int where T.Element == Int {
    // ...
}
```



Without this type alias,
the `sum` function would have to refer to the associated type
as `T.Iterator.Element` instead of `T.Element`.

See also Declarations\#Protocol-Associated-Type-Declaration.

#grammar-block(title: "Grammar of a type alias declaration")[
_typealias-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`typealias`* _typealias-name_ _generic-parameter-clause_\_?\_ _typealias-assignment_ \
_typealias-name_ → _identifier_ \
_typealias-assignment_ → *`=`* _type_
]



== Function Declaration

A _function declaration_ introduces a function or method into your program.
A function declared in the context of class, structure, enumeration, or protocol
is referred to as a _method_.
Function declarations are declared using the `func` keyword and have the following form:

```swift
func function name(parameters) -> return type {
   statements
}
```

If the function has a return type of `Void`,
the return type can be omitted as follows:

```swift
func function name(parameters) {
   statements
}
```

The type of each parameter must be included ---
it can't be inferred.
If you write `inout` in front of a parameter's type,
the parameter can be modified inside the scope of the function.
In-out parameters are discussed in detail
in Declarations\#In-Out-Parameters, below.

A function declaration whose _statements_
include only a single expression
is understood to return the value of that expression.
This implicit return syntax is considered
only when the expression's type and the function's return type
aren't `Void`
and aren't an enumeration like `Never` that doesn't have any cases.



Functions can return multiple values using a tuple type
as the return type of the function.



A function definition can appear inside another function declaration.
This kind of function is known as a _nested function_.

A nested function is nonescaping if it captures
a value that's guaranteed to never escape ---
such as an in-out parameter ---
or passed as a nonescaping function argument.
Otherwise, the nested function is an escaping function.

For a discussion of nested functions,
see Functions\#Nested-Functions.

=== Parameter Names

Function parameters are a comma-separated list
where each parameter has one of several forms.
The order of arguments in a function call
must match the order of parameters in the function's declaration.
The simplest entry in a parameter list has the following form:

```swift
parameter name: parameter type
```

A parameter has a name,
which is used within the function body,
as well as an argument label,
which is used when calling the function or method.
By default,
parameter names are also used as argument labels.
For example:

```swift
func f(x: Int, y: Int) -> Int { return x + y }
f(x: 1, y: 2) // both x and y are labeled
```





You can override the default behavior for argument labels
with one of the following forms:

```swift
argument label parameter name: parameter type
_ parameter name: parameter type
```

A name before the parameter name
gives the parameter an explicit argument label,
which can be different from the parameter name.
The corresponding argument must use the given argument label
in function or method calls.

An underscore (`_`) before a parameter name
suppresses the argument label.
The corresponding argument must have no label in function or method calls.

```swift
func repeatGreeting(_ greeting: String, count n: Int) { /* Greet n times */ }
repeatGreeting("Hello, world!", count: 2) //  count is labeled, greeting is not
```



=== Parameter Modifiers

A _parameter modifier_ changes how an argument is passed to the function.

```swift
argument label parameter name: parameter modifier parameter type
```

To use a parameter modifier,
write `inout`, `borrowing`, or `consuming`
before the argument's type.

```swift
func someFunction(a: inout A, b: consuming B, c: C) { ... }
```

==== In-Out Parameters

By default, function arguments in Swift are passed by value:
Any changes made within the function are not visible in the caller.
To make an in-out parameter instead,
you apply the `inout` parameter modifier.

```swift
func someFunction(a: inout Int) {
    a += 1
}
```

When calling a function that includes in-out parameters,
the in-out argument must be prefixed with an ampersand (`&`)
to mark that the function call can change the argument's value.

```swift
var x = 7
someFunction(a: &x)
print(x)  // Prints "8"
```

In-out parameters are passed as follows:

+ When the function is called,
   the value of the argument is copied.
+ In the body of the function,
   the copy is modified.
+ When the function returns,
   the copy's value is assigned to the original argument.

This behavior is known as _copy-in copy-out_
or _call by value result_.
For example,
when a computed property or a property with observers
is passed as an in-out parameter,
its getter is called as part of the function call
and its setter is called as part of the function return.

As an optimization,
when the argument is a value stored at a physical address in memory,
the same memory location is used both inside and outside the function body.
The optimized behavior is known as _call by reference_;
it satisfies all of the requirements
of the copy-in copy-out model
while removing the overhead of copying.
Write your code using the model given by copy-in copy-out,
without depending on the call-by-reference optimization,
so that it behaves correctly with or without the optimization.

Within a function, don't access a value that was passed as an in-out argument,
even if the original value is available in the current scope.
Accessing the original is a simultaneous access of the value,
which violates memory exclusivity.

```swift
var someValue: Int
func someFunction(a: inout Int) {
    a += someValue
}

// Error: This causes a runtime exclusivity violation
someFunction(a: &someValue)
```

For the same reason,
you can't pass the same value to multiple in-out parameters.

```swift
var someValue: Int
func someFunction(a: inout Int, b: inout Int) {
    a += b
    b += 1
}

// Error: Cannot pass the same value to multiple in-out parameters
someFunction(a: &someValue, b: &someValue)
```

For more information about memory safety and memory exclusivity,
see MemorySafety.



A closure or nested function
that captures an in-out parameter must be nonescaping.
If you need to capture an in-out parameter
without mutating it,
use a capture list to explicitly capture the parameter immutably.

```swift
func someFunction(a: inout Int) -> () -> Int {
    return { [a] in return a + 1 }
}
```



If you need to capture and mutate an in-out parameter,
use an explicit local copy,
such as in multithreaded code that ensures
all mutation has finished before the function returns.

```swift
func multithreadedFunction(queue: DispatchQueue, x: inout Int) {
    // Make a local copy and manually copy it back.
    var localX = x
    defer { x = localX }

    // Operate on localX asynchronously, then wait before returning.
    queue.async { someMutatingOperation(&localX) }
    queue.sync {}
}
```



For more discussion and examples of in-out parameters,
see Functions\#In-Out-Parameters.



==== Borrowing and Consuming Parameters

By default, Swift uses a set of rules
to automatically manage object lifetime across function calls,
copying values when required.
The default rules are designed to minimize overhead in most cases ---
if you want more specific control,
you can apply the `borrowing` or `consuming` parameter modifier.
In this case,
use `copy` to explicitly mark copy operations.
In addition,
values of a noncopyable type must be passed as either borrowing or consuming.

Regardless of whether you use the default rules,
Swift guarantees that object lifetime and
ownership are correctly managed in all cases.
These parameter modifiers impact only the relative efficiency
of particular usage patterns, not correctness.



The `borrowing` modifier indicates that the function
does not keep the parameter's value.
In this case, the caller maintains ownership of the object
and the responsibility for the object's lifetime.
Using `borrowing` minimizes overhead when the function
uses the object only transiently.

```swift
// `isLessThan` does not keep either argument
func isLessThan(lhs: borrowing A, rhs: borrowing A) -> Bool {
    ...
}
```

If the function needs to keep the parameter's value
for example, by storing it in a global variable ---
you use `copy` to explicitly copy that value.

```swift
// As above, but this `isLessThan` also wants to record the smallest value
func isLessThan(lhs: borrowing A, rhs: borrowing A) -> Bool {
    if lhs < storedValue {
        storedValue = copy lhs
    } else if rhs < storedValue {
        storedValue = copy rhs
    }
    return lhs < rhs
}
```

Conversely,
the `consuming` parameter modifier indicates
that the function takes ownership of the value,
accepting responsibility for either storing or destroying it
before the function returns.

```swift
// `store` keeps its argument, so mark it `consuming`
func store(a: consuming A) {
    someGlobalVariable = a
}
```

Using `consuming` minimizes overhead when the caller no longer
needs to use the object after the function call.

```swift
// Usually, this is the last thing you do with a value
store(a: value)
```

If you keep using a copyable object after the function call,
the compiler automatically makes a copy of that object
before the function call.

```swift
// The compiler inserts an implicit copy here
store(a: someValue)  // This function consumes someValue
print(someValue)  // This uses the copy of someValue
```

Unlike `inout`, neither `borrowing` nor
`consuming` parameters require any special
notation when you call the function:

```swift
func someFunction(a: borrowing A, b: consuming B) { ... }

someFunction(a: someA, b: someB)
```

The explicit use of either `borrowing` or `consuming`
indicates your intention to more tightly control
the overhead of runtime ownership management.
Because copies can cause unexpected runtime ownership
operations,
parameters marked with either of these
modifiers cannot be copied unless you
use an explicit `copy` keyword:

```swift
func borrowingFunction1(a: borrowing A) {
    // Error: Cannot implicitly copy a
    // This assignment requires a copy because
    // `a` is only borrowed from the caller.
    someGlobalVariable = a
}

func borrowingFunction2(a: borrowing A) {
    // OK: Explicit copying works
    someGlobalVariable = copy a
}

func consumingFunction1(a: consuming A) {
    // Error: Cannot implicitly copy a
    // This assignment requires a copy because
    // of the following `print`
    someGlobalVariable = a
    print(a)
}

func consumingFunction2(a: consuming A) {
    // OK: Explicit copying works regardless
    someGlobalVariable = copy a
    print(a)
}

func consumingFunction3(a: consuming A) {
    // OK: No copy needed here because this is the last use
    someGlobalVariable = a
}
```




=== Special Kinds of Parameters

Parameters can be ignored,
take a variable number of values,
and provide default values
using the following forms:

```swift
_ : parameter type
parameter name: parameter type...
parameter name: parameter type = default argument value
```

An underscore (`_`) parameter
is explicitly ignored and can't be accessed within the body of the function.

A parameter with a base type name followed immediately by three dots (`...`)
is understood as a variadic parameter.
A parameter that immediately follows a variadic parameter
must have an argument label.
A function can have multiple variadic parameters.
A variadic parameter is treated as an array that contains elements of the base type name.
For example, the variadic parameter `Int...` is treated as `[Int]`.
For an example that uses a variadic parameter,
see Functions\#Variadic-Parameters.

A parameter with an equal sign (`=`) and an expression after its type
is understood to have a default value of the given expression.
The given expression is evaluated when the function is called.
If the parameter is omitted when calling the function,
the default value is used instead.

```swift
func f(x: Int = 42) -> Int { return x }
f()       // Valid, uses default value
f(x: 7)   // Valid, uses the value provided
f(7)      // Invalid, missing argument label
```







=== Special Kinds of Methods

Methods on an enumeration or a structure
that modify `self` must be marked with the `mutating` declaration modifier.

Methods that override a superclass method
must be marked with the `override` declaration modifier.
It's a compile-time error to override a method without the `override` modifier
or to use the `override` modifier on a method
that doesn't override a superclass method.

Methods associated with a type
rather than an instance of a type
must be marked with the `static` declaration modifier for enumerations and structures,
or with either the `static` or `class` declaration modifier for classes.
A class type method marked with the `class` declaration modifier
can be overridden by a subclass implementation;
a class type method marked with `class final` or `static` can't be overridden.





=== Methods with Special Names

Several methods that have special names
enable syntactic sugar for function call syntax.
If a type defines one of these methods,
instances of the type can be used in function call syntax.
The function call is understood to be a call to
one of the specially named methods on that instance.

A class, structure, or enumeration type
can support function call syntax
by defining a `dynamicallyCall(withArguments:)` method
or a `dynamicallyCall(withKeywordArguments:)` method,
as described in Attributes\#dynamicCallable,
or by defining a call-as-function method, as described below.
If the type defines
both a call-as-function method
and one of the methods used by the `dynamicCallable` attribute,
the compiler gives preference to the call-as-function method
in circumstances where either method could be used.

The name of a call-as-function method is `callAsFunction()`,
or another name that begins with `callAsFunction(`
and adds labeled or unlabeled arguments ---
for example, `callAsFunction(_:_:)` and `callAsFunction(something:)`
are also valid call-as-function method names.



The following function calls are equivalent:

```swift
struct CallableStruct {
    var value: Int
    func callAsFunction(_ number: Int, scale: Int) {
        print(scale * (number + value))
    }
}
let callable = CallableStruct(value: 100)
callable(4, scale: 2)
callable.callAsFunction(4, scale: 2)
// Both function calls print 208.
```



The call-as-function methods
and the methods from the `dynamicCallable` attribute
make different trade-offs between
how much information you encode into the type system
and how much dynamic behavior is possible at runtime.
When you declare a call-as-function method,
you specify the number of arguments,
and each argument's type and label.
The `dynamicCallable` attribute's methods specify only the type
used to hold the array of arguments.

Defining a call-as-function method,
or a method from the `dynamicCallable` attribute,
doesn't let you use an instance of that type
as if it were a function in any context other than a function call expression.
For example:

```swift
let someFunction1: (Int, Int) -> Void = callable(_:scale:)  // Error
let someFunction2: (Int, Int) -> Void = callable.callAsFunction(_:scale:)
```



The `subscript(dynamicMember:)` subscript
enables syntactic sugar for member lookup,
as described in Attributes\#dynamicMemberLookup.

=== Throwing Functions and Methods

Functions and methods that can throw an error must be marked with the `throws` keyword.
These functions and methods are known as _throwing functions_
and _throwing methods_.
They have the following form:

```swift
func function name(parameters) throws -> return type {
   statements
}
```

A function that throws a specific error type has the following form:

```swift
func function name(parameters) throws(error type) -> return type {
   statements
}
```

Calls to a throwing function or method must be wrapped in a `try` or `try!` expression
(that is, in the scope of a `try` or `try!` operator).

A function's type includes whether it can throw an error
and what type of error it throws.
This subtype relationship means, for example, you can use a nonthrowing function
in a context where a throwing one is expected.
For more information about the type of a throwing function,
see Types\#Function-Type.
For examples of working with errors that have explicit types,
see ErrorHandling\#Specifying-the-Error-Type.

You can't overload a function based only on whether the function can throw an error.
That said,
you can overload a function based on whether a function _parameter_ can throw an error.

A throwing method can't override a nonthrowing method,
and a throwing method can't satisfy a protocol requirement for a nonthrowing method.
That said, a nonthrowing method can override a throwing method,
and a nonthrowing method can satisfy a protocol requirement for a throwing method.

=== Rethrowing Functions and Methods

A function or method can be declared with the `rethrows` keyword
to indicate that it throws an error only if one of its function parameters throws an error.
These functions and methods are known as _rethrowing functions_
and _rethrowing methods_.
Rethrowing functions and methods
must have at least one throwing function parameter.

```swift
func someFunction(callback: () throws -> Void) rethrows {
    try callback()
}
```



A rethrowing function or method can contain a `throw` statement
only inside a `catch` clause.
This lets you call the throwing function inside a `do`-`catch` statement
and handle errors in the `catch` clause by throwing a different error.
In addition,
the `catch` clause must handle
only errors thrown by one of the rethrowing function's
throwing parameters.
For example, the following is invalid
because the `catch` clause would handle
the error thrown by `alwaysThrows()`.

```swift
func alwaysThrows() throws {
    throw SomeError.error
}
func someFunction(callback: () throws -> Void) rethrows {
    do {
        try callback()
        try alwaysThrows()  // Invalid, alwaysThrows() isn't a throwing parameter
    } catch {
        throw AnotherError.error
    }
}
```





A throwing method can't override a rethrowing method,
and a throwing method can't satisfy a protocol requirement for a rethrowing method.
That said, a rethrowing method can override a throwing method,
and a rethrowing method can satisfy a protocol requirement for a throwing method.

An alternative to rethrowing is throwing a specific error type in generic code.
For example:

```swift
func someFunction<E: Error>(callback: () throws(E) -> Void) throws(E) {
    try callback()
}
```

This approach to propagating an error
preserves type information about the error.
However, unlike marking a function `rethrows`,
this approach doesn't prevent the function
from throwing an error of the same type.



=== Asynchronous Functions and Methods

Functions and methods that run asynchronously must be marked with the `async` keyword.
These functions and methods are known as _asynchronous functions_
and _asynchronous methods_.
They have the following form:

```swift
func function name(parameters) async -> return type {
   statements
}
```

Calls to an asynchronous function or method
must be wrapped in an `await` expression ---
that is, they must be in the scope of an `await` operator.

The `async` keyword is part of the function's type,
and synchronous functions are subtypes of asynchronous functions.
As a result, you can use a synchronous function
in a context where an asynchronous function is expected.
For example,
you can override an asynchronous method with a synchronous method,
and a synchronous method can satisfy a protocol requirement
that requires an asynchronous method.

You can overload a function based on whether or not the function is asynchronous.
At the call site, context determines which overload is used:
In an asynchronous context, the asynchronous function is used,
and in a synchronous context, the synchronous function is used.

An asynchronous method can't override a synchronous method,
and an asynchronous method can't satisfy a protocol requirement for a synchronous method.
That said, a synchronous method can override an asynchronous method,
and a synchronous method can satisfy a protocol requirement for an asynchronous method.



=== Functions that Never Return

Swift defines a `Never` type,
which indicates that a function or method doesn't return to its caller.
Functions and methods with the `Never` return type are called _nonreturning_.
Nonreturning functions and methods either cause an irrecoverable error
or begin a sequence of work that continues indefinitely.
This means that
code that would otherwise run immediately after the call is never executed.
Throwing and rethrowing functions can transfer program control
to an appropriate `catch` block, even when they're nonreturning.



A nonreturning function or method can be called to conclude the `else` clause
of a guard statement,
as discussed in Statements\#Guard-Statement.

You can override a nonreturning method,
but the new method must preserve its return type and nonreturning behavior.

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



== Enumeration Declaration

An _enumeration declaration_ introduces a named enumeration type into your program.

Enumeration declarations have two basic forms and are declared using the `enum` keyword.
The body of an enumeration declared using either form contains
zero or more values --- called _enumeration cases_ ---
and any number of declarations,
including computed properties,
instance methods, type methods, initializers, type aliases,
and even other enumeration, structure, class, and actor declarations.
Enumeration declarations can't contain deinitializer or protocol declarations.

Enumeration types can adopt any number of protocols, but can’t inherit from classes,
structures, or other enumerations.

Unlike classes and structures,
enumeration types don't have an implicitly provided default initializer;
all initializers must be declared explicitly. Initializers can delegate
to other initializers in the enumeration, but the initialization process is complete
only after an initializer assigns one of the enumeration cases to `self`.

Like structures but unlike classes, enumerations are value types;
instances of an enumeration are copied when assigned to
variables or constants, or when passed as arguments to a function call.
For information about value types,
see ClassesAndStructures\#Structures-and-Enumerations-Are-Value-Types.

You can extend the behavior of an enumeration type with an extension declaration,
as discussed in Declarations\#Extension-Declaration.

=== Enumerations with Cases of Any Type

The following form declares an enumeration type that contains
enumeration cases of any type:

```swift
enum enumeration name: adopted protocols {
    case enumeration case 1
    case enumeration case 2(associated value types)
}
```

Enumerations declared in this form are sometimes called _discriminated unions_
in other programming languages.

In this form, each case block consists of the `case` keyword
followed by one or more enumeration cases, separated by commas.
The name of each case must be unique.
Each case can also specify that it stores values of a given type.
These types are specified in the _associated value types_ tuple,
immediately following the name of the case.

Enumeration cases that store associated values can be used as functions
that create instances of the enumeration with the specified associated values.
And just like functions,
you can get a reference to an enumeration case and apply it later in your code.

```swift
enum Number {
    case integer(Int)
    case real(Double)
}
let f = Number.integer
// f is a function of type (Int) -> Number

// Apply f to create an array of Number instances with integer values
let evenInts: [Number] = [0, 2, 4, 6].map(f)
```





For more information and to see examples of cases with associated value types,
see Enumerations\#Associated-Values.

==== Enumerations with Indirection

Enumerations can have a recursive structure,
that is, they can have cases with associated values
that are instances of the enumeration type itself.
However, instances of enumeration types have value semantics,
which means they have a fixed layout in memory.
To support recursion,
the compiler must insert a layer of indirection.

To enable indirection for a particular enumeration case,
mark it with the `indirect` declaration modifier.
An indirect case must have an associated value.



```swift
enum Tree<T> {
    case empty
    indirect case node(value: T, left: Tree, right: Tree)
}
```



To enable indirection for all the cases of an enumeration
that have an associated value,
mark the entire enumeration with the `indirect` modifier ---
this is convenient when the enumeration contains many cases
that would each need to be marked with the `indirect` modifier.

An enumeration that's marked with the `indirect` modifier
can contain a mixture of cases that have associated values and cases those that don't.
That said,
it can't contain any cases that are also marked with the `indirect` modifier.







=== Enumerations with Cases of a Raw-Value Type

The following form declares an enumeration type that contains
enumeration cases of the same basic type:

```swift
enum enumeration name: raw-value type, adopted protocols {
    case enumeration case 1 = raw value 1
    case enumeration case 2 = raw value 2
}
```

In this form, each case block consists of the `case` keyword,
followed by one or more enumeration cases, separated by commas.
Unlike the cases in the first form, each case has an underlying
value, called a _raw value_, of the same basic type.
The type of these values is specified in the _raw-value type_ and must represent an
integer, floating-point number, string, or single character.
In particular, the _raw-value type_ must conform to the `Equatable` protocol
and one of the following protocols:
`ExpressibleByIntegerLiteral` for integer literals,
`ExpressibleByFloatLiteral` for floating-point literals,
`ExpressibleByStringLiteral` for string literals that contain any number of characters,
and `ExpressibleByUnicodeScalarLiteral`
or `ExpressibleByExtendedGraphemeClusterLiteral` for string literals
that contain only a single character.
Each case must have a unique name and be assigned a unique raw value.



If the raw-value type is specified as `Int`
and you don't assign a value to the cases explicitly,
they're implicitly assigned the values `0`, `1`, `2`, and so on.
Each unassigned case of type `Int` is implicitly assigned a raw value
that's automatically incremented from the raw value of the previous case.

```swift
enum ExampleEnum: Int {
    case a, b, c = 5, d
}
```



In the above example, the raw value of `ExampleEnum.a` is `0` and the value of
`ExampleEnum.b` is `1`. And because the value of `ExampleEnum.c` is
explicitly set to `5`, the value of `ExampleEnum.d` is automatically incremented
from `5` and is therefore `6`.

If the raw-value type is specified as `String`
and you don't assign values to the cases explicitly,
each unassigned case is implicitly assigned a string with the same text as the name of that case.

```swift
enum GamePlayMode: String {
    case cooperative, individual, competitive
}
```



In the above example, the raw value of `GamePlayMode.cooperative` is `"cooperative"`,
the raw value of `GamePlayMode.individual` is `"individual"`,
and the raw value of `GamePlayMode.competitive` is `"competitive"`.

Enumerations that have cases of a raw-value type implicitly conform to the
`RawRepresentable` protocol, defined in the Swift standard library.
As a result, they have a `rawValue` property
and a failable initializer with the signature `init?(rawValue: RawValue)`.
You can use the `rawValue` property to access the raw value of an enumeration case,
as in `ExampleEnum.b.rawValue`.
You can also use a raw value to find a corresponding case, if there is one,
by calling the enumeration's failable initializer,
as in `ExampleEnum(rawValue: 5)`, which returns an optional case.
For more information and to see examples of cases with raw-value types,
see Enumerations\#Raw-Values.

=== Accessing Enumeration Cases

To reference the case of an enumeration type, use dot (`.`) syntax,
as in `EnumerationType.enumerationCase`. When the enumeration type can be inferred
from context, you can omit it (the dot is still required),
as described in Enumerations\#Enumeration-Syntax
and Expressions\#Implicit-Member-Expression.

To check the values of enumeration cases, use a `switch` statement,
as shown in Enumerations\#Matching-Enumeration-Values-with-a-Switch-Statement.
The enumeration type is pattern-matched against the enumeration case patterns
in the case blocks of the `switch` statement,
as described in Patterns\#Enumeration-Case-Pattern.







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



== Structure Declaration

A _structure declaration_ introduces a named structure type into your program.
Structure declarations are declared using the `struct` keyword and have the following form:

```swift
struct structure name: adopted protocols {
   declarations
}
```

The body of a structure contains zero or more _declarations_.
These _declarations_ can include both stored and computed properties,
type properties, instance methods, type methods, initializers, subscripts,
type aliases, and even other structure, class, actor, and enumeration declarations.
Structure declarations can't contain deinitializer or protocol declarations.
For a discussion and several examples of structures
that include various kinds of declarations,
see ClassesAndStructures.

Structure types can adopt any number of protocols,
but can't inherit from classes, enumerations, or other structures.

There are three ways to create an instance of a previously declared structure:

- Call one of the initializers declared within the structure,
  as described in Initialization\#Initializers.
- If no initializers are declared,
  call the structure's memberwise initializer,
  as described in Initialization\#Memberwise-Initializers-for-Structure-Types.
- If no initializers are declared,
  and all properties of the structure declaration were given initial values,
  call the structure's default initializer,
  as described in Initialization\#Default-Initializers.

The process of initializing a structure's declared properties
is described in Initialization.

Properties of a structure instance can be accessed using dot (`.`) syntax,
as described in ClassesAndStructures\#Accessing-Properties.

Structures are value types; instances of a structure are copied when assigned to
variables or constants, or when passed as arguments to a function call.
For information about value types,
see ClassesAndStructures\#Structures-and-Enumerations-Are-Value-Types.

You can extend the behavior of a structure type with an extension declaration,
as discussed in Declarations\#Extension-Declaration.

#grammar-block(title: "Grammar of a structure declaration")[
_struct-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`struct`* _struct-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _struct-body_ \
_struct-name_ → _identifier_ \
_struct-body_ → *`{`* _struct-members_\_?\_ *`}`*

_struct-members_ → _struct-member_ _struct-members_\_?\_ \
_struct-member_ → _declaration_ | _compiler-control-statement_
]

== Class Declaration

A _class declaration_ introduces a named class type into your program.
Class declarations are declared using the `class` keyword and have the following form:

```swift
class class name: superclass, adopted protocols {
   declarations
}
```

The body of a class contains zero or more _declarations_.
These _declarations_ can include both stored and computed properties,
instance methods, type methods, initializers,
a single deinitializer, subscripts, type aliases,
and even other class, structure, actor, and enumeration declarations.
Class declarations can't contain protocol declarations.
For a discussion and several examples of classes
that include various kinds of declarations,
see ClassesAndStructures.

A class type can inherit from only one parent class, its _superclass_,
but can adopt any number of protocols.
The _superclass_ appears first after the _class name_ and colon,
followed by any _adopted protocols_.
Generic classes can inherit from other generic and nongeneric classes,
but a nongeneric class can inherit only from other nongeneric classes.
When you write the name of a generic superclass class after the colon,
you must include the full name of that generic class,
including its generic parameter clause.

As discussed in Declarations\#Initializer-Declaration,
classes can have designated and convenience initializers.
The designated initializer of a class must initialize all of the class's
declared properties and it must do so before calling any of its superclass's
designated initializers.

A class can override properties, methods, subscripts, and initializers of its superclass.
Overridden properties, methods, subscripts,
and designated initializers must be marked with the `override` declaration modifier.



To require that subclasses implement a superclass's initializer,
mark the superclass's initializer with the `required` declaration modifier.
The subclass's implementation of that initializer
must also be marked with the `required` declaration modifier.

Although properties and methods declared in the _superclass_ are inherited by
the current class, designated initializers declared in the _superclass_ are only
inherited when the subclass meets the conditions described in
Initialization\#Automatic-Initializer-Inheritance.
Swift classes don't inherit from a universal base class.

There are two ways to create an instance of a previously declared class:

- Call one of the initializers declared within the class,
  as described in Initialization\#Initializers.
- If no initializers are declared,
  and all properties of the class declaration were given initial values,
  call the class's default initializer,
  as described in Initialization\#Default-Initializers.

Access properties of a class instance with dot (`.`) syntax,
as described in ClassesAndStructures\#Accessing-Properties.

Classes are reference types; instances of a class are referred to, rather than copied,
when assigned to variables or constants, or when passed as arguments to a function call.
For information about reference types,
see ClassesAndStructures\#Classes-Are-Reference-Types.

You can extend the behavior of a class type with an extension declaration,
as discussed in Declarations\#Extension-Declaration.

#grammar-block(title: "Grammar of a class declaration")[
_class-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`final`*\_?\_ *`class`* _class-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _class-body_ \
_class-declaration_ → _attributes_\_?\_ *`final`* _access-level-modifier_\_?\_ *`class`* _class-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _class-body_ \
_class-name_ → _identifier_ \
_class-body_ → *`{`* _class-members_\_?\_ *`}`*

_class-members_ → _class-member_ _class-members_\_?\_ \
_class-member_ → _declaration_ | _compiler-control-statement_
]

== Actor Declaration

An _actor declaration_ introduces a named actor type into your program.
Actor declarations are declared using the `actor` keyword and have the following form:

```swift
actor actor name: adopted protocols {
    declarations
}
```

The body of an actor contains zero or more _declarations_.
These _declarations_ can include both stored and computed properties,
instance methods, type methods, initializers,
a single deinitializer, subscripts, type aliases,
and even other class, structure, and enumeration declarations.
For a discussion and several examples of actors
that include various kinds of declarations,
see Concurrency\#Actors.

Actor types can adopt any number of protocols,
but can't inherit from classes, enumerations, structures, or other actors.
However, an actor that is marked with the `@objc` attribute
implicitly conforms to the `NSObjectProtocol` protocol
and is exposed to the Objective-C runtime as a subtype of `NSObject`.

There are two ways to create an instance of a previously declared actor:

- Call one of the initializers declared within the actor,
  as described in Initialization\#Initializers.
- If no initializers are declared,
  and all properties of the actor declaration were given initial values,
  call the actor's default initializer,
  as described in Initialization\#Default-Initializers.

By default, members of an actor are isolated to that actor.
Code, such as the body of a method or the getter for a property,
is executed on that actor.
Code within the actor can interact with them synchronously
because that code is already running on the same actor,
but code outside the actor must mark them with `await`
to indicate that this code is asynchronously running code on another actor.
Key paths can't refer to isolated members of an actor.
Actor-isolated stored properties can be passed as in-out parameters
to synchronous functions,
but not to asynchronous functions.

Actors can also have nonisolated members,
whose declarations are marked with the `nonisolated` keyword.
A nonisolated member executes like code outside of the actor:
It can't interact with any of the actor's isolated state,
and callers don't mark it with `await` when using it.

Members of an actor can be marked with the `@objc` attribute
only if they are nonisolated or asynchronous.

The process of initializing an actor's declared properties
is described in Initialization.

Properties of an actor instance can be accessed using dot (`.`) syntax,
as described in ClassesAndStructures\#Accessing-Properties.

Actors are reference types; instances of an actor are referred to, rather than copied,
when assigned to variables or constants, or when passed as arguments to a function call.
For information about reference types,
see ClassesAndStructures\#Classes-Are-Reference-Types.

You can extend the behavior of an actor type with an extension declaration,
as discussed in Declarations\#Extension-Declaration.



#grammar-block(title: "Grammar of an actor declaration")[
_actor-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`actor`* _actor-name_ _generic-parameter-clause_\_?\_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _actor-body_ \
_actor-name_ → _identifier_ \
_actor-body_ → *`{`* _actor-members_\_?\_ *`}`*

_actor-members_ → _actor-member_ _actor-members_\_?\_ \
_actor-member_ → _declaration_ | _compiler-control-statement_
]

== Protocol Declaration

A _protocol declaration_ introduces a named protocol type into your program.
Protocol declarations are declared
using the `protocol` keyword and have the following form:

```swift
protocol protocol name: inherited protocols {
   protocol member declarations
}
```

Protocol declarations can appear at global scope,
or nested inside a nongeneric type or nongeneric function.

The body of a protocol contains zero or more _protocol member declarations_,
which describe the conformance requirements that any type adopting the protocol must fulfill.
In particular, a protocol can declare that conforming types must
implement certain properties, methods, initializers, and subscripts.
Protocols can also declare special kinds of type aliases,
called _associated types_, that can specify relationships
among the various declarations of the protocol.
Protocol declarations can't contain
class, structure, enumeration, or other protocol declarations.
The _protocol member declarations_ are discussed in detail below.

Protocol types can inherit from any number of other protocols.
When a protocol type inherits from other protocols,
the set of requirements from those other protocols are aggregated,
and any type that inherits from the current protocol must conform to all those requirements.
For an example of how to use protocol inheritance,
see Protocols\#Protocol-Inheritance.

#memo()[
You can also aggregate the conformance requirements of multiple
protocols using protocol composition types,
as described in Types\#Protocol-Composition-Type
and Protocols\#Protocol-Composition.
]

You can add protocol conformance to a previously declared type
by adopting the protocol in an extension declaration of that type.
In the extension, you must implement all of the adopted protocol's
requirements. If the type already implements all of the requirements,
you can leave the body of the extension declaration empty.

By default, types that conform to a protocol must implement all
properties, methods, and subscripts declared in the protocol.
That said, you can mark these protocol member declarations with the `optional` declaration modifier
to specify that their implementation by a conforming type is optional.
The `optional` modifier can be applied
only to members that are marked with the `objc` attribute,
and only to members of protocols that are marked
with the `objc` attribute. As a result, only class types can adopt and conform
to a protocol that contains optional member requirements.
For more information about how to use the `optional` declaration modifier
and for guidance about how to access optional protocol members ---
for example, when you're not sure whether a conforming type implements them ---
see Protocols\#Optional-Protocol-Requirements.



The cases of an enumeration can satisfy
protocol requirements for type members.
Specifically,
an enumeration case without any associated values
satisfies a protocol requirement for
a get-only type variable of type `Self`,
and an enumeration case with associated values
satisfies a protocol requirement for a function that returns `Self`
whose parameters and their argument labels
match the case's associated values.
For example:

```swift
protocol SomeProtocol {
    static var someValue: Self { get }
    static func someFunction(x: Int) -> Self
}
enum MyEnum: SomeProtocol {
    case someValue
    case someFunction(x: Int)
}
```



To restrict the adoption of a protocol to class types only,
include the `AnyObject` protocol in the _inherited protocols_
list after the colon.
For example, the following protocol can be adopted only by class types:

```swift
protocol SomeProtocol: AnyObject {
    /* Protocol members go here */
}
```



Any protocol that inherits from a protocol that's marked with the `AnyObject` requirement
can likewise be adopted only by class types.

#memo()[
If a protocol is marked with the `objc` attribute,
the `AnyObject` requirement is implicitly applied to that protocol;
there’s no need to mark the protocol with the `AnyObject` requirement explicitly.
]

Protocols are named types, and thus they can appear in all the same places
in your code as other named types, as discussed in Protocols\#Protocols-as-Types.
However,
you can't construct an instance of a protocol,
because protocols don't actually provide the implementations for the requirements
they specify.

You can use protocols to declare which methods a delegate of a class or structure
should implement, as described in Protocols\#Delegation.

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

=== Protocol Property Declaration

Protocols declare that conforming types must implement a property
by including a _protocol property declaration_
in the body of the protocol declaration.
Protocol property declarations have a special form of a variable
declaration:

```swift
var property name: type { get set }
```

As with other protocol member declarations, these property declarations
declare only the getter and setter requirements for types
that conform to the protocol. As a result, you don't implement the getter or setter
directly in the protocol in which it's declared.

The getter and setter requirements can be satisfied by a conforming type in a variety of ways.
If a property declaration includes both the `get` and `set` keywords,
a conforming type can implement it with a stored variable property
or a computed property that's both readable and writeable
(that is, one that implements both a getter and a setter). However,
that property declaration can't be implemented as a constant property
or a read-only computed property. If a property declaration includes
only the `get` keyword, it can be implemented as any kind of property.
For examples of conforming types that implement the property requirements of a protocol,
see Protocols\#Property-Requirements.

To declare a type property requirement in a protocol declaration,
mark the property declaration with the `static` keyword.
Structures and enumerations that conform to the protocol
declare the property with the `static` keyword,
and classes that conform to the protocol
declare the property with either the `static` or `class` keyword.
Extensions that add protocol conformance to a structure, enumeration, or class
use the same keyword as the type they extend uses.
Extensions that provide a default implementation for a type property requirement
use the `static` keyword.





See also Declarations\#Variable-Declaration.

#grammar-block(title: "Grammar of a protocol property declaration")[
_protocol-property-declaration_ → _variable-declaration-head_ _variable-name_ _type-annotation_ _getter-setter-keyword-block_
]

=== Protocol Method Declaration

Protocols declare that conforming types must implement a method
by including a protocol method declaration in the body of the protocol declaration.
Protocol method declarations have the same form as
function declarations, with two exceptions: They don't include a function body,
and you can't provide any default parameter values as part of the function declaration.
For examples of conforming types that implement the method requirements of a protocol,
see Protocols\#Method-Requirements.

To declare a class or static method requirement in a protocol declaration,
mark the method declaration with the `static` declaration modifier.
Structures and enumerations that conform to the protocol
declare the method with the `static` keyword,
and classes that conform to the protocol
declare the method with either the `static` or `class` keyword.
Extensions that add protocol conformance to a structure, enumeration, or class
use the same keyword as the type they extend uses.
Extensions that provide a default implementation for a type method requirement
use the `static` keyword.

See also Declarations\#Function-Declaration.



#grammar-block(title: "Grammar of a protocol method declaration")[
_protocol-method-declaration_ → _function-head_ _function-name_ _generic-parameter-clause_\_?\_ _function-signature_ _generic-where-clause_\_?\_
]

=== Protocol Initializer Declaration

Protocols declare that conforming types must implement an initializer
by including a protocol initializer declaration in the body of the protocol declaration.
Protocol initializer declarations have the same form as
initializer declarations, except they don't include the initializer's body.

A conforming type can satisfy a nonfailable protocol initializer requirement
by implementing a nonfailable initializer or an `init!` failable initializer.
A conforming type can satisfy a failable protocol initializer requirement
by implementing any kind of initializer.

When a class implements an initializer to satisfy a protocol's initializer requirement,
the initializer must be marked with the `required` declaration modifier
if the class isn't already marked with the `final` declaration modifier.

See also Declarations\#Initializer-Declaration.

#grammar-block(title: "Grammar of a protocol initializer declaration")[
_protocol-initializer-declaration_ → _initializer-head_ _generic-parameter-clause_\_?\_ _parameter-clause_ _throws-clause_\_?\_ _generic-where-clause_\_?\_ \
_protocol-initializer-declaration_ → _initializer-head_ _generic-parameter-clause_\_?\_ _parameter-clause_ *`rethrows`* _generic-where-clause_\_?\_
]

=== Protocol Subscript Declaration

Protocols declare that conforming types must implement a subscript
by including a protocol subscript declaration in the body of the protocol declaration.
Protocol subscript declarations have a special form of a subscript declaration:

```swift
subscript (parameters) -> return type { get set }
```

Subscript declarations only declare the minimum getter and setter implementation
requirements for types that conform to the protocol.
If the subscript declaration includes both the `get` and `set` keywords,
a conforming type must implement both a getter and a setter clause.
If the subscript declaration includes only the `get` keyword,
a conforming type must implement _at least_ a getter clause
and optionally can implement a setter clause.

To declare a static subscript requirement in a protocol declaration,
mark the subscript declaration with the `static` declaration modifier.
Structures and enumerations that conform to the protocol
declare the subscript with the `static` keyword,
and classes that conform to the protocol
declare the subscript with either the `static` or `class` keyword.
Extensions that add protocol conformance to a structure, enumeration, or class
use the same keyword as the type they extend uses.
Extensions that provide a default implementation for a static subscript requirement
use the `static` keyword.

See also Declarations\#Subscript-Declaration.

#grammar-block(title: "Grammar of a protocol subscript declaration")[
_protocol-subscript-declaration_ → _subscript-head_ _subscript-result_ _generic-where-clause_\_?\_ _getter-setter-keyword-block_
]

=== Protocol Associated Type Declaration

Protocols declare associated types using the `associatedtype` keyword.
An associated type provides an alias for a type
that's used as part of a protocol's declaration.
Associated types are similar to type parameters in generic parameter clauses,
but they're associated with `Self` in the protocol in which they're declared.
In that context, `Self` refers to the eventual type that conforms to the protocol.
For more information and examples,
see Generics\#Associated-Types.

You use a generic `where` clause in a protocol declaration
to add constraints to an associated types inherited from another protocol,
without redeclaring the associated types.
For example, the declarations of `SubProtocol` below are equivalent:

```swift
protocol SomeProtocol {
    associatedtype SomeType
}

protocol SubProtocolA: SomeProtocol {
    // This syntax produces a warning.
    associatedtype SomeType: Equatable
}

// This syntax is preferred.
protocol SubProtocolB: SomeProtocol where SomeType: Equatable { }
```







See also Declarations\#Type-Alias-Declaration.

#grammar-block(title: "Grammar of a protocol associated type declaration")[
_protocol-associated-type-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`associatedtype`* _typealias-name_ _type-inheritance-clause_\_?\_ _typealias-assignment_\_?\_ _generic-where-clause_\_?\_
]

== Initializer Declaration

An _initializer declaration_ introduces an initializer for a class,
structure, or enumeration into your program.
Initializer declarations are declared using the `init` keyword and have
two basic forms.

Structure, enumeration, and class types can have any number of initializers,
but the rules and associated behavior for class initializers are different.
Unlike structures and enumerations, classes have two kinds of initializers:
designated initializers and convenience initializers,
as described in Initialization.

The following form declares initializers for structures, enumerations,
and designated initializers of classes:

```swift
init(parameters) {
   statements
}
```

A designated initializer of a class initializes
all of the class's properties directly. It can't call any other initializers
of the same class, and if the class has a superclass, it must call one of
the superclass's designated initializers.
If the class inherits any properties from its superclass, one of the
superclass's designated initializers must be called before any of these
properties can be set or modified in the current class.

Designated initializers can be declared in the context of a class declaration only
and therefore can't be added to a class using an extension declaration.

Initializers in structures and enumerations can call other declared initializers
to delegate part or all of the initialization process.

To declare convenience initializers for a class,
mark the initializer declaration with the `convenience` declaration modifier.

```swift
convenience init(parameters) {
   statements
}
```

Convenience initializers can delegate the initialization process to another
convenience initializer or to one of the class's designated initializers.
That said, the initialization processes must end with a call to a designated
initializer that ultimately initializes the class's properties.
Convenience initializers can't call a superclass's initializers.

You can mark designated and convenience initializers with the `required`
declaration modifier to require that every subclass implement the initializer.
A subclass’s implementation of that initializer
must also be marked with the `required` declaration modifier.

By default, initializers declared in a superclass
aren't inherited by subclasses.
That said, if a subclass initializes all of its stored properties with default values
and doesn't define any initializers of its own,
it inherits all of the superclass's initializers.
If the subclass overrides all of the superclass’s designated initializers,
it inherits the superclass’s convenience initializers.

As with methods, properties, and subscripts,
you need to mark overridden designated initializers with the `override` declaration modifier.

#memo()[
If you mark an initializer with the `required` declaration modifier,
you don't also mark the initializer with the `override` modifier
when you override the required initializer in a subclass.
]

Just like functions and methods, initializers can throw or rethrow errors.
And just like functions and methods,
you use the `throws` or `rethrows` keyword after an initializer's parameters
to indicate the appropriate behavior.
Likewise, initializers can be asynchronous,
and you use the `async` keyword to indicate this.

To see examples of initializers in various type declarations,
see Initialization.

=== Failable Initializers

A _failable initializer_ is a type of initializer that produces an optional instance
or an implicitly unwrapped optional instance of the type the initializer is declared on.
As a result, a failable initializer can return `nil` to indicate that initialization failed.

To declare a failable initializer that produces an optional instance,
append a question mark to the `init` keyword in the initializer declaration (`init?`).
To declare a failable initializer that produces an implicitly unwrapped optional instance,
append an exclamation point instead (`init!`). The example below shows an `init?`
failable initializer that produces an optional instance of a structure.

```swift
struct SomeStruct {
    let property: String
    // produces an optional instance of 'SomeStruct'
    init?(input: String) {
        if input.isEmpty {
            // discard 'self' and return 'nil'
            return nil
        }
        property = input
    }
}
```



You call an `init?` failable initializer in the same way that you call a nonfailable initializer,
except that you must deal with the optionality of the result.

```swift
if let actualInstance = SomeStruct(input: "Hello") {
    // do something with the instance of 'SomeStruct'
} else {
    // initialization of 'SomeStruct' failed and the initializer returned 'nil'
}
```



A failable initializer can return `nil`
at any point in the implementation of the initializer's body.

A failable initializer can delegate to any kind of initializer.
A nonfailable initializer can delegate to another nonfailable initializer
or to an `init!` failable initializer.
A nonfailable initializer can delegate to an `init?` failable initializer
by force-unwrapping the result of the superclass's initializer ---
for example, by writing `super.init()!`.

Initialization failure propagates through initializer delegation.
Specifically,
if a failable initializer delegates to an initializer that fails and returns `nil`,
then the initializer that delegated also fails and implicitly returns `nil`.
If a nonfailable initializer delegates to an `init!` failable initializer that fails and returns `nil`,
then a runtime error is raised
(as if you used the `!` operator to unwrap an optional that has a `nil` value).

A failable designated initializer can be overridden in a subclass
by any kind of designated initializer.
A nonfailable designated initializer can be overridden in a subclass
by a nonfailable designated initializer only.

For more information and to see examples of failable initializers,
see Initialization\#Failable-Initializers.

#grammar-block(title: "Grammar of an initializer declaration")[
_initializer-declaration_ → _initializer-head_ _generic-parameter-clause_\_?\_ _parameter-clause_ *`async`*\_?\_ _throws-clause_\_?\_ _generic-where-clause_\_?\_ _initializer-body_ \
_initializer-declaration_ → _initializer-head_ _generic-parameter-clause_\_?\_ _parameter-clause_ *`async`*\_?\_ *`rethrows`* _generic-where-clause_\_?\_ _initializer-body_ \
_initializer-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`init`* \
_initializer-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`init`* *`?`* \
_initializer-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`init`* *`!`* \
_initializer-body_ → _code-block_
]

== Deinitializer Declaration

A _deinitializer declaration_ declares a deinitializer for a class type.
Deinitializers take no parameters and have the following form:

```swift
deinit {
   statements
}
```

A deinitializer is called automatically when there are no longer any references
to a class object, just before the class object is deallocated.
A deinitializer can be declared only in the body of a class declaration ---
but not in an extension of a class ---
and each class can have at most one.

A subclass inherits its superclass's deinitializer,
which is implicitly called just before the subclass object is deallocated.
The subclass object isn't deallocated until all deinitializers in its inheritance chain
have finished executing.

Deinitializers aren't called directly.

For an example of how to use a deinitializer in a class declaration,
see Deinitialization.

#grammar-block(title: "Grammar of a deinitializer declaration")[
_deinitializer-declaration_ → _attributes_\_?\_ *`deinit`* _code-block_
]

== Extension Declaration

An _extension declaration_ allows you to extend
the behavior of existing types.
Extension declarations are declared using the `extension` keyword
and have the following form:

```swift
extension type name where requirements {
   declarations
}
```

The body of an extension declaration contains zero or more _declarations_.
These _declarations_ can include computed properties, computed type properties,
instance methods, type methods, initializers, subscript declarations,
and even class, structure, and enumeration declarations.
Extension declarations can't contain deinitializer or protocol declarations,
stored properties, property observers, or other extension declarations.
Declarations in a protocol extension can't be marked `final`.
For a discussion and several examples of extensions that include various kinds of declarations,
see Extensions.

If the _type name_ is a class, structure, or enumeration type,
the extension extends that type.
If the _type name_ is a protocol type,
the extension extends all types that conform to that protocol.

Extension declarations that extend a generic type
or a protocol with associated types
can include _requirements_.
If an instance of the extended type
or of a type that conforms to the extended protocol
satisfies the _requirements_,
the instance gains the behavior specified in the declaration.

Extension declarations can contain initializer declarations. That said,
if the type you're extending is defined in another module,
an initializer declaration must delegate to an initializer already defined in that module
to ensure members of that type are properly initialized.

Properties, methods, and initializers of an existing type
can't be overridden in an extension of that type.

Extension declarations can add protocol conformance to an existing
class, structure, or enumeration type by specifying _adopted protocols_:

```swift
extension type name: adopted protocols where requirements {
   declarations
}
```

Extension declarations can't add class inheritance to an existing class,
and therefore you can specify only a list of protocols after the _type name_ and colon.

=== Conditional Conformance

You can extend a generic type
to conditionally conform to a protocol,
so that instances of the type conform to the protocol
only when certain requirements are met.
You add conditional conformance to a protocol
by including _requirements_ in an extension declaration.

==== Overridden Requirements Aren't Used in Some Generic Contexts

In some generic contexts,
types that get behavior from conditional conformance to a protocol
don't always use the specialized implementations
of that protocol's requirements.
To illustrate this behavior,
the following example defines two protocols
and a generic type that conditionally conforms to both protocols.



```swift
protocol Loggable {
    func log()
}
extension Loggable {
    func log() {
        print(self)
    }
}

protocol TitledLoggable: Loggable {
    static var logTitle: String { get }
}
extension TitledLoggable {
    func log() {
        print("\(Self.logTitle): \(self)")
    }
}

struct Pair<T>: CustomStringConvertible {
    let first: T
    let second: T
    var description: String {
        return "(\(first), \(second))"
    }
}

extension Pair: Loggable where T: Loggable { }
extension Pair: TitledLoggable where T: TitledLoggable {
    static var logTitle: String {
        return "Pair of '\(T.logTitle)'"
    }
}

extension String: TitledLoggable {
    static var logTitle: String {
        return "String"
    }
}
```



The `Pair` structure conforms to `Loggable` and `TitledLoggable`
whenever its generic type conforms to `Loggable` or `TitledLoggable`, respectively.
In the example below,
`oneAndTwo` is an instance of `Pair<String>`,
which conforms to `TitledLoggable`
because `String` conforms to `TitledLoggable`.
When the `log()` method is called on `oneAndTwo` directly,
the specialized version containing the title string is used.

```swift
let oneAndTwo = Pair(first: "one", second: "two")
oneAndTwo.log()
// Prints "Pair of 'String': (one, two)".
```



However, when `oneAndTwo` is used in a generic context
or as an instance of the `Loggable` protocol,
the specialized version isn't used.
Swift picks which implementation of `log()` to call
by consulting only the minimum requirements that `Pair` needs to conform to `Loggable`.
For this reason,
the default implementation provided by the `Loggable` protocol is used instead.

```swift
func doSomething<T: Loggable>(with x: T) {
    x.log()
}
doSomething(with: oneAndTwo)
// Prints "(one, two)".
```



When `log()` is called on the instance that's passed to `doSomething(_:)`,
the customized title is omitted from the logged string.

=== Protocol Conformance Must Not Be Redundant

A concrete type can conform to a particular protocol only once.
Swift marks redundant protocol conformances as an error.
You're likely to encounter this kind of error
in two kinds of situations.
The first situation is when
you explicitly conform to the same protocol multiple times,
but with different requirements.
The second situation is when
you implicitly inherit from the same protocol multiple times.
These situations are discussed in the sections below.

==== Resolving Explicit Redundancy

Multiple extensions on a concrete type
can't add conformance to the same protocol,
even if the extensions' requirements are mutually exclusive.
This restriction is demonstrated in the example below.
Two extension declarations attempt to add conditional conformance
to the `Serializable` protocol,
one for arrays with `Int` elements,
and one for arrays with `String` elements.

```swift
protocol Serializable {
    func serialize() -> Any
}

extension Array: Serializable where Element == Int {
    func serialize() -> Any {
        // implementation
    }
}
extension Array: Serializable where Element == String {
    func serialize() -> Any {
        // implementation
    }
}
// Error: Redundant conformance of 'Array<Element>' to protocol 'Serializable'.
```



If you need to add conditional conformance based on multiple concrete types,
create a new protocol that each type can conform to
and use that protocol as the requirement when declaring conditional conformance.

```swift
protocol SerializableInArray { }
extension Int: SerializableInArray { }
extension String: SerializableInArray { }

extension Array: Serializable where Element: SerializableInArray {
    func serialize() -> Any {
        // implementation
    }
}
```



==== Resolving Implicit Redundancy

When a concrete type conditionally conforms to a protocol,
that type implicitly conforms to any parent protocols
with the same requirements.

If you need a type to conditionally conform to two protocols
that inherit from a single parent,
explicitly declare conformance to the parent protocol.
This avoids implicitly conforming to the parent protocol twice
with different requirements.

The following example explicitly declares
the conditional conformance of `Array` to `Loggable`
to avoid a conflict when declaring its conditional conformance
to both `TitledLoggable` and the new `MarkedLoggable` protocol.

```swift
protocol MarkedLoggable: Loggable {
    func markAndLog()
}

extension MarkedLoggable {
    func markAndLog() {
        print("----------")
        log()
    }
}

extension Array: Loggable where Element: Loggable { }
extension Array: TitledLoggable where Element: TitledLoggable {
    static var logTitle: String {
        return "Array of '\(Element.logTitle)'"
    }
}
extension Array: MarkedLoggable where Element: MarkedLoggable { }
```



Without the extension
to explicitly declare conditional conformance to `Loggable`,
the other `Array` extensions would implicitly create these declarations,
resulting in an error:

#grammar-block(title: "Grammar of an extension declaration")[
_extension-declaration_ → _attributes_\_?\_ _access-level-modifier_\_?\_ *`extension`* _type-identifier_ _type-inheritance-clause_\_?\_ _generic-where-clause_\_?\_ _extension-body_ \
_extension-body_ → *`{`* _extension-members_\_?\_ *`}`*

_extension-members_ → _extension-member_ _extension-members_\_?\_ \
_extension-member_ → _declaration_ | _compiler-control-statement_
]
```swift
extension Array: Loggable where Element: TitledLoggable { }
extension Array: Loggable where Element: MarkedLoggable { }
// Error: Redundant conformance of 'Array<Element>' to protocol 'Loggable'.
```

== Subscript Declaration

A _subscript_ declaration allows you to add subscripting support for objects
of a particular type and are typically used to provide a convenient syntax
for accessing the elements in a collection, list, or sequence.
Subscript declarations are declared using the `subscript` keyword
and have the following form:

```swift
subscript (parameters) -> return type {
   get {
      statements
   }
   set(setter name) {
      statements
   }
}
```

Subscript declarations can appear only in the context of a class, structure,
enumeration, extension, or protocol declaration.

The _parameters_ specify one or more indexes used to access elements of the corresponding type
in a subscript expression (for example, the `i` in the expression `object[i]`).
Although the indexes used to access the elements can be of any type,
each parameter must include a type annotation to specify the type of each index.
The _return type_ specifies the type of the element being accessed.

As with computed properties,
subscript declarations support reading and writing the value of the accessed elements.
The getter is used to read the value,
and the setter is used to write the value.
The setter clause is optional,
and when only a getter is needed, you can omit both clauses and simply
return the requested value directly.
That said, if you provide a setter clause, you must also provide a getter clause.

The _setter name_ and enclosing parentheses are optional.
If you provide a setter name, it's used as the name of the parameter to the setter.
If you don't provide a setter name, the default parameter name to the setter is `newValue`.
The type of the parameter to the setter is the same as the _return type_.

You can overload a subscript declaration in the type in which it's declared,
as long as the _parameters_ or the _return type_ differ from the one you're overloading.
You can also override a subscript declaration inherited from a superclass. When you do so,
you must mark the overridden subscript declaration with the `override` declaration modifier.

Subscript parameters follow the same rules as function parameters,
with two exceptions.
By default, the parameters used in subscripting don't have argument labels,
unlike functions, methods, and initializers.
However, you can provide explicit argument labels
using the same syntax that functions, methods, and initializers use.
In addition, subscripts can't have in-out parameters.
A subscript parameter can have a default value,
using the syntax described in Declarations\#Special-Kinds-of-Parameters.

You can also declare subscripts in the context of a protocol declaration,
as described in Declarations\#Protocol-Subscript-Declaration.

For more information about subscripting and to see examples of subscript declarations,
see Subscripts.

=== Type Subscript Declarations

To declare a subscript that's exposed by the type,
rather than by instances of the type,
mark the subscript declaration with the `static` declaration modifier.
Classes can mark type computed properties with the `class` declaration modifier instead
to allow subclasses to override the superclass’s implementation.
In a class declaration,
the `static` keyword has the same effect as marking the declaration
with both the `class` and `final` declaration modifiers.



#grammar-block(title: "Grammar of a subscript declaration")[
_subscript-declaration_ → _subscript-head_ _subscript-result_ _generic-where-clause_\_?\_ _code-block_ \
_subscript-declaration_ → _subscript-head_ _subscript-result_ _generic-where-clause_\_?\_ _getter-setter-block_ \
_subscript-declaration_ → _subscript-head_ _subscript-result_ _generic-where-clause_\_?\_ _getter-setter-keyword-block_ \
_subscript-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`subscript`* _generic-parameter-clause_\_?\_ _parameter-clause_ \
_subscript-result_ → *`->`* _attributes_\_?\_ _type_
]

== Macro Declaration

A _macro declaration_ introduces a new macro.
It begins with the `macro` keyword
and has the following form:

```swift
macro name = macro implementation
```

The _macro implementation_ is another macro,
and indicates the location of the code that performs this macro's expansion.
The code that performs macro expansion is a separate Swift program,
that uses the SwiftSyntax module to interact with Swift code.
Call the `externalMacro(module:type:)` macro from the Swift standard library,
passing in the name of a type that contains the macro's implementation,
and the name of the module that contains that type.



Macros can be overloaded,
following the same model used by functions.
A macro declaration appears only at file scope.

For an overview of macros in Swift, see Macros.

#grammar-block(title: "Grammar of a macro declaration")[
_macro-declaration_ → _macro-head_ _identifier_ _generic-parameter-clause_\_?\_ _macro-signature_ _macro-definition_\_?\_ _generic-where-clause_ \
_macro-head_ → _attributes_\_?\_ _declaration-modifiers_\_?\_ *`macro`* \
_macro-signature_ → _parameter-clause_ _macro-function-signature-result_\_?\_ \
_macro-function-signature-result_ → *`->`* _type_ \
_macro-definition_ → *`=`* _expression_
]

== Operator Declaration

An _operator declaration_ introduces a new infix, prefix,
or postfix operator into your program
and is declared using the `operator` keyword.

You can declare operators of three different fixities:
infix, prefix, and postfix.
The _fixity_ of an operator specifies the relative position of an operator
to its operands.

There are three basic forms of an operator declaration,
one for each fixity.
The fixity of the operator is specified by marking the operator declaration with the
`infix`, `prefix`, or `postfix` declaration modifier before the `operator` keyword.
In each form, the name of the operator can contain only the operator characters
defined in LexicalStructure\#Operators.

The following form declares a new infix operator:

```swift
infix operator operator name: precedence group
```

An _infix operator_ is a binary operator that's written between its two operands,
such as the familiar addition operator (`+`) in the expression `1 + 2`.

Infix operators can optionally specify a precedence group.
If you omit the precedence group for an operator,
Swift uses the default precedence group, `DefaultPrecedence`,
which specifies a precedence just higher than `TernaryPrecedence`.
For more information, see Declarations\#Precedence-Group-Declaration.

The following form declares a new prefix operator:

```swift
prefix operator operator name
```

A _prefix operator_ is a unary operator that's written immediately before its operand,
such as the prefix logical NOT operator (`!`) in the expression `!a`.

Prefix operators declarations don't specify a precedence level.
Prefix operators are nonassociative.

The following form declares a new postfix operator:

```swift
postfix operator operator name
```

A _postfix operator_ is a unary operator that's written immediately after its operand,
such as the postfix forced-unwrap operator (`!`) in the expression `a!`.

As with prefix operators, postfix operator declarations don't specify a precedence level.
Postfix operators are nonassociative.

After declaring a new operator,
you implement it by declaring a static method that has the same name as the operator.
The static method is a member of
one of the types whose values the operator takes as an argument ---
for example, an operator that multiplies a `Double` by an `Int`
is implemented as a static method on either the `Double` or `Int` structure.
If you're implementing a prefix or postfix operator,
you must also mark that method declaration with the corresponding `prefix` or `postfix`
declaration modifier.
To see an example of how to create and implement a new operator,
see AdvancedOperators\#Custom-Operators.

#grammar-block(title: "Grammar of an operator declaration")[
_operator-declaration_ → _prefix-operator-declaration_ | _postfix-operator-declaration_ | _infix-operator-declaration_

_prefix-operator-declaration_ → *`prefix`* *`operator`* _operator_ \
_postfix-operator-declaration_ → *`postfix`* *`operator`* _operator_ \
_infix-operator-declaration_ → *`infix`* *`operator`* _operator_ _infix-operator-group_\_?\_

_infix-operator-group_ → *`:`* _precedence-group-name_
]

== Precedence Group Declaration

A _precedence group declaration_ introduces
a new grouping for infix operator precedence into your program.
The precedence of an operator specifies how tightly the operator
binds to its operands, in the absence of grouping parentheses.

A precedence group declaration has the following form:

```swift
precedencegroup precedence group name {
    higherThan: lower group names
    lowerThan: higher group names
    associativity: associativity
    assignment: assignment
}
```

The _lower group names_ and _higher group names_ lists specify
the new precedence group's relation to existing precedence groups.
The `lowerThan` precedence group attribute may only be used
to refer to precedence groups declared outside of the current module.
When two operators compete with each other for their operands,
such as in the expression `2 + 3 * 5`,
the operator with the higher relative precedence
binds more tightly to its operands.

#memo()[
Precedence groups related to each other
using _lower group names_ and _higher group names_
must fit into a single relational hierarchy,
but they _don't_ have to form a linear hierarchy.
This means it's possible to have precedence groups
with undefined relative precedence.
Operators from those precedence groups
can't be used next to each other without grouping parentheses.
]

Swift defines numerous precedence groups to go along
with the operators provided by the Swift standard library.
For example, the addition (`+`) and subtraction (`-`) operators
belong to the `AdditionPrecedence` group,
and the multiplication (`*`) and division (`/`) operators
belong to the `MultiplicationPrecedence` group.
For a complete list of precedence groups
provided by the Swift standard library,
see #link("https://developer.apple.com/documentation/swift/operator\_declarations")[Operator Declarations].

The _associativity_ of an operator specifies how a sequence of operators
with the same precedence level are grouped together in the absence of grouping parentheses.
You specify the associativity of an operator by writing
one of the context-sensitive keywords `left`, `right`, or `none` ---
if your omit the associativity, the default is `none`.
Operators that are left-associative group left-to-right.
For example,
the subtraction operator (`-`) is left-associative,
so the expression `4 - 5 - 6` is grouped as `(4 - 5) - 6`
and evaluates to `-7`.
Operators that are right-associative group right-to-left,
and operators that are specified with an associativity of `none`
don't associate at all.
Nonassociative operators of the same precedence level
can't appear adjacent to each to other.
For example,
the `<` operator has an associativity of `none`,
which means `1 < 2 < 3` isn't a valid expression.

The _assignment_ of a precedence group specifies the precedence of an operator
when used in an operation that includes optional chaining.
When set to `true`, an operator in the corresponding precedence group
uses the same grouping rules during optional chaining
as the assignment operators from the Swift standard library.
Otherwise, when set to `false` or omitted,
operators in the precedence group follows the same optional chaining rules
as operators that don't perform assignment.

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

== Declaration Modifiers

_Declaration modifiers_ are keywords or context-sensitive keywords that modify the behavior
or meaning of a declaration. You specify a declaration modifier by writing the appropriate
keyword or context-sensitive keyword between a declaration's attributes (if any) and the keyword
that introduces the declaration.

- term `class`:
  Apply this modifier to a member of a class
  to indicate that the member is a member of the class itself,
  rather than a member of instances of the class.
  Members of a superclass that have this modifier
  and don't have the `final` modifier
  can be overridden by subclasses.

- term `dynamic`:
  Apply this modifier to any member of a class that can be represented by Objective-C.
  When you mark a member declaration with the `dynamic` modifier,
  access to that member is always dynamically dispatched using the Objective-C runtime.
  Access to that member is never inlined or devirtualized by the compiler.

  Because declarations marked with the `dynamic` modifier are dispatched
  using the Objective-C runtime, they must be marked with the
  `objc` attribute.

- term `final`:
  Apply this modifier to a class or to a property, method,
  or subscript member of a class. It's applied to a class to indicate that the class
  can't be subclassed. It's applied to a property, method, or subscript of a class
  to indicate that a class member can't be overridden in any subclass.
  For an example of how to use the `final` attribute,
  see Inheritance\#Preventing-Overrides.

- term `lazy`:
  Apply this modifier to a stored variable property of a class or structure
  to indicate that the property's initial value is calculated and stored at most
  once, when the property is first accessed.
  For an example of how to use the `lazy` modifier,
  see Properties\#Lazy-Stored-Properties.

- term `optional`:
  Apply this modifier to a protocol's property, method,
  or subscript members to indicate that a conforming type isn't required
  to implement those members.

  You can apply the `optional` modifier only to protocols that are marked
  with the `objc` attribute. As a result, only class types can adopt and conform
  to a protocol that contains optional member requirements.
  For more information about how to use the `optional` modifier
  and for guidance about how to access optional protocol members ---
  for example, when you're not sure whether a conforming type implements them ---
  see Protocols\#Optional-Protocol-Requirements.



- term `required`:
  Apply this modifier to a designated or convenience initializer
  of a class to indicate that every subclass must implement that initializer.
  The subclass's implementation of that initializer
  must also be marked with the `required` modifier.

- term `static`:
  Apply this modifier to a member of a structure, class, enumeration, or protocol
  to indicate that the member is a member of the type,
  rather than a member of instances of that type.
  In the scope of a class declaration,
  writing the `static` modifier on a member declaration
  has the same effect as writing the `class` and `final` modifiers
  on that member declaration.
  However, constant type properties of a class are an exception:
  `static` has its normal, nonclass meaning there
  because you can't write `class` or `final` on those declarations.

- term `unowned`:
  Apply this modifier to a stored variable, constant, or stored property
  to indicate that the variable or property has an unowned reference
  to the object stored as its value.
  If you try to access the variable or property
  after the object has been deallocated,
  a runtime error is raised.
  Like a weak reference,
  the type of the property or value must be a class type;
  unlike a weak reference,
  the type is non-optional.
  For an example and more information about the `unowned` modifier,
  see AutomaticReferenceCounting\#Unowned-References.

- term `unowned(safe)`:
  An explicit spelling of `unowned`.

- term `unowned(unsafe)`:
  Apply this modifier to a stored variable, constant, or stored property
  to indicate that the variable or property has an unowned reference
  to the object stored as its value.
  If you try to access the variable or property
  after the object has been deallocated,
  you'll access the memory at the location where the object used to be,
  which is a memory-unsafe operation.
  Like a weak reference,
  the type of the property or value must be a class type;
  unlike a weak reference,
  the type is non-optional.
  For an example and more information about the `unowned` modifier,
  see AutomaticReferenceCounting\#Unowned-References.

- term `weak`:
  Apply this modifier to a stored variable or stored variable property
  to indicate that the variable or property has a weak reference to the
  object stored as its value. The type of the variable or property
  must be an optional class type.
  If you access the variable or property
  after the object has been deallocated,
  its value is `nil`.
  For an example and more information about the `weak` modifier,
  see AutomaticReferenceCounting\#Weak-References.

=== Access Control Levels

Swift provides five levels of access control: open, public, internal, file private, and private.
You can mark a declaration with one of the access-level modifiers below
to specify the declaration's access level.
Access control is discussed in detail in AccessControl.

- term `open`:
  Apply this modifier to a declaration to indicate the declaration can be accessed and subclassed
  by code in the same module as the declaration.
  Declarations marked with the `open` access-level modifier can also be accessed and subclassed
  by code in a module that imports the module that contains that declaration.

- term `public`:
  Apply this modifier to a declaration to indicate the declaration can be accessed and subclassed
  by code in the same module as the declaration.
  Declarations marked with the `public` access-level modifier can also be accessed (but not subclassed)
  by code in a module that imports the module that contains that declaration.

- term `package`:
  Apply this modifier to a declaration
  to indicate that the declaration can be accessed
  only by code in the same package as the declaration.
  A package is a unit of code distribution
  that you define in the build system you're using.
  When the build system compiles code,
  it specifies the package name
  by passing the `-package-name` flag to the Swift compiler.
  Two modules are part of the same package
  if the build system specifies the same package name when building them.

- term `internal`:
  Apply this modifier to a declaration to indicate the declaration can be accessed
  only by code in the same module as the declaration.
  By default,
  most declarations are implicitly marked with the `internal` access-level modifier.

- term `fileprivate`:
  Apply this modifier to a declaration to indicate the declaration can be accessed
  only by code in the same source file as the declaration.

- term `private`:
  Apply this modifier to a declaration to indicate the declaration can be accessed
  only by code within the declaration's immediate enclosing scope.

For the purpose of access control,
extensions behave as follows:

- If there are multiple extensions in the same file,
  and those extensions all extend the same type,
  then all of those extensions have the same access-control scope.
  The extensions and the type they extend can be in different files.

- If there are extensions in the same file as the type they extend,
  the extensions have the same access-control scope as the type they extend.

- Private members declared in a type's declaration
  can be accessed from extensions to that type.
  Private members declared in one extension
  can be accessed from other extensions
  and from the extended type's declaration.

Each access-level modifier above optionally accepts a single argument,
which consists of the `set` keyword enclosed in parentheses ---
for example, `private(set)`.
Use this form of an access-level modifier when you want to specify an access level
for the setter of a variable or subscript that's less than or equal
to the access level of the variable or subscript itself,
as discussed in AccessControl\#Getters-and-Setters.

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




