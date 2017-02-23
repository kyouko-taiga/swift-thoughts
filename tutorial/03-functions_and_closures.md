---
layout: page
title: Functions and Closures
permalink: /tutorial/chapter-3/
---

<span class="prev">
  <a href="{{ site.baseurl }}tutorial" title="Tutorial Index">
    <span class="arrow">←</span> Index
  </a>
</span>
<hr />

[Functions](https://en.wikipedia.org/wiki/Subroutine) are blocks of organized and reusable code that performs a single action, or group of related actions.
As a program grows in complexity, they become mandatory.

This tutorial has already used some functions so far, like `print(:_)`, `type(of:)` or `Array.insert(_:at:)`.

<div class="alert alert-warning">
  Disclaimer for the Haskell lovers: Swift is <b>not</b> a functional language.
  However, it supports this style of programming very well, as its functions are first-class citizen.
</div>

## Function Signatures

Functions are declared with the keyword `func`.
They are declared by a function name, parameter names and types, and a result type.
Each function contains a body that performs the effective computation:

```swift
func minInt(lhs: Int, rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}
```

Like in mathematics, a function has a signature (i.e. a domain and a codomain).
In the above example, the signature of the function is `(Int, Int) -> Int`,
meaning that it takes two `Int` parameters and returns one `Int` value.

When referring to the signature of Swift functions in comments and documentation,
the convention is to use its name, followed by the list of parameters separated by `:`.
For instance, the signature of the above function is written `minInt(lhs:rhs:)` in Swift documentation.
This convention is borrowed from Objective-C and can be observed through all official documentation.

> Note that this example just serves to illustrate the definition of functions.
> Swift already has a built-in `min(_:_:)` function which should always be preferred.

A function can be called by using its name, followed by the arguments to pass into its parameters.
Swift is a language with [named parameters](https://en.wikipedia.org/wiki/Named_parameter).
It means that the parameter names **must** be given when calling the function:

```swift
minInt(lhs: 1, rhs: 2)
// 1
```

Parameter names can prove very useful to distinguish overloaded functions,
for code readability, or when the parameters are not completely obvious.
For instance, the character collection of a `String` has a method `split(whereSeparator:)` whose result is quite obvious,
thanks to its labeled parameter.

It is possible to distinguish between the labels used for calling,
and their name within the function body.
The calling name is put in the first place, and the body name in second:

```swift
func minInt(between lhs: Int, and rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}
minInt(between: 1, and: 2)
// 1
```

When the name of the function is clear enough,
it is possible to specify that the labels are not required in the function call using the `_` special name:

```swift
func minInt(_ lhs: Int, _ rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}
minInt(1, 2)
// 1
```

Functions can return only one value, but this value can be a tuple.
For instance, the `minMaxInt` function takes 3 parameters and returns the minimum and maximum values:

```swift
func minMaxInt(_ first: Int, _ second: Int, _ third: Int) -> (minimum: Int, maximum: Int) {
    return (minimum: min(min(first, second), third), maximum: max(max(first, second), third))
}
minMaxInt(1, 2, 3)
// $R0: (minimum: Int, maximum: Int) = {
//   minimum = 1
//   maximum = 3
// }
```

A functions can also return nothing.
Such functions often have side effects, either on their parameters or on the execution environment,
for instance by printing something or setting a value in an external database.
In this case, the return type of the function is `()` (read as "void").
It is not required to be specified explicitly:

```swift
func greet(_ name: String) {
  print("Welcome \(name)!")
}
greet("Brock")
// Welcome Brock!
```

If a function returns a value, Swift expects this value to be used somewhere,
otherwise the compiler emits a warning.
There are two ways to silent this warning:

* If the result is expected to be used in most cases,
  it is the caller responsibility to discard it.
  The call must explicitly mark the result as unused by assigning it to the special `_ =` variable:

```swift
_ = minInt(1, 2)
```

* If the result is only sometimes used,
  it is the function responsibility to discard it.
  The function must be decorated with `@discardableResult`:

```swift
@discardableResult
func minInt(_ lhs: Int, _ rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}
minInt(1, 2)
```

## Default Arguments and Overloading

Function can have default values for some of their parameters:

```swift
func greet(_ name: String, with message: String = "Welcome") {
  print("\(message) \(name)!")
}
greet("Brock", with: "Hello")
// Hello Brock!
greet("Brock")
// Welcome Brock!
```

Because of the default value on its `message` parameter,
there are two ways to call the `greet(_:with:)` function,
as illustrated in the example.
It is equivalent to writing two versions of this function:

* `greet(_:with:)` with signature `(String, String) -> ()`;
* `greet(_:)` with signature `(String) -> ()`.

It is possible in Swift to create these two functions using [overloading](https://en.wikipedia.org/wiki/Function_overloading).
The same function name (`greet`) can be given to several functions, as long as their signatures differ.
When calling the function name, the compiler chooses the function that matches the given parameters:

```swift
func greet(_ name: String, with message: String = "Welcome") {
  print("\(message) \(name)!")
}
func greet(_ name: String) {
  print("Welcome \(name)!")
}
greet("Brock", with: "Hello")
// Hello Brock!
greet("Brock")
// Welcome Brock!
```

Function overloading is a bad practice to define default arguments,
but is a powerful feature because the signatures can be totally unrelated.
For instance, the following code allows to greet one person, or a group:

```swift
func greet(_ name: String) {
  print("Welcome \(name)!")
}
func greet(_ names: [String]) {
  greet(names.joined(separator: " and "))
}
greet("Brock")
// Welcome Brock!
greet(["Brock", "Misty"])
// "Welcome Brock and Misty!
```

Function overloading and default arguments can be combined together to create even more usable functions.
For instance, there are four possible calls of the `greet` function in the following example:

```swift
func greet(_ name: String, with message: String = "Welcome") {
  print("Welcome \(name)!")
}
func greet(_ names: [String], with message: String = "Welcome") {
  greet(names.joined(separator: " and "), with: message)
}
```

## Inout Parameters

In the body of a function, the arguments are declared as `let` constants.
That means a function can't modify the value of its argument:

```swift
struct Pokemon { /* ... */ }
func swapPokemon(_ x: Pokemon, _ y: Pokemon) {
  let temporary = x
  x = y
  // Error: Cannot assign to value: 'x' is a 'let' constant
  y = temporary
  // Error: Cannot assign to value: 'y' is a 'let' constant
}
```

<!-- If this seems unnatual, welcome to the pure functional programming side.
We have cookies!
However, it is a very practice in languages whose function can't return multiple values.
But swift isn't one of them, and we could write `swapPokemon` as the following: -->

When writing code in functional style, the solution is to return the swapped elements,
instead of modifying the parameters:

```swift
func swapPokemon(_ x: Pokemon, _ y: Pokemon) -> (Pokemon, Pokemon) {
  return (y, x)
}
```

However, sometimes it is needed to update the function parameters.
This behavior should be carefully thought, and only chosen if no other solution is viable.
Hence, although often recommended against,
Swift allows programmers to define mutable parameters by marking them as *inout*:

```swift
func swapPokemon(_ x: inout Pokemon, _ y: inout Pokemon) {
  let temporary = x
  x = y
  y = temporary
}
```

> ❔
>
> What is the signature of `swapPokemon(_:_:)`?

The caller of a function must be aware that the parameters will be modified.
Instead of only adding such information in the documentation, or in the function signature,
Swift requires to explicitly prefix arguments given to `inout` parameters with `&`:

```swift
var x = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
var y = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
swapPokemon(&x, &y)
(x, y)
// (Pokemon(species: (135, "Jolteon"), level: 31), Pokemon(species: (134, "Vaporeon"), level: 58))
```

Note that because the parameters are marked `inout`, the arguments *must* be variables.
It is not possible to call `swapPokemon(_:_:)` with a constant expression.

### Generic Functions

In the above example, `swapPokemon(_:_:)` can only swap arguments of the `Pokemon` type.
It is impossible to call this function with anything else, even if the operations to perform are always the same.

```swift
indirect enum SpeciesType { /* ... */ }
var x = SpeciesType.grass
var y = SpeciesType.dual(primary: .water, secondary: .grass)
swapPokemon(&x, &y)
// Error: Cannot convert value of type 'SpeciesType' to expected argument type 'Pokemon'
```

Of course we could write another function `swapSpeciesType(_:_:)` that does the same thing for `SpeciesType` values.
But we also would have to write the same for  `Species`, or simply `Int` and `String`.
<!-- Clearly there should be a better way to do this (Swift ain't C yo), and this is where generics come in play. -->
[Generics](https://en.wikipedia.org/wiki/Generic_programming) allow programmers to write a function where one or several of its parameter or return types are unknown:

```swift
func swapGeneric<T>(_ x: inout T, _ y: inout T) {
  let temporary = x
  x = y
  y = temporary
}

indirect enum SpeciesType { /* ... */ }
var a = SpeciesType.grass
var b = SpeciesType.dual(primary: .water, secondary: .grass)
swapGeneric(&a, &b)
```

In the above example, `T` acts as a placeholder for the type that will be used to specialize the function.
When calling `swapGeneric(&a, &b)`,
the compiler infers that `T` should be replaced with `SpeciesType` in this function call,
and it generates a version of `swapGeneric(_:_:)` typed `(inout SpeciesType, inout SpeciesType) -> ()`.

> Note that this example just serves to illustrate the definition of `inout` parameters.
> Swift already has a built-in `swap(_:_:)` generic function which should always be preferred.

## Functions as First-Class Citizen

Functions are first-class citizen in Swift, meaning that they can be assigned to variables (or constants),
like any other value:

```swift
let f = minMaxInt
f(1, 2, 3)
// (1, 3)
```

> ❔
>
> What type did Swift infer for the constant `f`?

It is also possible to as for the type of a function using the `type(of:)` function:

```swift
type(of: greet)
// (String) -> ()
```

As they are first-class citizen, functions can be passed as arguments to other functions.
For instance, the following function takes as argument any function whose signature is `(Int, Int) -> Int`,
and applies it to some constant values:

```swift
func applyBinaryOp(_ f: (Int, Int) -> Int) -> Int {
  return f(6, 8)
}
applyBinaryOp(minInt)
// 6
```

> Notice that in the body of `applyBinaryOp(_:)`, `f` is called without any labels.
> In our example, our `minInt(_:_:)` function can be called without any label, so everything goes fine.
> But what if the function had labels?
>
> Actually, because the expected signature simply says "any function that takes 2 `Int` and returns 1",
> Swift "forgets" the labels of the functions when it is passed as argument.
> In fact, function types aren't even allowed to have parameter labels.
>
> Interestingly, this is also the reason why even if all parameters of a function are named,
> Swift doesn't allow it to be called in wrong order, whereas Python would for instance.

Note that Swift's `+` operator is also a function that takes 2 `Int` and returns one `Int`.
It is thus possible to use it as an argument of `applyBinaryOp(_:)`.

```swift
applyBinaryOp(+)
// 14
```

> Unfortunately, as `+` is also a unary operator (`(Int) -> Int`),
> the compiler won't understand what `type(of:+)` means,
> so we can't check the signature of `+` this way.
> However, the operator will be unambiguously recognized as an argument of `applyBinaryOp(_:)`,
> as its parameter is typed more precisely than that of `type(of:)`.

Some built-in functions of Swift make use of first class functions.
For instance, arrays have a function `Array.reduce(_:_:)`,
that takes an initial value as first argument and a function `(Int, Int) -> Int` as second one.
`reduce` recursively applies the function on each element,
using the result of the last application as second parameter.
For instance, the following program computes the sum of an array of `Int`:

```swift
let sum = [1, 2, 3, 4].reduce(0, +)
// 4+(3+(2+(1+0)))
// 10
```

## Scope of Functions

The scope of a function refers to the variables a function can *see* (and sometimes mutate).
Obviously, this include the arguments of the function as well as the variables defined inside the function,
but also all variables defined within the function's context, i.e., the scope it is defined in:

```swift
let globalNumber = 2
func outer() {
  let outerNumber = 3
  func inner() {
    let innerNumber = 4
    print(globalNumber + outerNumber + innerNumber)
  }
  inner()
}
outer()
// 9
```

The `outer()` function can see `globalNumber` and `outerNumber`,
while the `inner()` function can those 2 variables, and its own `innerNumber`.
Variables from outer scopes are said to by *captured by closure*.

A function can also mutate a variable in an outer scope.
However, this kind of behavior is highly discouraged,
as it can produce bugs really hard to track down.

```swift
var globalNumber = 0

func incGlobalNumber(by n: Int) {
    globalNumber = globalNumber + n
}

incGlobalNumber(by: 2)
globalNumber
// 2
```

When the name of a variable in an outer scope collides with that of an inner scope,
a function always refers to the closest variable.
This behavior is called [*lexically scoped name binding*](https://en.wikipedia.org/wiki/Scope_(computer_science)#Lexical_scoping):

```swift
let name = "Bulby"
func printCheeringMessage(to name: String) {
  print("Go \(name)!")
}
printCheeringMessage(to: "Sparky")
// Go Sparky!
```

## Closures

A closure can be seen as an anonymous blocks of code that can be passed around in the program.
Like functions, they capture the constants and variables of the context in which they are defined.
Closures are defined with the curvy brackets `{}`:

```swift
let block = { someArgument in
  return "(" + someArgument + ")"
}
block("Bulby")
// (Bulby)
```

Thanks to Swift's type inference, the above closure does not have to be explicitly typed.
The compiler infers that `someArgument` is of type `String`,
because of the expression `"(" + someArgument ")"`.
Similarly, it infers the return type of the closure because of the `return` statement.
Depending on what is written in the closure,
type inference might not be as lucky:

```swift
let block = { someArgument in
  return someArgument
}
// Error: Unable to infer close type in the current context
```

In the above example,
the type inference fails because there is no way to infer the type of `someArgument`.
In that case, the closure must be typed explicitly:

```swift
let block: (String) -> String = { someArgument in
  return someArgument
}
```

Closures are not required to have parameters nor return any value:

```swift
let producer: () -> String = {
  return "Bulby"
}
let consumer: (String) -> () = { someArgument in
  print(someArgument)
}
```

When the closure is composed of a single line, Swift allows to omit the return statement.
Programmers should use the `return` statement instead of this syntax sugar for consistency with the other parts of the language.

```swift
let identity: (String) -> String = { someArgument in
  someArgument
}
```

It is not required to name the parameters of a closure.
In that case, the arguments can be accessed with `$n`, where `n` is the `n`-th argument,
starting with `$0`:

```swift
let identity: (String) -> String = {
  return $0
}
```

If a closure doesn't use all its arguments, Swift requires that they are explicitly discarded:

```swift
let block: (String) -> String = { _ in
  return "Bulby"
}
```

Note however that closures are rarely assigned to variables,
as it is usually clearer to use a function definition.
Instead, closures are used when calling a function that takes another function as argument.
In that case, the signature of the function always types the closure unambiguously.

Recalling the `Array.reduce` function,
here is another (yet more complicated) way to compute the sum of an array.

```swift
let sum = [1, 2, 3, 4].reduce(0, { $0 + $1 })
```

A closure is said *trailing* when it is the last parameter of a function.
It that case, swift allows to write it outside the parameters list.
This often makes code clearer, in particular when the code of the closure is long.
The following example illustrates this feature with the `Array.filter(_:)` function (whose name is self-explanatory):

```swift
let primes = [3, 4, 5, 6, 7, 8, 9].filter {
  for i in 2 ..< $0 {
    if $0 % i == 0 {
      return false
    }
  }
  return true
}

print(primes)
// Prints "[3, 5, 7]"
```

> This [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar) has an influence on the design of function signatures.
> It the programmer has to define a function that takes several parameters, one of which a function,
> the function parameter should be put at the last position of the parameters list.

It might not seem obvious, but closures are reference types:

```swift
var globalNumber = 0
let incrementer = {
    globalNumber += 1
}

incrementer()
print(globalNumber)
```

In the above example, even if `incrementer` is a constant,
it is still able to mutate the `globalNumber` it captured.
This behavior reminds that of the classes, as we illustrated in Chapter 1.

As for classes, this also means that assigning a closure to different variables (or constants)
will make the variables refer to the exact same closure.

## Functions and Closures as return type

As seen earlier, functions are first-class citizen and can be used as arguments of other functions.
They can also be used as return type:

```swift
func identity(_ x: Int) -> Int {
    return x
}

func g() -> (Int) -> Int {
    return identity
}

print(g()(2))
// Prints "2"
```

This is also true for closure, but there's a catch:

```swift
func h(_ f: (Int) -> Int) -> (Int) -> Int {
  return { f($0) }
  // Error: Closure use of non-escaping parameter 'f' may allow it to escape
}
```

If a closure is passed as a function, but called after the function returns,
the reference to the closure might be lost.
This is because behind the scenes Swift automatically destroys objects when they go out of scope
(the actual process is a bit more complicated but isn't the point of this chapter).
Hence the closure should outlive the function.
Such closure is said to *escape* a function, and Swift requires it to be explicitly defined:

```swift
func h(_ f: @escaping (Int) -> Int) -> (Int) -> Int {
  return { f($0) }
}

print(h(identity)(2))
// Prints "2"
```

What about the variables captured by a closure?
Shouldn't they also *escape* the function?
Well, actually they don't have to, precisely because the closure **captured** them.
In other words, the closure keeps a reference to the objects it captures until it is itself destroyed.
This behavior has some shortcomings that we'll discuss later.

## Error Handling

Sometimes, returning an optional type to denote the success or failure of a function is not enough.
Indeed, it some situations it might be desirable for the caller to know exactly what is the cause the failure,
so that it can take the appropriate action to recover from the error.
Swift handles this kind of errors via a mechanism of exception.

Errors can represented by types that conform to the `Error` protocol.
We'll see in details what *conforming to a protocol* means,
but for the time being, we'll just consider this syntax:

```swift
enum PokemonError: Error {
  case outOfBoundsLevel
  case unknownSpeciesNumber(number: Int)
}
```

The above enumeration groups two custom errors,
respectively representing an invalid Pokemon level, and an unknown species number.
When a program reaches a state that should be considered an error,
it can throw an error type:

```swift
throw PokemonError.outOfBoundsLevel
```

Unlike in some other languages,
Swift doesn't allow errors to propagate implicitly.
As a result, functions that may throw an error should be marked with the keyword `throws`:

```swift
struct Pokemon { /* ... */ }

func incrementingLevel(of pokemon: Pokemon) throws -> Pokemon {
  guard pokemon.level < 100 else {
    throw PokemonError.outOfBoundsLevel
  }

  return Pokemon(species: pokemon.species, level: pokemon.level + 1)
}
```

Incidentally,
pieces of code that may throw an error must explicitly define how possible errors will be handled:

```swift
var rainer = Pokemon(species: (number: 134, name: "Vaporeon"), level: 100)

do {
  try rainer = incrementingLevel(of: rainer)
} catch PokemonError.outOfBoundsLevel {
  print("rainer already reached level 100")
} catch PokemonError.unknownSpeciesNumber(number: let number) {
  print("cannot raise the level of an unknown species: \(number)")
}
// Prints "rainer already reached level 100"
```

> Notice how a `do-catch` block can use pattern matching on the thrown error.

A `do-catch` block doesn't have to catch all possible errors.
Remaining cases will be propagated to the enclosing scope.
However, the latter will have to finish the job,
unless it is a function marked with `throws`.

It is possible to use `try?` to convert a the result of a function marked with `throws` into an optional value.
If the function throws an error upon calling, the error will be handled as a `nil` return value:

```swift
var strongerRainer = try? incrementingLevel(of: rainer)
print(strongerRainer)
// Prints "nil"
```

If a function may throw an error,
but requires some cleanup to be done before it transfers control,
it is possible to mark a piece of code as deferred.
Doing so will ensure that the cleanup code is executed when the scope it is defined in is exited,
either following a `return` statement, or because of a thrown error:

```swift
func readPokemonName(from filename: String) throws {
  let file = open(filename)
  defer {
    close(file)
  }

  // This statement may throw.
  return try readline(from: file)
}

```

> Note the the function `open(_:)`, `close(_:)` and `readling(from:)` doesn't exist.
> Reading a file in Swift involves the Foundation library,
> and a slightly more complicated syntax that would hinder the clarity of that example.

## Exercise

Implement a function `curry(_:)` that accepts a function with 2 parameters and 1 return value, to return a function with exactly 1 parameter and 1 return value, which also is a function with exactly 1 parameter and 1 return value.
Calling this chain of functions, starting with an arbitrary binary operator, followed by 2 arguments, should be equivalent as calling the binary operator directly:

For instance, one could use `curry(_:)` as following, provided everything is typed with `Int`:

```swift
print(curry(*)(5)(8))
// Prints "40"
print(curry(min)(5)(8))
// Prints "5"
print(curry({ $0 > 2 ? $1 : $0 )})(5)(8))
// Prints "8"
```

See Wikipedia for more information about [currying](https://en.wikipedia.org/wiki/Currying).

## There's More

The goal of this chapter is not to be exhaustive, but to give you enough information to get started.
There's is much more things to be said about functions and closures,
about capture semantics, about auto-closures, variadic parameters, ...

Some topics will be discussed later in this tutorial, some won't.
We invite the reader to consult sections related to [functions](https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/Functions.html#//apple_ref/doc/uid/TP40014097-CH10-ID158) and [closures](https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html#//apple_ref/doc/uid/TP40014097-CH11-ID94) in Apple's language guide for more information and/or examples.

Olivier Halligon (who apparently also likes Pokemon),
also posted a very nice [blog post](http://alisoftware.github.io/swift/closures/2016/07/25/closure-capture-1/) about the closures capture semantics.

<nav id="post-nav">
  <span class="prev">
    <a href="{{ site.baseurl }}tutorial/chapter-2" title="Chapter 2">
      <span class="arrow">←</span> Control Flow
    </a>
  </span>
  <span class="next">
      <a href="{{ site.baseurl }}tutorial/chapter-4" title="Chapter 4">
          Properties and Methods <span class="arrow">→</span>
      </a>
  </span>
</nav>
