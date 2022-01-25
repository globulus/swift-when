import XCTest
@testable import SwiftWhen

func describeNumber(_ n: Int) -> String {
  when {
    (n > 0) => "positive"
    (n < 0) => "negative"
    "zero"
  }
}

enum Colors: WhenCompliant {
  case red, blue, green
  
  var hexString: String {
    when(self) {
      Colors.red => "#FF0000"
      Colors.green => "#00FF00"
      Colors.blue => "#0000FF"
    }
  }
}

func describeColor(_ color: Colors) -> String {
  let description = when(color) {
    Colors.red => "red"
    Colors.blue => "blue"
    "other"
  }
  return description + color.hexString
}

func describeColorMultiple(_ color: Colors) -> String {
  when(color) {
    [Colors.red, Colors.blue] => "redOrBlue"
    Colors.green => "green"
  }
}

final class SwiftWhenTests: XCTestCase {
  func testWhen() throws {
    XCTAssertEqual(describeNumber(10), "positive")
    XCTAssertEqual(describeNumber(-10), "negative")
    XCTAssertEqual(describeNumber(0), "zero")
  }
  
  func testWhenCase() throws {
    XCTAssertEqual(describeColor(.red), "red#FF0000")
    XCTAssertEqual(describeColor(.green), "other#00FF00")
    XCTAssertEqual(describeColor(.blue), "blue#0000FF")
  }
  
  func testWhenMultipleCase() throws {
    XCTAssertEqual(describeColorMultiple(.red), "redOrBlue")
    XCTAssertEqual(describeColorMultiple(.green), "green")
    XCTAssertEqual(describeColorMultiple(.blue), "redOrBlue")
  }
}
