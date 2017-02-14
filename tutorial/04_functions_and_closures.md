# Functions and Closures

Functions (and closures) are blocks of organized and (hopefully) reusable code that is used to perform a single or group of related actions.
As a program grows in complexity, they often become (and should be) inevitable.

Actually, we've already used some functions so far, like `print(:_)`, `type(of:)` or `Array.insert(_:at:)`.

> Disclaimer: Swift is **not** a functional language.
> However, it supports this style of programming very well, as its functions are first-class citizen.

## Function Signatures

Functions are declared with the keyword `func`:

```swift
func minInt(lhs: Int, rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}
```

Like in mathematics, a function has a signature (i.e. a domain and a codomain).
In the above example, the signature of the function is `Int, Int -> Int`, meaning that it takes two `Int` parameters and returns one `Int` value.

When referring to the signature of Swift functions in comments and documentation, the convention is to use its name, followed by the list of parameters separated by `:`.
For instance, we would refer to the signature of the above function with `minInt(lhs:rhs:)`.
This convention is borrowed from Objective-C and can be observed through all official documentation.

> Note that this example just serves to illustrate the definition of functions.
> Swift already has a built-in `min(_:_:)` function which should always be preferred.

A function can be called by using its name, followed by the arguments to pass into its parameters:

```swift
print(minInt(lhs: 1, rhs: 2))
// Prints "1"
```

Notice that we had to label its arguments.
By default, functions use their parameter names as labels for their arguments.
It can prove very useful to distinguish between overloaded functions (see below), or when the parameters are not completely obvious.
For instance, the character collection of a `String` has a method `split(whereSeparator:)` whose result is quite obvious, thanks to its labeled parameter.

It is possible to specify custom labels for the function parameters.
Notice that however, the parameters keep their respective name *inside* the function body:

```swift
func minInt(between lhs: Int, and rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}

print(minInt(between: 1, and: 2))
// Prints "1"
```

Finally, when the name of the function is clear enough, it is possible to specify that the labels aren't required:

```swift
func minInt(_ lhs: Int, _ rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}

print(minInt(1, 2))
// Prints "1"
```

Functions can return multiple values by returning a tuple.
For instance, this function takes 3 parameters and returns the minimum and maximum values:

```swift
func minmaxInt(_ first: Int, _ second: Int, _ third: Int) -> (minimum: Int, maximum: Int) {
    return (minInt(minInt(first, second), third), maxInt(maxInt(first, second), third))
}

print(minmaxInt(1, 2, 3))
// Prints "(1, 3)"
```

A functions may also not return anything.
Maybe because it just prints some value on the console, or it has some other side effect like setting a value in an external database.
In those case, the return type of the function is `()` (read as "void"), but is not required to be specified explicitly:

```swift
func printWelcomeMessage(to name: String) {
  print("Welcome \(name)!")
}

printWelcomeMessage(to: "Maria")
// Prints  "Welcome Maria!"
print(type(of: printWelcomeMessage))
// Prints "(String) -> ()"
```

If a function returns a value, Swift expects that this value is used, otherwise the compiler will emit a warning.
There are two ways to silent this warning:

* explicitly mark the result unused by prefixing the function call with `_ =`; or

```swift
_ = minInt(1, 2)
```

* decorate the function with `@discardableResult`.

```swift
@discardableResult
func minInt(_ lhs: Int, _ rhs: Int) -> Int {
  return lhs < rhs ? lhs : rhs
}

minInt(1, 2)
```

### Inout Parameters

In the body of a function, the arguments are declared as `let` constants.
That means a function can't modify the value of its argument:

```swift
func swapString(_ name: String, with anotherName: String) {
  let temporary = name
  name = anotherName
  // Error: Cannot assign to value: 'name' is a 'let' constant
  anotherName = temporary
  // Error: Cannot assign to value: 'anotherName' is a 'let' constant
}
```

If that might seems a bit unnatural, it is a very practice in languages whose function can't return multiple values.
Although often discouraged, it is possible to define mutable parameters in Swift, marking them as *inout*:

