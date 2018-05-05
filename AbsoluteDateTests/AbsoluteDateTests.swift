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
    
    func testInitializationOfAbsoluteDateFromDate() {
        let timeZone = TimeZone(identifier: "GMT")!
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = timeZone
        let representation = "2013-05-22 13:10:05.334"
        guard let date = formatter.date(from: representation) else {
            XCTFail("'\(representation)' is not a valid date.")
            return
        }
        let absoluteDate = AbsoluteDate(date: date, in: timeZone)
        XCTAssertEqual(String(describing: absoluteDate), representation)
    }
    
    func testInitializationOfAbsoluteDateFromRepresentation() {
        let representation = "2013-05-22 13:10:05.334"
        XCTAssertNotNil(AbsoluteDate(representation))
        XCTAssertEqual(String(describing: AbsoluteDate(representation)!), representation)
    }
    
}
