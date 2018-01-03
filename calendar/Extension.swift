//
//  Extension.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 18..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Date
extension Date {
    
    static func getToday() -> Date {
        let sourceDate = Date()
        
        let sourceTimeZone = TimeZone.init(abbreviation: "GMT")
        let destinationTimeZone = TimeZone.current
        
        let sourceGMToffset = sourceTimeZone?.secondsFromGMT(for: sourceDate)
        let destinationGMToffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
        
        let interval : TimeInterval = TimeInterval(destinationGMToffset - sourceGMToffset!)
        
        return Date(timeInterval: interval, since: sourceDate)
    }
    
    static func gregorianCalendar() -> Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.init(abbreviation: "GMT")!
        cal.locale = Locale.init(identifier: "Kr_Ko")
        return cal
    }
    
}

// MARK:- UIColor
extension UIColor {
    static var dark: UIColor {
        return UIColor(red: 42/255, green: 52/255, blue: 58/255, alpha: 1.0)
    }
    
    static var deeppink: UIColor {
        return UIColor(red: 253/255, green: 63/255, blue: 127/255, alpha: 1.0)
    }
    
    static var turquoise: UIColor {
        return UIColor(red: 0, green: 206/255, blue: 209/255, alpha: 1.0)
    }
    
    static var seagreen: UIColor {
        return UIColor(red: 67/255, green: 205/255, blue: 128/255, alpha: 1.0)
    }
    
    static var violetred: UIColor {
        return UIColor(red: 185/255, green: 29/255, blue: 81/255, alpha: 1.0)
    }
    
    static var sienna: UIColor {
        return UIColor(red: 204/255, green: 117/255, blue: 54/255, alpha: 1.0)
    }
    
    static var lightblue: UIColor {
        return UIColor(red: 69/255, green: 176/255, blue: 208/255, alpha: 1.0)
    }
    
    static var oceanblue: UIColor {
        return UIColor(red: 81/255, green: 110/255, blue: 190/255, alpha: 1.0)
    }
}

// MARK:- Calendar
extension Calendar {
    func year(_ date: Date) -> Int {
        guard let year = dateComponents([.year], from: date).year else {
            fatalError()
        }
        return year
    }
    
    public func month(_ date: Date) -> Int {
        guard let month = dateComponents([.month], from: date).month else {
            fatalError()
        }
        return month
    }
    
    public func day(_ date: Date) -> Int {
        guard let day = dateComponents([.day], from: date).day else {
            fatalError()
        }
        return day
    }
    
    public func endOfDayForDate(_ date: Date) -> Date {
        var comps = dateComponents([.year, .month, .day], from: self.date(byAdding: .day, value: 1, to: date)!)
        comps.second = -1
        return self.date(from: comps)!
    }
    
    public func startOfMonthForDate(_ date: Date) -> Date {
        var comp = self.dateComponents([.year, .month, .day], from: date)
        comp.day = 1
        return self.date(from: comp)!
    }
    
    public func endOfMonthForDate(_ date: Date) -> Date {
        var comp = self.dateComponents([.year, .month, .day], from: date)
        if let month = comp.month {
            comp.month = month + 1
        }
        comp.day = 0
        return self.date(from: comp)!
    }
    
    public func nextStartOfMonthForDate(_ date: Date) -> Date {
        let firstDay = startOfMonthForDate(date)
        var comp = DateComponents()
        comp.month = 1
        return self.date(byAdding: comp, to: firstDay)!
    }
    
    public func prevStartOfMonthForDate(_ date: Date) -> Date {
        let firstDay = startOfMonthForDate(date)
        var comp = DateComponents()
        comp.month = -1
        return self.date(byAdding: comp, to: firstDay)!
    }
    
    public func numberOfDaysInMonthForDate(_ date: Date) -> Int {
        return range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    public func numberOfWeeksInMonthForDate(_ date: Date) -> Int {
        return range(of: .weekOfMonth, in: .month, for: date)?.count ?? 0
    }
}
