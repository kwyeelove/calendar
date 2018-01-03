//
//  EventsRowViewDelegate.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import UIKit

@objc internal protocol EventsRowViewDelegate: UIScrollViewDelegate {
    
    func eventsRowView(_ view: EventsRowView, numberOfEventsForDayAtIndex day: Int) -> Int
    func eventsRowView(_ view: EventsRowView, rangeForEventAtIndexPath indexPath: IndexPath) -> NSRange
    func eventsRowView(_ view: EventsRowView, cellForEventAtIndexPath indexPath: IndexPath) ->  EventView
    
    @objc optional func eventsRowView(_ view:  EventsRowView, widthForDayRange range: NSRange) -> CGFloat
    @objc optional func eventsRowView(_ view:  EventsRowView, shouldSelectCellAtIndexPath indexPath: IndexPath) -> Bool
    @objc optional func eventsRowView(_ view:  EventsRowView, shouldDeselectCellAtIndexPath indexPath: IndexPath) -> Bool
    @objc optional func eventsRowView(_ view:  EventsRowView, didSelectCellAtIndexPath indexPath: IndexPath)
    @objc optional func eventsRowView(_ view:  EventsRowView, didDeselectCellAtIndexPath  indexPath: IndexPath)
    @objc optional func eventsRowView(_ view:  EventsRowView, willDisplayCell cell:  EventView, forEventAtIndexPath indexPath: IndexPath)
    @objc optional func eventsRowView(_ view:  EventsRowView, didEndDidsplayingCell cell:  EventView, forEventAtIndexPath indexPath: IndexPath)

}
