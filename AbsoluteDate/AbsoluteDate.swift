//
//  AbsoluteDate.swift
//  AbsoluteDate
//
//  Created by Gregory Higley on 4/28/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import DateMath
import Foundation

/**
 Represents a date and time independent of time zone.
 
 Unlike a `Date`, which represents a specific _point in time_,
 an `AbsoluteDate` wraps a string representation of a time, such as
 "2018-01-20 03:33:18.48".
 
 Date math can be performed on `AbsoluteDate` instances using the simple
 arithmetic operators `+` and `-` along with a `TimeInterval`. For example,
 if 86400 is added to the date above, the result is "2018-01-21 03:33:18.48".
 By default, date math is performed in the UTC time zone to avoid issues
 with daylight savings time. If you want to use a specific time zone,
 use `addTimeInterval` or `addingTimeInterval` to perform date math.
 */
public struct AbsoluteDate: CustomStringConvertible, Comparable, Hashable, Codable {
    /// The date format used to produce the internal representation of this `AbsoluteDate`.
    public static let dateFormat = "\(AbsoluteDay.dateFormat) \(AbsoluteTime.dateFormat)"
    
    public static let alternateDateFormats = AbsoluteTime.alternateDateFormats.map{ "\(AbsoluteDay.dateFormat) \($0)" }
    
    /// The `AbsoluteDay` portion of this `AbsoluteDate`.
    public let day: AbsoluteDay
    /// The `AbsoluteTime` portion of this `AbsoluteDate`.
    public let time: AbsoluteTime
    
    /// The internal representation of this `AbsoluteDate`.
    public let description: String
    public let hashValue: Int
    
    /// Initializes an `AbsoluteDate` from an existing `AbsoluteDay` and `AbsoluteTime`.
    public init(day: AbsoluteDay, time: AbsoluteTime) {
        self.day = day
        self.time = time
        self.description = "\(day) \(time)"
        self.hashValue = hash(String(describing: type(of: self)), day, time)
    }
    
    /**
     Initializes an `AbsoluteDate` with a `Date` and `TimeZone`.
     
     The specific point in time represented by the `Date` and the
     `TimeZone` itself are then lost. What remains in the abstract
     string representation of the date encoded in the `AbsoluteDate`.
     */
    public init(date: Date = Date(), in timeZone: TimeZone = .current) {
        self.init(day: AbsoluteDay(date: date, in: timeZone), time: AbsoluteTime(date: date, in: timeZone))
    }
    
    public init?(_ representation: String, in timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        
        formatter.dateFormat = AbsoluteDate.dateFormat
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
            formatter.dateFormat = AbsoluteDate.dateFormat
            guard let date = formatter.date(from: raw) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "'\(raw)' is not a valid AbsoluteDate representation.")
            }
            self.init(date: date, in: timeZone)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(describing: self))
    }
    
    /**
     Returns the underlying point in time represented by
     the abstract date representation in the given time zone.
     */
    public func date(in timeZone: TimeZone = .current) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = AbsoluteDate.dateFormat
        return formatter.date(from: String(describing: self))!
    }
    
    /// Returns the abstract string representation as a `Date` in the current time zone.
    public var date: Date {
        return date()
    }
    
    /**
     Adds `TimeInterval` seconds to the current `AbsoluteDate` in the specified time zone.
     
     The default time zone here is UTC. Changing this to a time zone with daylight savings
     time or other oddities may produce unexpected results.
     */
    public mutating func addTimeInterval(_ timeInterval: TimeInterval, in timeZone: TimeZone = .absoluteDateUTC) {
        self = addingTimeInterval(timeInterval, in: timeZone)
    }
    
    /**
     Produces a new `AbsoluteDate` by adding the specified time interval in the given time zone.
     
     The default time zone here is UTC. Changing this to a time zone with daylight savings
     time or other oddities may produce unexpected results.
     */
    public func addingTimeInterval(_ timeInterval: TimeInterval, in timeZone: TimeZone = .absoluteDateUTC) -> AbsoluteDate {
        return AbsoluteDate(date: date(in: timeZone).addingTimeInterval(timeInterval))
    }
    
    public func addingCalendarComponent(_ component: Calendar.Component, value: Int, in timeZone: TimeZone = .absoluteDateUTC) -> AbsoluteDate {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return AbsoluteDate(date: calendar.date(byAdding: component, value: value, to: date(in: timeZone))!, in: timeZone)
    }
    
    public mutating func addCalendarComponent(_ component: Calendar.Component, value: Int, in timeZone: TimeZone = .absoluteDateUTC) {
        self = addingCalendarComponent(component, value: value, in: timeZone)
    }
    
    /// Create a new `AbsoluteDate` by adding seconds.
    public static func +(lhs: AbsoluteDate, rhs: TimeInterval) -> AbsoluteDate {
        return lhs.addingTimeInterval(rhs)
    }
    
    /// Create a new `AbsoluteDate` by adding seconds.
    public static func +(lhs: TimeInterval, rhs: AbsoluteDate) -> AbsoluteDate {
        return rhs.addingTimeInterval(lhs)
    }
    
    public static func +(lhs: AbsoluteDate, rhs: DateMath.Expression) -> AbsoluteDate {
        return AbsoluteDate(date: lhs.date(in: .absoluteDateUTC) + .absoluteDateUTC ⁝ rhs, in: .absoluteDateUTC)
    }
    
    public static func +(lhs: DateMath.Expression, rhs: AbsoluteDate) -> AbsoluteDate {
        return rhs + lhs
    }
    
    public static func +=(lhs: inout AbsoluteDate, rhs: TimeInterval) {
        lhs = lhs + rhs
    }
    
    public static func +=(lhs: inout AbsoluteDate, rhs: DateMath.Expression) {
        lhs = lhs + rhs
    }
    
    public static func -(lhs: AbsoluteDate, rhs: TimeInterval) -> AbsoluteDate {
        return lhs.addingTimeInterval(-rhs)
    }
    
    public static func -(lhs: AbsoluteDate, rhs: DateMath.Expression) -> AbsoluteDate {
        return lhs + -rhs
    }
    
    public static func -=(lhs: inout AbsoluteDate, rhs: TimeInterval) {
        lhs = lhs - rhs
    }
    
    public static func -=(lhs: inout AbsoluteDate, rhs: DateMath.Expression) {
        lhs = lhs - rhs
    }
    
    public static func ==(lhs: AbsoluteDate, rhs: AbsoluteDate) -> Bool {
        return lhs.date(in: .absoluteDateUTC) == rhs.date(in: .absoluteDateUTC)
    }
    
    public static func <(lhs: AbsoluteDate, rhs: AbsoluteDate) -> Bool {
        return lhs.date(in: .absoluteDateUTC) < rhs.date(in: .absoluteDateUTC)
    }
    
}
