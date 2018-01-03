/*

//
//  CalendarWeekViewDelegate.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation
import UIKit

public protocol CalendarWeekViewDelegate {
    
    func weekViewHorizontalGridWidth(in view: CalendarWeekView) -> Float
    func weekViewVerticalGridWidth(in view: CalendarWeekView) -> Float
    
    func weekViewHorizontalGridColor(in view: CalendarWeekView) -> UIColor
    func weekViewVerticalGridColor(in view: CalendarWeekView) -> UIColor
    
    func calendarWeekView(_ view: CalendarWeekView, setWeekdayText weekday: Int) -> String
    func calendarWeekView(_ view: CalendarWeekView, setWeekdayTextColor weekday: Int) -> UIColor
    
    func calendarWeekView(_ view: CalendarWeekView, setWeekdayFont weekday: Int) -> UIFont
    func calendarWeekView(_ view: CalendarWeekView, setWeekViewBackgroundColor weekday: Int) -> UIColor
    
}

extension CalendarWeekViewDelegate {
    
    public func weekViewHorizontalGridWidth(in view: CalendarWeekView) -> Float {
        return WEEK_VIEW_HORIZONTAL_GRID_WIDTH
    }
    public func weekViewVerticalGridWidth(in view: CalendarWeekView) -> Float {
        return WEEK_VIEW_VERTICAL_GRID_WIDTH
    }
    
    public func weekViewHorizontalGridColor(in view: CalendarWeekView) -> UIColor {
        return .black
    }
    public func weekViewVerticalGridColor(in view: CalendarWeekView) -> UIColor {
        return .black
    }
    
    public func calendarWeekView(_ view: CalendarWeekView, setWeekdayText weekday: Int) -> String {
        return WEEK_SYMBOLE[weekday - 1]
    }
    public func calendarWeekView(_ view: CalendarWeekView, setWeekdayTextColor weekday: Int) -> UIColor {
        return .black
    }
    
    public func calendarWeekView(_ view: CalendarWeekView, setWeekdayFont weekday: Int) -> UIFont {
        return .systemFont(ofSize: 12.0)
    }
    public func calendarWeekView(_ view: CalendarWeekView, setWeekViewBackgoundColor weekday: Int) -> UIColor {
        return .clear
    }
}
*/
 //
 //  CalendarWeekBarAppearance.swift
 //  calendar
 //
 //  Created by YeeEmotion on 2017. 12. 26..
 //  Copyright © 2017년 YeeEmotion. All rights reserved.
 //


import Foundation
import UIKit

public protocol CalendarWeekBarAppearance: class {
    func weekBarHorizontalGridColor(in view: CalendarWeekView) -> UIColor
    func weekBarHorizontalGridWidth(in view: CalendarWeekView) -> CGFloat
    func weekBarVerticalGridColor(in view: CalendarWeekView) -> UIColor
    func weekBarVerticalGridWidth(in view: CalendarWeekView) -> CGFloat
    
    func calendarWeekBarView(_ view: CalendarWeekView, textAtWeekday weekday: Int) -> String
    func calendarWeekBarView(_ view: CalendarWeekView, textColorAtWeekday weekday: Int) -> UIColor
    func calendarWeekBarView(_ view: CalendarWeekView, backgroundColorAtWeekday weekday: Int) -> UIColor
    func calendarWeekBarView(_ view: CalendarWeekView, fontAtWeekday weekday: Int) -> UIFont
}

extension CalendarWeekBarAppearance {
    public func weekBarHorizontalGridColor(in view: CalendarWeekView) -> UIColor {
        return .black
    }
    
    public func weekBarHorizontalGridWidth(in view: CalendarWeekView) -> CGFloat {
        return WEEK_VIEW_HORIZONTAL_GRID_WIDTH
    }
    
    public func weekBarVerticalGridColor(in view: CalendarWeekView) -> UIColor {
        return .black
    }
    
    public func weekBarVerticalGridWidth(in view: CalendarWeekView) -> CGFloat {
        return WEEK_VIEW_VERTICAL_GRID_WIDTH
    }
    
    
    public func calendarWeekBarView(_ view: CalendarWeekView, textAtWeekday weekday: Int) -> String {
        return WEEK_SYMBOLE[weekday - 1]
    }
    
    public func calendarWeekBarView(_ view: CalendarWeekView, textColorAtWeekday weekday: Int) -> UIColor {
        return .black
    }
    
    public func calendarWeekBarView(_ view: CalendarWeekView, backgroundColorAtWeekday weekday: Int) -> UIColor {
        return .clear
    }
    
    public func calendarWeekBarView(_ view: CalendarWeekView, fontAtWeekday weekday: Int) -> UIFont {
        return .systemFont(ofSize: 12.0)
    }
}

