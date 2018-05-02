//
//  AbsoluteDay.swift
//  AbsoluteDate
//
//  Created by Gregory Higley on 4/28/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

/**
 A calendar day independent of time zone.
 */
public struct AbsoluteDay: CustomStringConvertible, Comparable, Hashable, Codable {
    
    public static let dateFormat = "YYYY-MM-dd"
    
    public let description: String
    public let hashValue: Int
    
    private init(description: String) {
        self.description = description
        self.hashValue = hash(String(reflecting: type(of: self)), description)
    }
    
    public init(date: Date = Date(), in timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.dateFormat = AbsoluteDay.dateFormat
        formatter.timeZone = timeZone
        self.init(description: formatter.string(from: date))
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
            formatter.dateFormat = AbsoluteDay.dateFormat
            if formatter.date(from: raw) == nil {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "'\(raw)' is not a valid AbsoluteDay representation.")
            }
            self.init(description: raw)
        }
    }
    
    public init?(_ representation: String, in timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.dateFormat = AbsoluteDay.dateFormat
        formatter.timeZone = timeZone
        guard let date = formatter.date(from: representation) else {
            return nil
        }
        self.init(date: date, in: timeZone)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
    
    public func date(in timeZone: TimeZone = .current) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = AbsoluteDay.dateFormat
        return formatter.date(from: String(describing: self))!
    }
    
    public var date: Date {
        return date()
    }
    
    public func addingTimeInterval(_ timeInterval: TimeInterval, in timeZone: TimeZone = .absoluteDateUTC) -> AbsoluteDay {
        return AbsoluteDay(date: date(in: timeZone).addingTimeInterval(timeInterval))
    }
    
    public mutating func addTimeInterval(_ timeInterval: TimeInterval, in timeZone: TimeZone = .absoluteDateUTC) {
        self = AbsoluteDay(date: date(in: timeZone).addingTimeInterval(timeInterval))
    }
    
    public func addingCalendarComponent(_ component: Calendar.Component, value: Int, in timeZone: TimeZone = .absoluteDateUTC) -> AbsoluteDay {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return AbsoluteDay(date: calendar.date(byAdding: component, value: value, to: date(in: timeZone))!, in: timeZone)
    }
    
    public mutating func addCalendarComponent(_ component: Calendar.Component, value: Int, in timeZone: TimeZone = .absoluteDateUTC) {
        self = addingCalendarComponent(component, value: value, in: timeZone)
    }
    
    public static func ==(lhs: AbsoluteDay, rhs: AbsoluteDay) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
    
    public static func <(lhs: AbsoluteDay, rhs: AbsoluteDay) -> Bool {
        return String(describing: lhs) < String(describing: rhs)
    }
    
    public static func +(lhs: AbsoluteDay, rhs: Int) -> AbsoluteDay {
        return lhs.addingCalendarComponent(.day, value: rhs)
    }
    
    public static func +(lhs: Int, rhs: AbsoluteDay) -> AbsoluteDay {
        return rhs.addingCalendarComponent(.day, value: lhs)
    }
    
    public static func +=(lhs: inout AbsoluteDay, rhs: Int) {
        lhs = lhs + rhs
    }
    
    public static func -(lhs: AbsoluteDay, rhs: Int) -> AbsoluteDay {
        return lhs.addingCalendarComponent(.day, value: -rhs)
    }
    
    public static func -=(lhs: inout AbsoluteDay, rhs: Int) {
        lhs = lhs - rhs
    }
}