```swift
func swapString(_ name: inout String, _ anotherName: inout String) {
  let temporary = name
  name = anotherName
  anotherName = temporary
}
```

> ❔
>
> What is the signature of `swapString(_:_:)`?

To provide arguments for an inout parameter, one should prefix the variable with `&`:

```swift
var firstPerson = "Maria"
var secondPerson = "Alicia"

swapString(&firstPerson, &secondPerson)
print(firstPerson)
// Prints "Alicia"
print(secondPerson)
// Prints "Maria"
```

> Note that this example just serves to illustrate the definition of inout parameters.
> Swift already has a built-in `swap(_:_:)` function which should always be preferred.

Note that because the parameters are marked inout, the arguments *must* be variables.
It is not possible to call `swapString(_:with:)` with a constant expression.

### Generic Functions

In the above example, `swapString(_:_:)` can only swap `String`, and it is impossible to call it with `Double` values:

```swift
var firstMark = 4.3
var secondMark = 5.9

swapString(&firstMark, &secondMark)
// Error: Cannot convert value of type 'Double' to expected argument type 'String'
```

Of course we could write another function `swapString(_:_:)` that does the same thing for `Double` values, but what about `Int`?
Clearly there should be a better way to do this (Swift ain't C yo), and this is where generics come in play.
Generics allow one to write a function where one or several of its parameter/return types are unknown:

```swift
func swapGeneric<T>(_ value: inout T, _ anotherValue: inout T) {
  let temporary = value
  value = anotherValue
  anotherValue = temporary
}

swapGeneric(&firstMark, &secondMark)
```

In the above example, `T` acts as a placeholder for the type that will be used to specialize the function.
When calling `swapGeneric(&firstMark, &secondMark)`, the compiler infers that `T` should be replaced with `Double` for this particular instruction, and it generates a version of `swapGeneric(_:_:)` typed `(inout Double, inout Double) -> ()`.

## Functions as First-Class Citizen

Functions are first-class citizen, meaning that they can be assigned to variables (or constants) like any other value:

```swift
let f = minmaxInt
print(f(1, 2, 3))
// Prints "(1, 3)"
```

> ❔
>
> What type did Swift infer for the constant `f`?

As they are first-class citizen, functions can also be used as arguments for other functions.
For instance, the following function takes as argument any function whose signature is `(Int, Int) -> Int`, and applies it with constant values:

```swift
func applyBinaryOp(_ f: (Int, Int) -> Int) -> Int {
  return f(6, 8)
}

print(applyBinaryOp(minInt))
// Prints "6"
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

Note that Swift's `+` operator is also a function that takes 2 `Int` and returns 14.
As such, it is possible to use it as an argument of `applyBinaryOp(_:)`.

```swift
print(applyBinaryOp(+))
// Prints 14
```

> Unfortunately, as `+` is also a unary operator (`(Int) -> Int`), the compiler won't understand what `type(of:+)` means, so we can't check the signature of `+` this way.
However, the operator will be unambiguously recognized as an argument of `applyBinaryOp(_:)`, as its parameter is typed more precisely than that of `type(of:)`, which is a bit more tricky.

Some built-in functions of Swift use this ability as well.
For instance, arrays have a function `Array.reduce(_:_:)` which takes an initial value as first argument a function `(Int, Int) -> Int` as second one.
It then recursively applies the function on each element, using the result of the last application as second parameter.
For instance, the following program computes the sum of an array of `Int`:

```swift
let sum = [1, 4, 0, 2].reduce(0, +)
print(sum)
// Prints "7"
```

## Scope of Functions

The scope of a function refers to the variables a function can *see* (and sometimes mutate).
Obviously, this include the arguments of the function as well as the variables defined inside the function, but also all variables defined within the function's context (i.e. the scope it is defined in):

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
// Prints "9"
```

The `outer()` function can see `globalNumber` and `outerNumber`, while the `inner()` function can those 2 variables, and its own `innerNumber`.
Variables from outer scopes are said to by *captured by closure*.

A function can also mutate a variable in an outer scope.
However, this kind of behavior is highly discouraged, as it can produce bugs really hard to track down.

```swift
var globalNumber = 0

func incGlobalNumber(by n: Int) {
    globalNumber = globalNumber + n
}

incGlobalNumber(by: 2)
print(globalNumber)
// Prints "2"
```

When the name of a variable in an outer scope collides with that of another scope, a function always refers to the closest scope the variable is defined in.
This behavior is called *lexically scoped name binding*:

```swift
let name = "Maria"
func printWelcomeMessage(to name: String) {
  print("Welcome \(name)!")
}

printWelcomeMessage(to: "Alicia")
// Prints "Welcome Alicia!"
```

## Closures

A closure can be seen as an anonymous blocks of code that can be passed around in the program.
Like functions, they can capture the constants and variables of the context in which they are defined.
They are defined with the curvy brackets `{}`:

```swift
let block = { someArgument in
  return "(" + someArgument + ")"
}

print(block("Camille"))
// Prints "(Camille)"
```

Thanks to Swift's type inference, the above closure doesn't have to be explicitly typed.
The compiler could infer that `someArgument` should be typed with `String`, because of the expression `"(" + someArgument ")"`.
Similarly, it could infer the return type of the closure.
Depending on what is written in the closure, the type inference engine might not be as lucky:

```swift
let block = { someArgument in
  return someArgument
}
// Error: Unable to infer close type in the current context
```

In the above example, the type inference fails because there's no way to infer the type of `someArgument`.
In that case, the closure should be typed explicitly:

```swift
let block: (String) -> String = { someArgument in
  return someArgument
}
```

Closures are not required to have parameters nor return any value:

```swift
let producer: () -> String = {
  return "Sylvia"
}

let consumer: (String) -> () = { someArgument in
  print(someArgument)
}
```

When the closure is composed of a single line, Swift allows to omit the return statement:

```swift
let identity: (String) -> String = { someArgument in
  someArgument
}
```

It is not required to name the parameters of a closure.
In that case, the arguments can be accessed with `$n`, where `n` is the `n`-th argument.

```swift
let identity: (String) -> String = { $0 }
```

If a closure doesn't use all its arguments, Swift requires that they are explicitly discarded:

```swift
let block: (String) -> String = { _ in "Syliva" }
```

Note however that closure are rarely (unless never) used that way.
Indeed, it is usually clearer to use a function definition.
Instead, closures are used when calling a function that takes another function as argument.
In that case, the signature of the function always types the closure unambiguously.

Recalling the `Array.reduce` function, here is another (yet more complicated) way to compute the sum of an array.

```swift
let sum = [1, 4, 0, 2].reduce(0, { $0 + $1 })
```

A closure is said *trailing* when it is the last parameter of a function.
It that case, swift allows to write it outside the parameters list.
This often makes code much clearer, in particular when the code of the closure is long.
The following example illustrates this feature with the `Array.filter(_:)` function (whose name is self-explanatory).

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

If a closure is passed as a function, but called after the function returns, the reference to the closure might be lost.
This is because behind the scenes Swift automatically destroys objects when they go out of scope (the actual process is a bit more complicated but isn't the point of this chapter).
Hence the closure should outlive the function.
Such closure is said to *escape* a function, and Swift requires it to be explicitly defined:

```swift
func h(_ f: @escaping (Int) -> Int) -> (Int) -> Int {
  return { f($0) }
}

print(h(identity)(2))
// Prints "2"
```

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
There's is much more things to be said about functions and closures, about the semantics of the variable capture, about auto-closures, overloading, variadic parameters, ...

Some topics will be discussed later in this tutorial, some won't.
We invite the reader to consult sections related to [functions](https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/Functions.html#//apple_ref/doc/uid/TP40014097-CH10-ID158) and [closures](https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html#//apple_ref/doc/uid/TP40014097-CH11-ID94) in Apple's language guide for more information and/or examples.
