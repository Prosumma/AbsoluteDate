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
    
    private init(description: String) {
        self.description = description
        self.hashValue = hash(String(reflecting: type(of: self)), description)
    }
    
    public init(date: Date = Date(), in timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.dateFormat = AbsoluteTime.dateFormat
        formatter.timeZone = timeZone
        self.init(description: formatter.string(from: date))
    }
    
    public init?(_ representation: String, in timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.dateFormat = AbsoluteTime.dateFormat
        formatter.timeZone = timeZone
        guard let date = formatter.date(from: representation) else {
            return nil
        }
        self.init(date: date, in: timeZone)
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
            self.init(description: raw)
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
        return date()
    }
    
    public func addingTimeInterval(_ timeInterval: TimeInterval, in timeZone: TimeZone = .absoluteDateUTC) -> AbsoluteTime {
        return AbsoluteTime(date: date(in: timeZone).addingTimeInterval(timeInterval))
    }
    
    public mutating func addTimeInterval(_ timeInterval: TimeInterval, in timeZone: TimeZone = .absoluteDateUTC) {
        self = addingTimeInterval(timeInterval, in: timeZone)
    }
    
    public func addingCalendarComponent(_ component: Calendar.Component, value: Int, in timeZone: TimeZone = .absoluteDateUTC) -> AbsoluteTime {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return AbsoluteTime(date: calendar.date(byAdding: component, value: value, to: date(in: timeZone))!, in: timeZone)
    }
    
    public mutating func addCalendarComponent(_ component: Calendar.Component, value: Int, in timeZone: TimeZone = .absoluteDateUTC) {
        self = addingCalendarComponent(component, value: value, in: timeZone)
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
        return lhs.date(in: .absoluteDateUTC) == rhs.date(in: .absoluteDateUTC)
    }
    
    public static func <(lhs: AbsoluteTime, rhs: AbsoluteTime) -> Bool {
        return lhs.date(in: .absoluteDateUTC) < rhs.date(in: .absoluteDateUTC)
    }
}
