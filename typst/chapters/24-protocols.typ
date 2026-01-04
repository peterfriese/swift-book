#import "@local/eightbyten:0.1.0": *
#import "../utils.typ": grammar-block, experiment, important, deprecated, memo


#chapter("Protocols", eyebrow: "Defining requirements")

A _protocol_ defines a blueprint of
methods, properties, and other requirements
that suit a particular task or piece of functionality.
The protocol can then be _adopted_ by a class, structure, or enumeration
to provide an actual implementation of those requirements.
Any type that satisfies the requirements of a protocol is said to
_conform_ to that protocol.

In addition to specifying requirements that conforming types must implement,
you can extend a protocol to implement some of these requirements
or to implement additional functionality that conforming types can take advantage of.



== Protocol Syntax

You define protocols in a very similar way to classes, structures, and enumerations:

```swift
protocol SomeProtocol {
    // protocol definition goes here
}
```



Custom types state that they adopt a particular protocol
by placing the protocol's name after the type's name,
separated by a colon, as part of their definition.
Multiple protocols can be listed, and are separated by commas:

```swift
struct SomeStructure: FirstProtocol, AnotherProtocol {
    // structure definition goes here
}
```



If a class has a superclass, list the superclass name
before any protocols it adopts, followed by a comma:

#memo()[
Because protocols are types,
begin their names with a capital letter
(such as `FullyNamed` and `RandomNumberGenerator`)
to match the names of other types in Swift
(such as `Int`, `String`, and `Double`).
]
```swift
class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
    // class definition goes here
}
```

== Property Requirements

A protocol can require any conforming type to provide
an instance property or type property with a particular name and type.
The protocol doesn't specify whether the property should be
a stored property or a computed property ---
it only specifies the required property name and type.
The protocol also specifies whether each property must be gettable
or gettable _and_ settable.

If a protocol requires a property to be gettable and settable,
that property requirement can't be fulfilled by
a constant stored property or a read-only computed property.
If the protocol only requires a property to be gettable,
the requirement can be satisfied by any kind of property,
and it's valid for the property to be also settable
if this is useful for your own code.

Property requirements are always declared as variable properties,
prefixed with the `var` keyword.
Gettable and settable properties are indicated by writing
`{ get set }` after their type declaration,
and gettable properties are indicated by writing `{ get }`.

```swift
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}
```



Always prefix type property requirements with the `static` keyword
when you define them in a protocol.
This rule pertains even though type property requirements can be prefixed with
the `class` or `static` keyword when implemented by a class:

```swift
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}
```



Here's an example of a protocol with a single instance property requirement:

```swift
protocol FullyNamed {
    var fullName: String { get }
}
```



The `FullyNamed` protocol requires a conforming type to provide a fully qualified name.
The protocol doesn't specify anything else about the nature of the conforming type ---
it only specifies that the type must be able to provide a full name for itself.
The protocol states that any `FullyNamed` type must have
a gettable instance property called `fullName`, which is of type `String`.

Here's an example of a simple structure that adopts and conforms to
the `FullyNamed` protocol:

```swift
struct Person: FullyNamed {
    var fullName: String
}
let john = Person(fullName: "John Appleseed")
// john.fullName is "John Appleseed"
```



This example defines a structure called `Person`,
which represents a specific named person.
It states that it adopts the `FullyNamed` protocol
as part of the first line of its definition.

Each instance of `Person` has a single stored property called `fullName`,
which is of type `String`.
This matches the single requirement of the `FullyNamed` protocol,
and means that `Person` has correctly conformed to the protocol.
(Swift reports an error at compile time if a protocol requirement isn't fulfilled.)

Here's a more complex class, which also adopts and conforms to the `FullyNamed` protocol:

```swift
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
// ncc1701.fullName is "USS Enterprise"
```



This class implements the `fullName` property requirement as
a computed read-only property for a starship.
Each `Starship` class instance stores a mandatory `name` and an optional `prefix`.
The `fullName` property uses the `prefix` value if it exists,
and prepends it to the beginning of `name` to create a full name for the starship.



== Method Requirements

Protocols can require specific instance methods and type methods
to be implemented by conforming types.
These methods are written as part of the protocol's definition
in exactly the same way as for normal instance and type methods,
but without curly braces or a method body.
Variadic parameters are allowed, subject to the same rules as for normal methods.
Default values, however, can't be specified for method parameters within a protocol's definition.

As with type property requirements,
you always prefix type method requirements with the `static` keyword
when they're defined in a protocol.
This is true even though type method requirements are prefixed with
the `class` or `static` keyword when implemented by a class:

```swift
protocol SomeProtocol {
    static func someTypeMethod()
}
```



The following example defines a protocol with a single instance method requirement:

```swift
protocol RandomNumberGenerator {
    func random() -> Double
}
```



This protocol, `RandomNumberGenerator`, requires any conforming type
to have an instance method called `random`,
which returns a `Double` value whenever it's called.
Although it's not specified as part of the protocol,
it's assumed that this value will be
a number from `0.0` up to (but not including) `1.0`.

The `RandomNumberGenerator` protocol doesn't make any assumptions
about how each random number will be generated ---
it simply requires the generator to provide a standard way
to generate a new random number.

Here's an implementation of a class that adopts and conforms to
the `RandomNumberGenerator` protocol.
This class implements a pseudorandom number generator algorithm known as
a _linear congruential generator_:

```swift
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c)
            .truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// Prints "Here's a random number: 0.3746499199817101".
print("And another one: \(generator.random())")
// Prints "And another one: 0.729023776863283".
```



== Mutating Method Requirements

It's sometimes necessary for a method to modify (or _mutate_) the instance it belongs to.
For instance methods on value types (that is, structures and enumerations)
you place the `mutating` keyword before a method's `func` keyword
to indicate that the method is allowed to modify the instance it belongs to
and any properties of that instance.
This process is described in Methods\#Modifying-Value-Types-from-Within-Instance-Methods.

If you define a protocol instance method requirement
that's intended to mutate instances of any type that adopts the protocol,
mark the method with the `mutating` keyword
as part of the protocol's definition.
This enables structures and enumerations to adopt the protocol
and satisfy that method requirement.

#memo()[
If you mark a protocol instance method requirement as `mutating`,
you don't need to write the `mutating` keyword when writing
an implementation of that method for a class.
The `mutating` keyword is only used by structures and enumerations.
]

