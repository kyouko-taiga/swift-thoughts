# Control Flow

Swift uses `if`, `switch` or `guard` (which we'll discuss in another chapter) to make conditional statements, and `for-in`, `while` or `repeat-while` to make loops.
Parentheses around the conditions are optional (and shouldn't be used unless they make the code clearer).

## `if` statements

An `if` statement allows to check for a condition:

```swift
let studentMark = 4.7

if studentMark >= 4.0 {
  print("the student passed the exam")
} else {
  print("the student failed the exam")
}
```

> Unlike in most languages of the C-family, Swift conditions **must** be a Boolean expression (i.e. of type `Bool`).
> As a result, `if studentMark { ... }` wouldn't be a valid expression in the above example, and the compiler would complain about it.

By combining an `if` and `let` together, one can also check whether an optional type is associated with a value, and assign that value to a new variable if it is.

```swift
let studentMark: Double? = 4.7

if let mark = studentMark {
  print("the student got the mark \(mark)")
} else {
  print("the student didn't attend the exam")
}
```

Note that the above example is equivalent, but arguably clearer, than the following:

```swift
if studentMark != nil {
 print("the student got the mark \(studentMark!)")
} else {
 print("the student didn't attend the exam")
}
```

Another way to handle optional rvalues is use the infix operator `??` to provide a default value in case it is equal to `nil`:

```swift
let mark = studentMark ?? 0.0
```

### Ternary Operator `_?_:_`

The ternary operator is a syntactic sugar for that kind of code:

```swift
let x = 11
let y: Int

if x > 10 {
  y = x / 2
} else {
  y = x * 2
}
```

With the ternary operator, the above program can be rewritten as the following:

```swift
let x = 11
let y = x > 10 ? x / 2 : x * 2
```

## `switch` statements

A `switch` statement allows to check for several *cases*.

```swift
let studentMark = 0.0

switch studentMark {
case 0.0:
  print("the student didn't attend the exam")
case let x where x < 4.0:
  print("the student failed the exam")
case let x where x >= 4.0:
  print("the student passed the exam")
default:
  break
}

// Prints "the student didn't attend the exam"
```

If multiple the condition is true for multiple cases, the first (from top to bottom) one wins, as we can see in the above example.
A `switch` statement **must** cover all possible cases.
Hence, it is often given a `default` clause which handles the cases where no other condition could be satisfied.

Notice how `let` can be used to match a pattern.
This is a very powerful feature that isn't limited to comparison between numbers:

```swift
let studentName = "Paulo Sérgio Costa de Oliveira"

switch studentName {
case let x where x.characters.count > 20:
  print("that's a long name")
case let x where x.characters.count < 10:
  print("that's a short name")
default:
  break
}
```

## `for-in`, `while` and `repeat-while` loops

A `for-in` loop iterates over a sequence of elements:

```swift
for i in 0 ... 2 {
  print(i)
}

// Prints "0"
// Prints "1"
// Prints "2"
```

> Notice the `0 ... 2` in the above example.
> It creates a *closed range* from 0 to 2 included.
> Swift also has another range operator, `..<`, which creates half-open ranges.
> That is `0 ..< 2` creates a range from 0 to 2 but where 2 isn't included.

The `for-in` loop can iterate over anything that is a sequence.
We'll talk about that in more details later.
For now, let's just illustrate that with another example of sequence:

```swift
for character in "こんにちは".characters {
    print(character)
}

// Prints "こ"
// Prints "ん"
// Prints "に"
// Prints "ち"
// Prints "は"
```

A `while` loop repeats a block of code as long as its condition holds:

```swift
var n = 2
while n < 100 {
  n = n * 2
}
print(n)
// Prints "128"
```

A `repeat-while` loop words similarly, but checks the condition *after* the block is executed, rather than before

```swift
var n = 2
repeat {
  n = n * 2
} while n < 100
print(n)
// Prints "128"
```

The keyword `continue` skips the remainder of the code in a loop.
In the case of a `for-in` loop, the program will continue for the next value of the sequence.
For the case of `while` and `repeat-while` loops, the condition will be re-evaluated:

```swift
var n = 0
while n < 6 {
    n = n + 1
    if n > 3 {
        continue
    }
    print(n)
}
// Prints "1"
// Prints "2"
// Prints "3"
```

The keyword `break` ends the loop's execution immediately and transfers the control to the next statement.

```swift
var n = 0
for i in 0 ... 10 {
  if i > 5 {
    break
  }
  n = i
}
print(n)
// Prints "5"
```

The `continue` and `break` statements respectively skip and end the loop within which they are defined.
When nesting loops, it is sometimes desirable to perform those operation on an outer loop.
In order to do that, it is possible to label the loops, so that `continue` and `break` can specify on which loop they should be applied:

```swift
outer: for x in 0 ... 3 {
    print("outer")
    inner: for y in 0 ... 3 {
        print("inner")
        if y < 2 {
            continue inner
        }

        if y > x {
            break outer
        }
    }
}
// Prints "outer"
// Prints "inner"
// Prints "inner"
// Prints "inner"
```

In the above example, the `continue` statement skips the remainder of the inner loop when `y` is smaller than 2.
As soon as `y` gets to 2, the second `if` statement is checked.
Since at `x` is equal to 0 at that particular moment, the `break` statement ends the outer loop and transfer the control to the remainder of the program.

## `guard` statements

A `guard` statement is similar to an `if` statement, but should be preferred in situations when some condition should hold for the program flow to continue:

```swift
let studentName = "Takeshi Satou"
let studentMark: Double? = 4.7

switch studentName {
case "Takeshi Satou":
  guard let mark = studentMark else {
    print("Takeshi Satou didn't attend the exam")
    break
  }
  print("Takeshi Satou got the mark \(studentMark)")

default:
  break
}
```

> Notice the use of the `break` keyword in the `else` clause of the guard.
> This is because `guard` should always transfer control if the condition doesn't hold, using `break`, `continue` or other kind of statements we'll see later.

A `guard` statement can always be replaced with an `if` statement.
The choice between the two depends solely on the programmer and is mostly a matter of preference.
In some situations, one might produce a code clearer than the other.

## Exercise

Write a program that for all natural numbers between 1 and 100 (included) prints the number followed by:

* `"div2"` if the number is divisible by 2, with n the number;
* `"div3"` if the number is divisible by 3;
* `"prime"` if the number is prime.

> Remember that `n % m == 0` is true if `n` is divisible by `m`.

Write one version using `if` statements and another using `switch` statements.
