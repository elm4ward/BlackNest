//
//  BlackNestXCAssert.swift
//  BlackNest
//
//  Created by Elmar Kretzer on 22.08.16.
//  Copyright © 2016 symentis GmbH. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest

// --------------------------------------------------------------------------------
// MARK: - expect for BLNBox
// --------------------------------------------------------------------------------

/// Expect takes a BLNBox and checks for error
/// - parameter run: BLNBox
/// - returns: Void
public func expect<I, E, O>(_ run: BLNBox<I, E, O>,
            line: UInt = #line,
            file: StaticString = #file) -> O? {
  do {
    return try run.runIt()
  } catch let error {
    XCTAssert(false, "\(error)", file: file, line: line)
  }
  return nil
}

/// Expect takes a BLNBox and checks for error
/// - parameter run: BLNBox
/// - returns: Void
public func expect<I, E, O>(_ run: BLNBreeding<I, E, O>,
            at input: I,
            is expected: E,
            line: UInt = #line,
            file: StaticString = #file) -> O? {
  return expect(input | run => expected)
}