The example below defines a protocol called `Togglable`,
which defines a single instance method requirement called `toggle`.
As its name suggests, the `toggle()` method is intended to
toggle or invert the state of any conforming type,
typically by modifying a property of that type.

The `toggle()` method is marked with the `mutating` keyword
as part of the `Togglable` protocol definition,
to indicate that the method is expected to mutate the state of a conforming instance
when it's called:

```swift
protocol Togglable {
    mutating func toggle()
}
```



If you implement the `Togglable` protocol for a structure or enumeration,
that structure or enumeration can conform to the protocol
by providing an implementation of the `toggle()` method
that's also marked as `mutating`.

The example below defines an enumeration called `OnOffSwitch`.
This enumeration toggles between two states,
indicated by the enumeration cases `on` and `off`.
The enumeration's `toggle` implementation is marked as `mutating`,
to match the `Togglable` protocol's requirements:

```swift
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
// lightSwitch is now equal to .on
```



== Initializer Requirements

Protocols can require specific initializers
to be implemented by conforming types.
You write these initializers as part of the protocol's definition
in exactly the same way as for normal initializers,
but without curly braces or an initializer body:

```swift
protocol SomeProtocol {
    init(someParameter: Int)
}
```



=== Class Implementations of Protocol Initializer Requirements

You can implement a protocol initializer requirement on a conforming class
as either a designated initializer or a convenience initializer.
In both cases,
you must mark the initializer implementation with the `required` modifier:

```swift
class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        // initializer implementation goes here
    }
}
```





The use of the `required` modifier ensures that
you provide an explicit or inherited implementation of the initializer requirement
on all subclasses of the conforming class,
such that they also conform to the protocol.

For more information on required initializers,
see Initialization\#Required-Initializers.





#memo()[
You don't need to mark protocol initializer implementations with the `required` modifier
on classes that are marked with the `final` modifier,
because final classes can't subclassed.
For more about the `final` modifier, see Inheritance\#Preventing-Overrides.
]



If a subclass overrides a designated initializer from a superclass,
and also implements a matching initializer requirement from a protocol,
mark the initializer implementation with both the `required` and `override` modifiers:

```swift
protocol SomeProtocol {
    init()
}

class SomeSuperClass {
    init() {
        // initializer implementation goes here
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}
```



=== Failable Initializer Requirements

Protocols can define failable initializer requirements for conforming types,
as defined in Initialization\#Failable-Initializers.

A failable initializer requirement can be satisfied by
a failable or nonfailable initializer on a conforming type.
A nonfailable initializer requirement can be satisfied by
a nonfailable initializer or an implicitly unwrapped failable initializer.

















== Protocols that Have Only Semantic Requirements

All of the example protocols above require some methods or properties,
but a protocol declaration doesn't have to include any requirements.
You can also use a protocol to describe _semantic_ requirements ---
that is, requirements about how values of those types behave
and about operations that they support.

The Swift standard library defines several protocols
that don't have any required methods or properties:

- `Sendable` for values that can be shared across concurrency domains,
  as discussed in Concurrency\#Sendable-Types.
- `Copyable` for values that Swift can copy
  when you pass them to a function,
  as discussed in Declarations\#Borrowing-and-Consuming-Parameters.
- `BitwiseCopyable` for values that can be copied, bit-by-bit.







For information about these protocols' requirements,
see the overview in their documentation.

You use the same syntax to adopt these protocols
as you do to adopt other protocols.
The only difference is that you don't include
method or property declarations that implement the protocol's requirements.
For example:

