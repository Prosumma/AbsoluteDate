//
//  AbsoluteDateTests.swift
//  AbsoluteDateTests
//
//  Created by Gregory Higley on 4/28/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import XCTest
import DateMath
@testable import AbsoluteDate

class AbsoluteDateTests: XCTestCase {
    
    func testExample() {
        let day = AbsoluteDay()
        XCTAssertEqual(day + 4, day + 4 * .day)
    }
    
    
}
