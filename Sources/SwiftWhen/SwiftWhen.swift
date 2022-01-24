public protocol WhenCompliant: CaseIterable, Equatable { }

public typealias WhenCaseElement<Enum: WhenCompliant, Result> = ([Enum?], Result)

@resultBuilder public struct WhenCase<Enum: WhenCompliant, Result> {
  public static func buildArray(_ components: [[WhenCaseElement<Enum, Result>]]) -> [WhenCaseElement<Enum, Result>] {
      components.reduce([], +)
  }
  
  public static func buildBlock(_ components: WhenCaseElement<Enum, Result>...) -> [WhenCaseElement<Enum, Result>] {
      components
  }
  
  public static func buildEither(first component: [WhenCaseElement<Enum, Result>]) -> [WhenCaseElement<Enum, Result>] {
      component
  }
  
  public static func buildEither(second component: [WhenCaseElement<Enum, Result>]) -> [WhenCaseElement<Enum, Result>] {
      component
  }

  public static func buildExpression(_ result: Result) -> WhenCaseElement<Enum, Result> {
    ([nil], result)
  }

  public static func buildExpression(_ element: WhenCaseElement<Enum, Result>) -> WhenCaseElement<Enum, Result> {
    element
  }
}

precedencegroup WhenElementPrecedence {
    associativity: left
    assignment: false
}

infix operator =>: WhenElementPrecedence

public func => <Enum: WhenCompliant, Result>(lhs: [Enum], rhs: Result) -> WhenCaseElement<Enum, Result> {
  (lhs, rhs)
}

public func => <Enum: WhenCompliant, Result>(lhs: Enum, rhs: Result) -> WhenCaseElement<Enum, Result> {
  ([lhs], rhs)
}

public func when<Enum: WhenCompliant, Result>(_ value: Enum,
                                       @WhenCase<Enum, Result> builder: () -> [WhenCaseElement<Enum, Result>]) -> Result {
  let cases = builder()
  let unhandledCases = Enum.allCases.filter { value in !cases.contains(where: { $0.0.contains(value) }) }
  let elseCause = cases.first(where: { $0.0.contains(nil) })
  if !unhandledCases.isEmpty && elseCause == nil {
    fatalError("When must have an else clause or handle all cases: \(unhandledCases)!")
  }
  for whenCase in cases {
    if whenCase.0.contains(value) {
      return whenCase.1
    }
  }
  return elseCause!.1
}

public typealias WhenElement<Result> = (Bool, Result)

@resultBuilder public struct When<Result> {
  public static func buildArray(_ components: [[WhenElement<Result>]]) -> [WhenElement<Result>] {
      components.reduce([], +)
  }

  public static func buildBlock(_ components: WhenElement<Result>...) -> [WhenElement<Result>] {
      components
  }

  public static func buildEither(first component: [WhenElement<Result>]) -> [WhenElement<Result>] {
      component
  }

  public static func buildEither(second component: [WhenElement<Result>]) -> [WhenElement<Result>] {
      component
  }

  public static func buildExpression(_ route: Result) -> WhenElement<Result> {
    (true, route)
  }

  public static func buildExpression(_ element: WhenElement<Result>) -> WhenElement<Result> {
    element
  }
}

public func => <Result>(lhs: Bool, rhs: Result) -> WhenElement<Result> {
  (lhs, rhs)
}

public func when<Result>(@When<Result> builder: () -> [WhenElement<Result>]) -> Result? {
  for condition in builder() {
    if condition.0 {
      return condition.1
    }
  }
  return nil
}


/*
 // Sample code:
 
public func describeNumber(_ n: Int) {
  let description: String? = when {
    (n > 0) => "positive"
    (n < 0) => "negative"
    "zero"
  }
  print(description)
}

public enum Colors: WhenCompliant {
  case red, blue, green
  
  var hexString: String {
    when(self) {
      Colors.red => "#FF0000"
      Colors.green => "#00F000"
      Colors.blue => "#0000FF"
    }
  }
}

public func describeColor(_ color: Colors) {
  let description: String = when(color) {
    Colors.red => "red"
    Colors.blue => "blue"
    "other"
  }
  print(description + color.hexString)
}
*/