```swift
struct MyStruct: Copyable {
    var counter = 12
}

extension MyStruct: BitwiseCopyable { }
```

The code above defines a new structure.
Because `Copyable` has only semantic requirements,
there isn't any code in the structure declaration to adopt the protocol.
Similarly, because `BitwiseCopyable` has only semantic requirements,
the extension that adopts that protocol has an empty body.

You usually don't need to write conformance to these protocols ---
instead, Swift implicitly adds the conformance for you,
as described in Protocols\#Implicit-Conformance-to-a-Protocol.



== Protocols as Types

Protocols don't actually implement any functionality themselves.
Regardless, you can use a protocol as a type in your code.

The most common way to use a protocol as a type
is to use a protocol as a generic constraint.
Code with generic constraints can work with
any type that conforms to the protocol,
and the specific type is chosen by the code that uses the API.
For example,
when you call a function that takes an argument
and that argument's type is generic,
the caller chooses the type.

Code with an opaque type
works with some type that conforms to the protocol.
The underlying type is known at compile time,
and the API implementation chooses that type,
but that type's identity is hidden from clients of the API.
Using an opaque type lets you prevent implementation details of an API
from leaking through the layer of abstraction ---
for example, by hiding the specific return type from a function,
and only guaranteeing that the value conforms to a given protocol.

Code with a boxed protocol type
works with any type, chosen at runtime, that conforms to the protocol.
To support this runtime flexibility,
Swift adds a level of indirection when necessary ---
known as a _box_,
which has a performance cost.
Because of this flexibility,
Swift doesn't know the underlying type at compile time,
which means you can access only the members
that are required by the protocol.
Accessing any other APIs on the underlying type
requires casting at runtime.

For information about using protocols as generic constraints,
see Generics.
For information about opaque types, and boxed protocol types,
see OpaqueTypes.



== Delegation

_Delegation_ is a design pattern that enables
a class or structure to hand off (or _delegate_)
some of its responsibilities to an instance of another type.
This design pattern is implemented by defining
a protocol that encapsulates the delegated responsibilities,
such that a conforming type (known as a delegate)
is guaranteed to provide the functionality that has been delegated.
Delegation can be used to respond to a particular action,
or to retrieve data from an external source without needing to know
the underlying type of that source.

The example below defines a dice game
and a nested protocol for a delegate
that tracks the game's progress:

```swift
class DiceGame {
    let sides: Int
    let generator = LinearCongruentialGenerator()
    weak var delegate: Delegate?

    init(sides: Int) {
        self.sides = sides
    }

    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }

    func play(rounds: Int) {
        delegate?.gameDidStart(self)
        for round in 1...rounds {
            let player1 = roll()
            let player2 = roll()
            if player1 == player2 {
                delegate?.game(self, didEndRound: round, winner: nil)
            } else if player1 > player2 {
                delegate?.game(self, didEndRound: round, winner: 1)
            } else {
                delegate?.game(self, didEndRound: round, winner: 2)
            }
        }
        delegate?.gameDidEnd(self)
    }

    protocol Delegate: AnyObject {
        func gameDidStart(_ game: DiceGame)
        func game(_ game: DiceGame, didEndRound round: Int, winner: Int?)
        func gameDidEnd(_ game: DiceGame)
    }
}
```

The `DiceGame` class implements a game where
each player takes a turn rolling dice,
and the player who rolls the highest number wins the round.
It uses a linear congruential generator
from the example earlier in the chapter,
to generate random numbers for dice rolls.

The `DiceGame.Delegate` protocol can be adopted
to track the progress of a dice game.
Because the `DiceGame.Delegate` protocol
is always used in the context of a dice game,
it's nested inside of the `DiceGame` class.
Protocols can be nested
inside of type declarations like structures and classes,
as long as the outer declaration isn't generic.
For information about nesting types, see NestedTypes.

To prevent strong reference cycles,
delegates are declared as weak references.
For information about weak references,
see AutomaticReferenceCounting\#Strong-Reference-Cycles-Between-Class-Instances.
Marking the protocol as class-only
lets the `DiceGame` class
declare that its delegate must use a weak reference.
A class-only protocol
is marked by its inheritance from `AnyObject`,
as discussed in Protocols\#Class-Only-Protocols.

`DiceGame.Delegate` provides three methods for tracking the progress of a game.
These three methods are incorporated into the game logic
in the `play(rounds:)` method above.
The `DiceGame` class calls its delegate methods when
a new game starts, a new turn begins, or the game ends.

Because the `delegate` property is an _optional_ `DiceGame.Delegate`,
the `play(rounds:)` method uses optional chaining each time it calls a method on the delegate,
as discussed in OptionalChaining.
If the `delegate` property is nil,
these delegate calls are ignored.
If the `delegate` property is non-nil,
the delegate methods are called,
and are passed the `DiceGame` instance as a parameter.

This next example shows a class called `DiceGameTracker`,
which adopts the `DiceGame.Delegate` protocol:

