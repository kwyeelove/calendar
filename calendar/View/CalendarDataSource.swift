//
//  CalendarDataSource.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 27..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation

public protocol CalendarDataSource {
    func calendarView(_ view:  CalendarView, numberOfEventsAtDate date: Date) -> Int
    func calendarView(_ view:  CalendarView, dateRangeForEventAtIndex index: Int, date: Date) ->  DateRange?
    func calendarView(_ view:  CalendarView, eventViewForEventAtIndex index: Int, date: Date) ->  EventView
}

