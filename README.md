# Swift When - supporting switch expressions in Swift!

## What is it?

Basically, it allows you to (kinda) use switch statement as an expression - compare a value against a bunch of cases and return a single value based on the which case passes.

This functionality exists in most popular languages as it leads to more elegant and concise code (e.g, [C#](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/switch-expression), [Java](https://docs.oracle.com/en/java/javase/13/language/switch-expressions.html),  [Kotlin](https://kotlinlang.org/docs/control-flow.html#when-expression)). Consider this example:

```swift
public enum Colors: WhenCompliant {
  case red, blue, green
  
  var hexString: String {
    when(self) { // isn't this nice?
      Colors.red => "#FF0000"
      Colors.green => "#00F000"
      Colors.blue => "#0000FF"
    }!
  }
}
```

## OK, but why?

Because I wrote something like this way too many times:

```swift
public enum Colors: WhenCompliant {
  case red, blue, green
  
  var hexString: String {
    switch self { // :(
      case Colors.red:
        return "#FF0000"
      case Colors.green:
        return "#00F000"
      case Colors.blue:
        return "#0000FF"
    }
  }
}
```

Writing out a full switch to transform a single enum value into something else, alongside all the cases, colons and explicit returns is unnecessarily verbose and ceremonial.

The same is true for a bunch of `if-else if-...-else` that all return the same value:

```swift
func describeNumber(_ n: Int) -> String {
  if n > 0 {
    return "positive"
  } else if n < 0 {
    return "negative"
  } else {
    return "zero"
  }
}
```

This package aims to solve those issues.

## What it can do

### Use with enums

To use an **enum** with `when`, it needs to be `WhenCompliant`, which implies being `Hashable` and `CaseIterable`:

```swift
enum Colors: WhenCompliant {
  case red, blue, green
}
```

After that, things get really simple:

```swift
func describeColor(_ color: Colors) {
  let description = when(color) {
    Colors.red => "red"
    Colors.blue => "blue"
    Colors.green => "green"
  }
  print(description)
}
```

When called, `when` checks if **all enum cases are taken care of**. If not, a runtime error is thrown.

Alternatively, you can specify the **default clause**:

```swift
func describeColor(_ color: Colors) {
  let description = when(color) {
    Colors.red => "red"
    Colors.blue => "blue"
    "other" // the default clause
  }
  print(description)
}
```

If multiple cases should map to the same result, wrap them in an array:

```swift
func describeColor(_ color: Colors) {
  let description = when(color) {
    [Colors.red, Colors.blue] => "redOrBlue"
    Colors.green => "green"
  }
  print(description)
}
```

### Use with boolean expressions

Alternatively, when can be used as a generic shorthand for a bunch of if-else if-...-else statements that all return the same value. Check out this example:

```swift
func describeNumber(_ n: Int) -> String {
  when {
    (n > 0) => "positive"
    (n < 0) => "negative"
    "zero" // default clause
  }!
}
```

## What it can't do

 * `when` can't work with enums that have associated values. Consequently, it also can't unwrap associated values (i.e, no `case let`).
 * `switch` offers compile-time guarantee that all cases are covered. `when` does that at runtime.

## Installation

This component is distrubuted as a **Swift package**. Just add this URL to your package list:

```text
https://github.com/globulus/swift-when
```

## Changelog

* 1.0.0 - Initial release.