```swift
class DiceGameTracker: DiceGame.Delegate {
    var playerScore1 = 0
    var playerScore2 = 0
    func gameDidStart(_ game: DiceGame) {
        print("Started a new game")
        playerScore1 = 0
        playerScore2 = 0
    }
    func game(_ game: DiceGame, didEndRound round: Int, winner: Int?) {
        switch winner {
            case 1:
                playerScore1 += 1
                print("Player 1 won round \(round)")
            case 2: playerScore2 += 1
                print("Player 2 won round \(round)")
            default:
                print("The round was a draw")
        }
    }
    func gameDidEnd(_ game: DiceGame) {
        if playerScore1 == playerScore2 {
            print("The game ended in a draw.")
        } else if playerScore1 > playerScore2 {
            print("Player 1 won!")
        } else {
            print("Player 2 won!")
        }
    }
}
```

The `DiceGameTracker` class implements all three methods
that are required by the `DiceGame.Delegate` protocol.
It uses these methods to zero out both players' scores
at the start of a new game,
to update their scores at the end of each round,
and to announce a winner at the end of the game.

Here's how `DiceGame` and `DiceGameTracker` look in action:

```swift
let tracker = DiceGameTracker()
let game = DiceGame(sides: 6)
game.delegate = tracker
game.play(rounds: 3)
// Started a new game
// Player 2 won round 1
// Player 2 won round 2
// Player 1 won round 3
// Player 2 won!
```

== Adding Protocol Conformance with an Extension

You can extend an existing type to adopt and conform to a new protocol,
even if you don't have access to the source code for the existing type.
Extensions can add new properties, methods, and subscripts to an existing type,
and are therefore able to add any requirements that a protocol may demand.
For more about extensions, see Extensions.

#memo()[
Existing instances of a type automatically adopt and conform to a protocol
when that conformance is added to the instance's type in an extension.
]

For example, this protocol, called `TextRepresentable`, can be implemented by
any type that has a way to be represented as text.
This might be a description of itself, or a text version of its current state:

```swift
protocol TextRepresentable {
    var textualDescription: String { get }
}
```



The `Dice` class from above can be extended to adopt and conform to `TextRepresentable`:



```swift
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
```



This extension adopts the new protocol in exactly the same way
as if `Dice` had provided it in its original implementation.
The protocol name is provided after the type name, separated by a colon,
and an implementation of all requirements of the protocol
is provided within the extension's curly braces.

Any `Dice` instance can now be treated as `TextRepresentable`:

```swift
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)
// Prints "A 12-sided dice".
```



Similarly, the `SnakesAndLadders` game class can be extended to
adopt and conform to the `TextRepresentable` protocol:

```swift
extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}
print(game.textualDescription)
// Prints "A game of Snakes and Ladders with 25 squares".
```



=== Conditionally Conforming to a Protocol

A generic type may be able to satisfy the requirements of a protocol
only under certain conditions,
such as when the type's generic parameter conforms to the protocol.
You can make a generic type conditionally conform to a protocol
by listing constraints when extending the type.
Write these constraints after the name of the protocol you're adopting
by writing a generic `where` clause.
For more about generic `where` clauses, see Generics\#Generic-Where-Clauses.

The following extension
makes `Array` instances conform to the `TextRepresentable` protocol
whenever they store elements of a type that conforms to `TextRepresentable`.

```swift
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let myDice = [d6, d12]
print(myDice.textualDescription)
// Prints "[A 6-sided dice, A 12-sided dice]".
```



=== Declaring Protocol Adoption with an Extension

If a type already conforms to all of the requirements of a protocol,
but hasn't yet stated that it adopts that protocol,
you can make it adopt the protocol with an empty extension:

```swift
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}
```



Instances of `Hamster` can now be used wherever `TextRepresentable` is the required type:

#memo()[
Types don't automatically adopt a protocol just by satisfying its requirements.
They must always explicitly declare their adoption of the protocol.
]
```swift
let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)
// Prints "A hamster named Simon".
```

== Adopting a Protocol Using a Synthesized Implementation

Swift can automatically provide the protocol conformance
for `Equatable`, `Hashable`, and `Comparable`
in many simple cases.
Using this synthesized implementation
means you don't have to write repetitive boilerplate code
to implement the protocol requirements yourself.



Swift provides a synthesized implementation of `Equatable`
for the following kinds of custom types:

- Structures that have only stored properties that conform to the `Equatable` protocol
- Enumerations that have only associated types that conform to the `Equatable` protocol
- Enumerations that have no associated types

To receive a synthesized implementation of `==`,
declare conformance to `Equatable`
in the file that contains the original declaration,
without implementing an `==` operator yourself.
The `Equatable` protocol provides a default implementation of `!=`.

The example below defines a `Vector3D` structure
for a three-dimensional position vector `(x, y, z)`,
similar to the `Vector2D` structure.
Because the `x`, `y`, and `z` properties are all of an `Equatable` type,
`Vector3D` receives synthesized implementations
of the equivalence operators.

