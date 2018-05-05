//
//  AbsoluteDayTests.swift
//  AbsoluteDate
//
//  Created by Gregory Higley on 5/3/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import XCTest
@testable import AbsoluteDate

class AbsoluteDayTests: XCTestCase {

    func testInitializationOfAbsoluteDayFromDate() {
        let timeZone = TimeZone(identifier: "GMT")!
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        formatter.timeZone = timeZone
        let representation = "2013-05-22 13:10"
        guard let date = formatter.date(from: representation) else {
            XCTFail("'\(representation)' is not a valid date.")
            return
        }
        let absoluteDay = AbsoluteDay(date: date, in: timeZone)
        XCTAssertEqual(String(describing: absoluteDay), String(representation.prefix(10)))
    }
    
}
