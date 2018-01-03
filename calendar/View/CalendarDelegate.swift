//
//  CalendarDelegate.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 27..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol  CalendarDelegate {
    @objc optional func calendarViewDidScroll(_ view: CalendarView)
    @objc optional func calendarView(_ view:  CalendarView, didSelectDayCellAtDate date: Date)
    @objc optional func calendarView(_ view:  CalendarView, didMoveMonthOfStartDate date: Date)
    @objc optional func calendarView(_ view:  CalendarView, shouldSelectEventAtIndex index: Int, date: Date) -> Bool
    @objc optional func calendarView(_ view:  CalendarView, didSelectEventAtIndex index: Int, date: Date)
    @objc optional func calendarView(_ view:  CalendarView, shouldDeselectEventAtIndex index: Int, date: Date) -> Bool
    @objc optional func calendarView(_ view:  CalendarView, didDeselectEventAtIndex index: Int, date: Date)
}