```swift
struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}

let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
if twoThreeFour == anotherTwoThreeFour {
    print("These two vectors are also equivalent.")
}
// Prints "These two vectors are also equivalent."
```





Swift provides a synthesized implementation of `Hashable`
for the following kinds of custom types:

- Structures that have only stored properties that conform to the `Hashable` protocol
- Enumerations that have only associated types that conform to the `Hashable` protocol
- Enumerations that have no associated types

To receive a synthesized implementation of `hash(into:)`,
declare conformance to `Hashable`
in the file that contains the original declaration,
without implementing a `hash(into:)` method yourself.

Swift provides a synthesized implementation of `Comparable`
for enumerations that don't have a raw value.
If the enumeration has associated types,
they must all conform to the `Comparable` protocol.
To receive a synthesized implementation of `<`,
declare conformance to `Comparable`
in the file that contains the original enumeration declaration,
without implementing a `<` operator yourself.
The `Comparable` protocol's default implementation
of `<=`, `>`, and `>=` provides the remaining comparison operators.

The example below defines a `SkillLevel` enumeration
with cases for beginners, intermediates, and experts.
Experts are additionally ranked by the number of stars they have.

```swift
enum SkillLevel: Comparable {
    case beginner
    case intermediate
    case expert(stars: Int)
}
var levels = [SkillLevel.intermediate, SkillLevel.beginner,
              SkillLevel.expert(stars: 5), SkillLevel.expert(stars: 3)]
for level in levels.sorted() {
    print(level)
}
// Prints "beginner".
// Prints "intermediate".
// Prints "expert(stars: 3)".
// Prints "expert(stars: 5)".
```







== Implicit Conformance to a Protocol

Some protocols are so common that you would write them
almost every time you declare a new type.
For the following protocols,
Swift automatically infers the conformance
when you define a type that implements the protocol's requirements,
so you don't have to write them yourself:

- `Copyable`
- `Sendable`
- `BitwiseCopyable`



You can still write the conformance explicitly,
but it doesn't change how your code behaves.
To suppress an implicit conformance,
write a tilde (`~`) before the protocol name in the conformance list:

```swift
struct FileDescriptor: ~Sendable {
    let rawValue: Int
}
```



The code above shows part of a wrapper around POSIX file descriptors.
The `FileDescriptor` structure
satisfies all of the requirements of the `Sendable` protocol,
which normally makes it sendable.
However,
writing `~Sendable` suppresses this implicit conformance.
Even though file descriptors use integers
to identify and interact with open files,
and integer values are sendable,
making it nonsendable can help avoid certain kinds of bugs.

Another way to suppress implicit conformance
is with an extension that you mark as unavailable:

```swift
@available(*, unavailable)
extension FileDescriptor: Sendable { }
```



When you write `~Sendable` in one place in your code,
as in the previous example,
code elsewhere in your program can still
extend the `FileDescriptor` type to add `Sendable` conformance.
In contrast,
the unavailable extension in this example
suppresses the implicit conformance to `Sendable`
and also prevents any extensions elsewhere in your code
from adding `Sendable` conformance to the type.

#memo()[

In addition to the protocols discussed above,
distributed actors implicitly conform to the `Codable` protocol.
]



== Collections of Protocol Types

A protocol can be used as the type to be stored in
a collection such as an array or a dictionary,
as mentioned in Protocols\#Protocols-as-Types.
This example creates an array of `TextRepresentable` things:

```swift
let things: [TextRepresentable] = [game, d12, simonTheHamster]
```



It's now possible to iterate over the items in the array,
and print each item's textual description:

```swift
for thing in things {
    print(thing.textualDescription)
}
// A game of Snakes and Ladders with 25 squares
// A 12-sided dice
// A hamster named Simon
```



Note that the `thing` constant is of type `TextRepresentable`.
It's not of type `Dice`, or `DiceGame`, or `Hamster`,
even if the actual instance behind the scenes is of one of those types.
Nonetheless, because it's of type `TextRepresentable`,
and anything that's `TextRepresentable` is known to have a `textualDescription` property,
it's safe to access `thing.textualDescription` each time through the loop.

== Protocol Inheritance

A protocol can _inherit_ one or more other protocols
and can add further requirements on top of the requirements it inherits.
The syntax for protocol inheritance is similar to the syntax for class inheritance,
but with the option to list multiple inherited protocols, separated by commas:

```swift
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // protocol definition goes here
}
```



Here's an example of a protocol that inherits
the `TextRepresentable` protocol from above:

```swift
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}
```



This example defines a new protocol, `PrettyTextRepresentable`,
which inherits from `TextRepresentable`.
Anything that adopts `PrettyTextRepresentable` must satisfy all of the requirements
enforced by `TextRepresentable`,
_plus_ the additional requirements enforced by `PrettyTextRepresentable`.
In this example, `PrettyTextRepresentable` adds a single requirement
to provide a gettable property called `prettyTextualDescription` that returns a `String`.

