//
//  AbsoluteTime.swift
//  AbsoluteDate
//
//  Created by Gregory Higley on 4/28/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

public struct AbsoluteTime: CustomStringConvertible, Comparable, Hashable, Codable {
    public static let dateFormat = "HH:mm:ss.SSS"
    
    public let description: String
    public let hashValue: Int
    
    private init(_ description: String) {
        self.description = description
        self.hashValue = hash(String(reflecting: type(of: self)), description)
    }
    
    public init(date: Date = Date(), in timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.dateFormat = AbsoluteTime.dateFormat
        formatter.timeZone = timeZone
        self.init(formatter.string(from: date))
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timeZone = (decoder.userInfo[.absoluteDateTimeZone] as! TimeZone?) ?? .current
        do {
            let date = try container.decode(Date.self)
            self.init(date: date, in: timeZone)
        } catch DecodingError.typeMismatch {
            let raw = try container.decode(String.self)
            let formatter = DateFormatter()
            formatter.timeZone = timeZone
            formatter.dateFormat = AbsoluteTime.dateFormat
            if formatter.date(from: raw) == nil {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "'\(raw)' is not a valid AbsoluteTime representation.")
            }
            self.init(raw)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
    
    public func date(in timeZone: TimeZone = .current) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = AbsoluteTime.dateFormat
        return formatter.date(from: String(describing: self))!
    }
    
    public var date: Date {
        return date(in: .current)
    }
    
    public func addingTimeInterval(_ timeInterval: TimeInterval) -> AbsoluteTime {
        return AbsoluteTime(date: date(in: TimeZone(identifier: "UTC")!).addingTimeInterval(timeInterval))
    }
    
    public static func +(lhs: AbsoluteTime, rhs: TimeInterval) -> AbsoluteTime {
        return lhs.addingTimeInterval(rhs)
    }
    
    public static func +(lhs: TimeInterval, rhs: AbsoluteTime) -> AbsoluteTime {
        return rhs.addingTimeInterval(lhs)
    }
    
    public static func +=(lhs: inout AbsoluteTime, rhs: TimeInterval) {
        lhs = lhs + rhs
    }
    
    public static func -(lhs: AbsoluteTime, rhs: TimeInterval) -> AbsoluteTime {
        return lhs.addingTimeInterval(-rhs)
    }
    
    public static func -=(lhs: inout AbsoluteTime, rhs: TimeInterval) {
        lhs = lhs - rhs
    }
    
    public static func ==(lhs: AbsoluteTime, rhs: AbsoluteTime) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
    
    public static func <(lhs: AbsoluteTime, rhs: AbsoluteTime) -> Bool {
        return String(describing: lhs) < String(describing: rhs)
    }
}
