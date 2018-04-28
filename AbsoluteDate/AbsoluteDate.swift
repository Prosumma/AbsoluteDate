//
//  AbsoluteDate.swift
//  AbsoluteDate
//
//  Created by Gregory Higley on 4/28/18.
//  Copyright © 2018 Gregory Higley. All rights reserved.
//

import Foundation

public struct AbsoluteDate: CustomStringConvertible, Comparable, Hashable, Codable {
    public static let dateFormat = "\(AbsoluteDay.dateFormat) \(AbsoluteTime.dateFormat)"
    
    public let day: AbsoluteDay
    public let time: AbsoluteTime
    
    public let description: String
    public let hashValue: Int
    
    public init(day: AbsoluteDay, time: AbsoluteTime) {
        self.day = day
        self.time = time
        self.description = "\(day) \(time)"
        self.hashValue = hash(String(describing: type(of: self)), day, time)
    }
    
    public init(date: Date = Date(), in timeZone: TimeZone = .current) {
        self.init(day: AbsoluteDay(date: date, in: timeZone), time: AbsoluteTime(date: date, in: timeZone))
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
    
    public func date(in timeZone: TimeZone = .current) -> Date {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = AbsoluteDate.dateFormat
        return formatter.date(from: String(describing: self))!
    }
    
    public var date: Date {
        return date(in: .current)
    }
    
    public func addingTimeInterval(_ timeInterval: TimeInterval) -> AbsoluteDate {
        return AbsoluteDate(date: date.addingTimeInterval(timeInterval))
    }
    
    public static func +(lhs: AbsoluteDate, rhs: TimeInterval) -> AbsoluteDate {
        return lhs.addingTimeInterval(rhs)
    }
    
    public static func +(lhs: TimeInterval, rhs: AbsoluteDate) -> AbsoluteDate {
        return rhs.addingTimeInterval(lhs)
    }
    
    public static func +=(lhs: inout AbsoluteDate, rhs: TimeInterval) {
        lhs = lhs + rhs
    }
    
    public static func -(lhs: AbsoluteDate, rhs: TimeInterval) -> AbsoluteDate {
        return lhs.addingTimeInterval(-rhs)
    }
    
    public static func -=(lhs: inout AbsoluteDate, rhs: TimeInterval) {
        lhs = lhs - rhs
    }
    
    public static func ==(lhs: AbsoluteDate, rhs: AbsoluteDate) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
    
    public static func <(lhs: AbsoluteDate, rhs: AbsoluteDate) -> Bool {
        return String(describing: lhs) < String(describing: rhs)
    }
    
}