The `SnakesAndLadders` class can be extended to adopt and conform to `PrettyTextRepresentable`:

```swift
extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}
```



This extension states that it adopts the `PrettyTextRepresentable` protocol
and provides an implementation of the `prettyTextualDescription` property
for the `SnakesAndLadders` type.
Anything that's `PrettyTextRepresentable` must also be `TextRepresentable`,
and so the implementation of `prettyTextualDescription` starts
by accessing the `textualDescription` property
from the `TextRepresentable` protocol to begin an output string.
It appends a colon and a line break,
and uses this as the start of its pretty text representation.
It then iterates through the array of board squares,
and appends a geometric shape to represent the contents of each square:

- If the square's value is greater than `0`, it's the base of a ladder,
  and is represented by `▲`.
- If the square's value is less than `0`, it's the head of a snake,
  and is represented by `▼`.
- Otherwise, the square's value is `0`, and it's a “free” square,
  represented by `○`.

The `prettyTextualDescription` property can now be used to print a pretty text description
of any `SnakesAndLadders` instance:

```swift
print(game.prettyTextualDescription)
// A game of Snakes and Ladders with 25 squares:
// ○ ○ ▲ ○ ○ ▲ ○ ○ ▲ ▲ ○ ○ ○ ▼ ○ ○ ○ ○ ▼ ○ ○ ▼ ○ ▼ ○
```



== Class-Only Protocols

You can limit protocol adoption to class types (and not structures or enumerations)
by adding the `AnyObject` protocol to a protocol's inheritance list.

```swift
protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
    // class-only protocol definition goes here
}
```



In the example above, `SomeClassOnlyProtocol` can only be adopted by class types.
It's a compile-time error to write a structure or enumeration definition
that tries to adopt `SomeClassOnlyProtocol`.

#memo()[
Use a class-only protocol when the behavior defined by that protocol's requirements
assumes or requires that a conforming type has
reference semantics rather than value semantics.
For more about reference and value semantics,
see ClassesAndStructures\#Structures-and-Enumerations-Are-Value-Types
and ClassesAndStructures\#Classes-Are-Reference-Types.
]





== Protocol Composition

It can be useful to require a type to conform to multiple protocols at the same time.
You can combine multiple protocols into a single requirement
with a _protocol composition_.
Protocol compositions behave as if you
defined a temporary local protocol that has the combined requirements
of all protocols in the composition.
Protocol compositions don't define any new protocol types.

Protocol compositions have the form `SomeProtocol & AnotherProtocol`.
You can list as many protocols as you need,
separating them with ampersands (`&`).
In addition to its list of protocols,
a protocol composition can also contain one class type,
which you can use to specify a required superclass.

Here's an example that combines two protocols called `Named` and `Aged`
into a single protocol composition requirement on a function parameter:

```swift
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)
// Prints "Happy birthday, Malcolm, you're 21!"
```



In this example,
the `Named` protocol
has a single requirement for a gettable `String` property called `name`.
The `Aged` protocol
has a single requirement for a gettable `Int` property called `age`.
Both protocols are adopted by a structure called `Person`.

The example also defines a `wishHappyBirthday(to:)` function.
The type of the `celebrator` parameter is `Named & Aged`,
which means “any type that conforms to both the `Named` and `Aged` protocols.”
It doesn't matter which specific type is passed to the function,
as long as it conforms to both of the required protocols.

The example then creates a new `Person` instance called `birthdayPerson`
and passes this new instance to the `wishHappyBirthday(to:)` function.
Because `Person` conforms to both protocols, this call is valid,
and the `wishHappyBirthday(to:)` function can print its birthday greeting.

Here's an example that combines
the `Named` protocol from the previous example
with a `Location` class:

```swift
class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}
func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)
// Prints "Hello, Seattle!"
```



The `beginConcert(in:)` function takes
a parameter of type `Location & Named`,
which means "any type that's a subclass of `Location`
and that conforms to the `Named` protocol."
In this case, `City` satisfies both requirements.

Passing `birthdayPerson` to the `beginConcert(in:)` function
is invalid because `Person` isn't a subclass of `Location`.
Likewise,
if you made a subclass of `Location`
that didn't conform to the `Named` protocol,
calling `beginConcert(in:)` with an instance of that type
is also invalid.

== Checking for Protocol Conformance

You can use the `is` and `as` operators described in TypeCasting
to check for protocol conformance, and to cast to a specific protocol.
Checking for and casting to a protocol
follows exactly the same syntax as checking for and casting to a type:

- The `is` operator returns `true` if an instance conforms to a protocol
  and returns `false` if it doesn't.
- The `as?` version of the downcast operator returns
  an optional value of the protocol's type,
  and this value is `nil` if the instance doesn't conform to that protocol.
- The `as!` version of the downcast operator forces the downcast to the protocol type
  and triggers a runtime error if the downcast doesn't succeed.

