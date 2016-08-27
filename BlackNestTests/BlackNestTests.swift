//
//  BlackNestTests.swift
//  BlackNestTests
//
//  Created by Elmar Kretzer on 22.08.16.
//  Copyright © 2016 Elmar Kretzer. All rights reserved.
//

import XCTest
@testable import BlackNest

class BlackNestTests: XCTestCase {

  // --------------------------------------------------------------------------------
  // MARK: - Specs
  // --------------------------------------------------------------------------------

  func doubleTuple(input: (Int), expect: (Int, Int)) throws -> (Int, Int) {
    // Act:
    let subject = (input, input * 2)

    // Assert:
    try subject.0 == expect.0
      => "first entry should be the same"
    try subject.0 != expect.1
      => "first entry should not be euqal to second"
    try subject.1 == expect.1
      => "second entry should be duplicate"

    return subject
  }

  func tupleSum(input: (Int, Int), expect: (Int)) throws -> Int {
    // Act:
    let subject = input.0 + input.1

    // Assert:
    try subject == expect
      => "sum calculation"

    return subject
  }

  // --------------------------------------------------------------------------------
  // MARK: - Tests
  // --------------------------------------------------------------------------------

  func testPlain() {

    expect(004, in:doubleTuple, is:(04, 08))
    expect(008, in:doubleTuple, is:(08, 16))
    expect(012, in:doubleTuple, is:(12, 24))
    expect(100, in:doubleTuple, is:(100, 200))

    expect(004, in: doubleTuple => (04, 08))
    expect(008, in: doubleTuple => (08, 16))
    expect(012, in: doubleTuple => (12, 24))
    expect(100, in: doubleTuple => (100, 200))

    expect(004 | doubleTuple => (04, 08))
    expect(008 | doubleTuple => (08, 16))
    expect(012 | doubleTuple => (12, 24))
    expect(100 | doubleTuple => (100, 200))

    XCTAssertThrowsError(try (12 | doubleTuple => (13, 24)).breed()) { e in
        guard let _ = e as? BLNShellCrackError else {
          return XCTFail("BLNShellCrackError not coming")
        }
    }
  }

  func testChain() {

    expect(4, in:doubleTuple, is:(04, 08))
      .then(tupleSum, is:12)
    expect(8, in:doubleTuple, is:(08, 16))
      .then(tupleSum, is:24)
    expect(12, in:doubleTuple, is:(12, 24))
      .then(tupleSum, is:36)

    expect(004 | doubleTuple => (04, 08))
              .then(tupleSum => 12)
    expect(008 | doubleTuple => (08, 16))
              .then(tupleSum => 24)
    expect(012 | doubleTuple => (12, 24))
              .then(tupleSum => 36)
    expect(100 | doubleTuple => (100, 200))
              .then(tupleSum => 300)

    expect(4,
           in: doubleTuple ◦ tupleSum,
           is: (04, 08)    • 12
    )

    expect(4,
              in: doubleTuple ◦ tupleSum ◦ doubleTuple ◦ tupleSum ◦ doubleTuple,
              is: (04, 08)    • 12       • (12, 24)    • 36       • (36, 72)
    )

    expect(
      4 |  doubleTuple => (04, 08)
        |> tupleSum    => (12)
    )

    expect(
      4 |  doubleTuple => (04, 08)
        |> tupleSum    => (12)
        |> doubleTuple => (12, 24)
        |> tupleSum    => (36)
    )

    XCTAssertThrowsError(try (12 | doubleTuple => (13, 24)).breed()) { e in
      guard let _ = e as? BLNShellCrackError else {
        return XCTFail("BLNShellCrackError not coming")
      }
    }
  }

  // --------------------------------------------------------------------------------
  // MARK: - Tasty
  // --------------------------------------------------------------------------------

  struct Tasty {
    var firstName: String?
    var lastName: String?
    var age: Int?

    init() { }

    var displayName: String {
      switch (firstName, lastName, age) {
      case let (fn?, ln?, age?):
        return "\(fn) \(ln) (\(age))"
      case let (fn?, ln?, .none):
        return "\(fn) \(ln)"
      case let (fn?, .none, _):
        return "\(fn)"
      default:
        return "unknown"
      }
    }
  }

  func testExample() {

    typealias ChangeTasty = @escaping (inout Tasty) -> ()

    func change(_ handler: ChangeTasty) -> (Tasty, String) throws -> (Tasty) {
      return { input, expect in

        // Act:
        var subject = input
        handler(&subject)

        // Assert:
        try subject.displayName == expect
          => "displayname is correct built"

        return subject
      }
    }

    expect(
      Tasty() |  change { $0.age = 10 }            => "unknown"
              |> change { $0.firstName = "test" }  => "test"
              |> change { $0.lastName = "test" }   => "test test (10)"
              |> change { $0.age = 20 }            => "test test (20)"
    )

  }

}
