//
//  AbsoluteDateTests.swift
//  AbsoluteDateTests
//
//  Created by Gregory Higley on 4/28/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import XCTest
@testable import AbsoluteDate

class AbsoluteDateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let decoder = JSONDecoder()
        decoder.userInfo[.absoluteDateTimeZone] = TimeZone(identifier: "UTC")!
    }
    
    
}