This example defines a protocol called `HasArea`,
with a single property requirement of a gettable `Double` property called `area`:

```swift
protocol HasArea {
    var area: Double { get }
}
```



Here are two classes, `Circle` and `Country`,
both of which conform to the `HasArea` protocol:

```swift
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}
```



The `Circle` class implements the `area` property requirement
as a computed property, based on a stored `radius` property.
The `Country` class implements the `area` requirement directly as a stored property.
Both classes correctly conform to the `HasArea` protocol.

Here's a class called `Animal`, which doesn't conform to the `HasArea` protocol:

```swift
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}
```



The `Circle`, `Country` and `Animal` classes don't have a shared base class.
Nonetheless, they're all classes, and so instances of all three types
can be used to initialize an array that stores values of type `AnyObject`:

```swift
let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]
```



The `objects` array is initialized with an array literal containing
a `Circle` instance with a radius of 2 units;
a `Country` instance initialized with
the surface area of the United Kingdom in square kilometers;
and an `Animal` instance with four legs.

The `objects` array can now be iterated,
and each object in the array can be checked to see if
it conforms to the `HasArea` protocol:

```swift
for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}
// Area is 12.5663708
// Area is 243610.0
// Something that doesn't have an area
```



Whenever an object in the array conforms to the `HasArea` protocol,
the optional value returned by the `as?` operator is unwrapped with optional binding
into a constant called `objectWithArea`.
The `objectWithArea` constant is known to be of type `HasArea`,
and so its `area` property can be accessed and printed in a type-safe way.

Note that the underlying objects aren't changed by the casting process.
They continue to be a `Circle`, a `Country` and an `Animal`.
However, at the point that they're stored in the `objectWithArea` constant,
they're only known to be of type `HasArea`,
and so only their `area` property can be accessed.





== Optional Protocol Requirements





You can define _optional requirements_ for protocols.
These requirements don't have to be implemented by types that conform to the protocol.
Optional requirements are prefixed by the `optional` modifier
as part of the protocol's definition.
Optional requirements are available so that you can write code
that interoperates with Objective-C.
Both the protocol and the optional requirement
must be marked with the `@objc` attribute.
Note that `@objc` protocols can be adopted only by classes,
not by structures or enumerations.

When you use a method or property in an optional requirement,
its type automatically becomes an optional.
For example,
a method of type `(Int) -> String` becomes `((Int) -> String)?`.
Note that the entire function type
is wrapped in the optional,
not the method's return value.

An optional protocol requirement can be called with optional chaining,
to account for the possibility that the requirement was not implemented
by a type that conforms to the protocol.
You check for an implementation of an optional method
by writing a question mark after the name of the method when it's called,
such as `someOptionalMethod?(someArgument)`.
For information on optional chaining, see OptionalChaining.

The following example defines an integer-counting class called `Counter`,
which uses an external data source to provide its increment amount.
This data source is defined by the `CounterDataSource` protocol,
which has two optional requirements:

```swift
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}
```



The `CounterDataSource` protocol defines
an optional method requirement called `increment(forCount:)`
and an optional property requirement called `fixedIncrement`.
These requirements define two different ways for data sources to provide
an appropriate increment amount for a `Counter` instance.

#memo()[
Strictly speaking, you can write a custom class
that conforms to `CounterDataSource` without implementing
_either_ protocol requirement.
They're both optional, after all.
Although technically allowed, this wouldn't make for a very good data source.
]

The `Counter` class, defined below,
has an optional `dataSource` property of type `CounterDataSource?`:

```swift
class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}
```



The `Counter` class stores its current value in a variable property called `count`.
The `Counter` class also defines a method called `increment`,
which increments the `count` property every time the method is called.

The `increment()` method first tries to retrieve an increment amount
by looking for an implementation of the `increment(forCount:)` method on its data source.
The `increment()` method uses optional chaining to try to call `increment(forCount:)`,
and passes the current `count` value as the method's single argument.

Note that _two_ levels of optional chaining are at play here.
First, it's possible that `dataSource` may be `nil`,
and so `dataSource` has a question mark after its name to indicate that
`increment(forCount:)` should be called only if `dataSource` isn't `nil`.
Second, even if `dataSource` _does_ exist,
there's no guarantee that it implements `increment(forCount:)`,
because it's an optional requirement.
Here, the possibility that `increment(forCount:)` might not be implemented
is also handled by optional chaining.
The call to `increment(forCount:)` happens
only if `increment(forCount:)` exists ---
that is, if it isn't `nil`.
This is why `increment(forCount:)` is also written with a question mark after its name.

Because the call to `increment(forCount:)` can fail for either of these two reasons,
the call returns an _optional_ `Int` value.
This is true even though `increment(forCount:)` is defined as returning
a non-optional `Int` value in the definition of `CounterDataSource`.
Even though there are two optional chaining operations,
one after another,
the result is still wrapped in a single optional.
For more information about using multiple optional chaining operations,
see OptionalChaining\#Linking-Multiple-Levels-of-Chaining.

After calling `increment(forCount:)`, the optional `Int` that it returns
is unwrapped into a constant called `amount`, using optional binding.
If the optional `Int` does contain a value ---
that is, if the delegate and method both exist,
and the method returned a value ---
the unwrapped `amount` is added onto the stored `count` property,
and incrementation is complete.

If it's _not_ possible to retrieve a value from the `increment(forCount:)` method ---
either because `dataSource` is nil,
or because the data source doesn't implement `increment(forCount:)` ---
then the `increment()` method tries to retrieve a value
from the data source's `fixedIncrement` property instead.
The `fixedIncrement` property is also an optional requirement,
so its value is an optional `Int` value,
even though `fixedIncrement` is defined as a non-optional `Int` property
as part of the `CounterDataSource` protocol definition.

Here's a simple `CounterDataSource` implementation where the data source
returns a constant value of `3` every time it's queried.
It does this by implementing the optional `fixedIncrement` property requirement:

```swift
class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}
```



You can use an instance of `ThreeSource` as the data source for a new `Counter` instance:

```swift
var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}
// 3
// 6
// 9
// 12
```



The code above creates a new `Counter` instance;
sets its data source to be a new `ThreeSource` instance;
and calls the counter's `increment()` method four times.
As expected, the counter's `count` property increases by three
each time `increment()` is called.

Here's a more complex data source called `TowardsZeroSource`,
which makes a `Counter` instance count up or down towards zero
from its current `count` value:

```swift
class TowardsZeroSource: NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}
```



The `TowardsZeroSource` class implements
the optional `increment(forCount:)` method from the `CounterDataSource` protocol
and uses the `count` argument value to work out which direction to count in.
If `count` is already zero, the method returns `0`
to indicate that no further counting should take place.

You can use an instance of `TowardsZeroSource` with the existing `Counter` instance
to count from `-4` to zero.
Once the counter reaches zero, no more counting takes place:

```swift
counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}
// -3
// -2
// -1
// 0
// 0
```



== Protocol Extensions

Protocols can be extended to provide method,
initializer, subscript, and computed property implementations
to conforming types.
This allows you to define behavior on protocols themselves,
rather than in each type's individual conformance or in a global function.

For example, the `RandomNumberGenerator` protocol can be extended
to provide a `randomBool()` method,
which uses the result of the required `random()` method
to return a random `Bool` value:

```swift
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}
```



By creating an extension on the protocol,
all conforming types automatically gain this method implementation
without any additional modification.

```swift
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// Prints "Here's a random number: 0.3746499199817101".
print("And here's a random Boolean: \(generator.randomBool())")
// Prints "And here's a random Boolean: true".
```





Protocol extensions can add implementations to conforming types
but can't make a protocol extend or inherit from another protocol.
Protocol inheritance is always specified in the protocol declaration itself.

=== Providing Default Implementations

You can use protocol extensions to provide a default implementation
to any method or computed property requirement of that protocol.
If a conforming type provides its own implementation of a required method or property,
that implementation will be used instead of the one provided by the extension.

#memo()[
Protocol requirements with default implementations provided by extensions
are distinct from optional protocol requirements.
Although conforming types don't have to provide their own implementation of either,
requirements with default implementations can be called without optional chaining.
]

For example, the `PrettyTextRepresentable` protocol,
which inherits the `TextRepresentable` protocol
can provide a default implementation of its required `prettyTextualDescription` property
to simply return the result of accessing the `textualDescription` property:

```swift
extension PrettyTextRepresentable  {
    var prettyTextualDescription: String {
        return textualDescription
    }
}
```















=== Adding Constraints to Protocol Extensions

When you define a protocol extension,
you can specify constraints that conforming types
must satisfy before the methods and properties of the extension are available.
You write these constraints after the name of the protocol you're extending
by writing a generic `where` clause.
For more about generic `where` clauses, see Generics\#Generic-Where-Clauses.

For example,
you can define an extension to the `Collection` protocol
that applies to any collection whose elements conform
to the `Equatable` protocol.
By constraining a collection's elements to the `Equatable` protocol,
a part of the Swift standard library,
you can use the `==` and `!=` operators to check for equality and inequality between two elements.

```swift
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}
```



The `allEqual()` method returns `true`
only if all the elements in the collection are equal.

Consider two arrays of integers,
one where all the elements are the same,
and one where they aren't:

```swift
let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]
```



Because arrays conform to `Collection`
and integers conform to `Equatable`,
`equalNumbers` and `differentNumbers` can use the `allEqual()` method:

#memo()[
If a conforming type satisfies the requirements for multiple constrained extensions
that provide implementations for the same method or property,
Swift uses the implementation corresponding to the most specialized constraints.
]
```swift
print(equalNumbers.allEqual())
// Prints "true".
print(differentNumbers.allEqual())
// Prints "false".
```








