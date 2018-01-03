//
//  CalendarView.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import UIKit

final public class CalendarView: UICollectionView, CalendarAppearance {
    
    // 달력의 모양을 설정하는 객채
    public var appearance : CalendarAppearance!
    // CalendarView (Collection View) delegate
    public var calendarDelegate: CalendarDelegate?
    // CalendarView (Collection View) datasource
    public var calendarDataSource: CalendarDataSource?
    
    public var calendar : Calendar = Calendar.current {
        didSet {
            calendarReload()
        }
    }
    
    // 달력 Layout 객채
    fileprivate var layout: CalendarLayout {
        set {
            self.collectionViewLayout = newValue
        }
        get {
            return self.collectionViewLayout as! CalendarLayout
        }
    }
    // 달력 속 날짜 Label 높이
    public var dayLabelHeight: CGFloat = 18 {
        didSet {
            self.layout.dayHeaderHeight = dayLabelHeight
            self.reloadData()
        }
    }
    // 달력 범위
    fileprivate var dateRange: DateRange?
    
    // 선택한 날짜 변수
    fileprivate var selectedEventDate: Date?
    // 선택한 날짜 collectionViewCell의 index
    fileprivate lazy var selectedEventIndex: Int = 0
    // 중복으로 선택한 날짜 변수
    public var selectedDates: [Date] = []
    
    // 애니메이션
    public var selectAnimation: SelectAnimation   = .bounce
    public var deselectAnimation: SelectAnimation = .fade
    
    // EventsRow 높이값.
    public var eventViewHeight: CGFloat = 16
    
    // CollectionView 달력 Row가 보여질 개수
    public var maxVisibleEvents: Int?
    // EventRowView Cache
    fileprivate var eventRowsCache = IndexableDictionary<Date, EventsRowView>()
    // 캐시 사이즈
    fileprivate let rowCacheSize = 40
    // 재사용 queue
    fileprivate var reuseQueue = ReusableObjectQueue()
    
    
    // 달력 매월의 시작 날짜(?)
    fileprivate var startDate = Date() {
        didSet {
            let s = calendar.startOfMonthForDate(startDate)
            if startDate != s {
                startDate = s
            }
        }
    }
    
    public var visibleDays: DateRange? {
        self.layoutIfNeeded()
        var range: DateRange? = nil
        
        let visible = self.indexPathsForVisibleItems.sorted()
        if let firstIdx = visible.first, let lastIdx = visible.last, !visible.isEmpty {
            let first = dateForDayAtIndexPath(firstIdx)
            let last  = dateForDayAtIndexPath(lastIdx)
            
            range = DateRange(start: first, end: calendar.nextStartOfMonthForDate(last))
        }
        return range
    }
    
    public var scrollDirection: ScrollDirection = .vertical {
        didSet {
            let monthLayout = CalendarLayout(scrollDirection: scrollDirection)
            monthLayout.delegate = self
            monthLayout.dayHeaderHeight = dayLabelHeight
            layout = monthLayout
        }
    }
    
    fileprivate var numberOfLoadedMonths: Int {
        if let dateRange = dateRange,
            let diff = calendar.dateComponents([.month], from: dateRange.start, to: dateRange.end).month {
            return min(diff, 9)
        }
        return 9
    }
    
    fileprivate var loadedDateRange: DateRange {
        var comps = DateComponents()
        comps.month = numberOfLoadedMonths
        let endDate = calendar.date(byAdding: comps, to: startDate)
        return DateRange(start: startDate, end: endDate!)
    }
    
    
    // MARK:- Private Method
    fileprivate func calendarReload() {
        // 선택된 날짜 해제
        self.deselectEventWithDelegate(true)
        // Row 캐시를 지운다고?
        self.clearRowsCacheInDateRange(nil)
        //  진짜 reload...
        self.reloadData()
    }
}

// MARK:- CalendarView Public
extension CalendarView {
    public func registerClass(_ objectClass: ReusableObject.Type, forEventCellReuseIdentifier identifier: String) {
        reuseQueue.registerClass(objectClass, forObjectWithReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCellWithIdentifier<T: EventView>(_ identifier: String, forEventAtIndex index: Int, date: Date) -> T? {
        guard let cell = reuseQueue.dequeueReusableObjectWithIdentifier(identifier) as? T? else {
            return nil
        }
        if let selectedDate = selectedEventDate,
            calendar.isDate(selectedDate, inSameDayAs: date) && index == selectedEventIndex {
            cell?.selected = true
        }
        return cell
    }
    
    public func reloadEvents() {
        deselectEventWithDelegate(true)
        guard let visibleDateRange = visibleDays else {
            return
        }
        eventRowsCache.forEach { date, rowView in
            let rowRange = dateRangeForYMEventsRowView(rowView)
            if rowRange.intersectsDateRange(visibleDateRange) {
                rowView.reload()
            } else {
                removeRowAtDate(date)
            }
        }
    }
    
    public func reloadEventsAtDate(_ date: Date) {
        if let selectedEventDate = selectedEventDate, calendar.isDate(selectedEventDate, inSameDayAs: date) {
            deselectEventWithDelegate(true)
        }
        if let visibleDateRange = visibleDays {
            eventRowsCache.forEach { date, rowView in
                let rowRange = dateRangeForYMEventsRowView(rowView)
                if rowRange.contains(date: date) {
                    if visibleDateRange.contains(date: date) {
                        rowView.reload()
                    } else {
                        removeRowAtDate(date)
                    }
                }
            }
        }
    }
    
    public func reloadEventsInRange(_ range: DateRange) {
        if let selectedEventDate = selectedEventDate, range.contains(date: selectedEventDate) {
            deselectEventWithDelegate(true)
        }
        if let visibleDateRange = visibleDays {
            var reloadRowViews: [EventsRowView] = []
            eventRowsCache.forEach({ date, rowView in
                let rowRange = dateRangeForYMEventsRowView(rowView)
                if rowRange.intersectsDateRange(range) {
                    if rowRange.intersectsDateRange(visibleDateRange) {
                        reloadRowViews.append(rowView)
                    } else {
                        removeRowAtDate(date)
                    }
                }
            })
            DispatchQueue.main.async {
                reloadRowViews.forEach {$0.reload()}
            }
        }
    }
    
    public var visibleEventCells: [EventView] {
        var cells: [EventView] = []
        for rowView in visibleEventRows {
            let rect = rowView.convert(bounds, from: self)
            cells.append(contentsOf: rowView.cellsInRect(rect))
        }
        return cells
    }
    
    public func eventViewForEventAtIndex(_ index: Int, date: Date) -> EventView? {
        for rowView in visibleEventRows {
            guard let day = calendar.dateComponents([.day], from: rowView.referenceDate, to: date).day else {
                return nil
            }
            if NSLocationInRange(day, rowView.daysRange) {
                return rowView.cellAtIndexPath(IndexPath(item: index, section: day))
            }
        }
        return nil
    }
    
    public func eventCellAtPoint(_ pt: CGPoint, date: inout Date, index: inout Int) -> EventView? {
        for rowView in visibleEventRows {
            let ptInRow = rowView.convert(pt, from: self)
            if let path = rowView.indexPathForCellAtPoint(ptInRow) {
                var comps = DateComponents()
                comps.day = path.section
                date = calendar.date(byAdding: comps, to: rowView.referenceDate)!
                index = path.item
                return rowView.cellAtIndexPath(path)
            }
        }
        return nil
    }
    
    public func dayAtPoint(_ point: CGPoint) -> Date? {
        let pt = self.convert(point, from: self)
        if let indexPath = self.indexPathForItem(at: pt) {
            return dateForDayAtIndexPath(indexPath)
        }
        return nil
    }
}
// MARK: - CalendarView Selection
extension CalendarView {
    
    
    public var selectedEventView: EventView? {
        if let date = selectedEventDate {
            return eventViewForEventAtIndex(selectedEventIndex, date: date)
        }
        return nil
    }
    
    public func deselectEventWithDelegate(_ tellDelegate: Bool) {
        if let selectedDate = selectedEventDate {
            let cell = eventViewForEventAtIndex(selectedEventIndex, date: selectedDate)
            cell?.selected = false
            
            if tellDelegate {
                self.calendarDelegate?.calendarView?(self, didDeselectEventAtIndex: selectedEventIndex, date: selectedDate)
            }
            
            selectedEventDate = nil
        }
    }
    
    public func deselectEvent() {
        if allowsSelection {
            deselectEventWithDelegate(false)
        }
    }
    
    public func selectEventCellAtIndex(_ index: Int, date: Date) {
        deselectEventWithDelegate(false)
        
        if allowsSelection {
            let cell = eventViewForEventAtIndex(index, date: date)
            cell?.selected = true
            
            selectedEventDate  = date
            selectedEventIndex = index
        }
    }
}

// MARK:- CalendarView Utils
extension CalendarView {
    fileprivate func dateForDayAtIndexPath(_ indexPath: IndexPath) -> Date {
        var comp   = DateComponents()
        comp.month = indexPath.section
        comp.day   = indexPath.row
        return calendar.date(byAdding: comp, to: startDate)!
    }
    
    fileprivate func indexPathForDate(_ date: Date) -> IndexPath? {
        var indexPath: IndexPath? = nil
        if loadedDateRange.contains(date: date) {
            let comps = calendar.dateComponents([.month, .day], from: startDate, to: date)
            guard let day = comps.day, let month = comps.month else {
                return nil
            }
            indexPath = IndexPath(item: day, section: month)
        }
        return indexPath
    }
    
    fileprivate func indexPathsForDaysInRange(_ range: DateRange) -> [IndexPath] {
        var paths: [IndexPath] = []
        var comps = DateComponents()
        comps.day = 0
        
        var date = calendar.startOfDay(for: range.start)
        while range.contains(date: date) {
            if let path = indexPathForDate(date) {
                paths.append(path)
            }
            
            guard let day = comps.day else {
                return paths
            }
            comps.day = day + 1
            date = calendar.date(byAdding: comps, to: range.start)!
        }
        return paths
    }
    
    fileprivate func dateStartingMonthAtIndex(_ month: Int) -> Date {
        return dateForDayAtIndexPath(IndexPath(item: 0, section: month))
    }
    
    fileprivate func numberOfDaysForMonthAtMonth(_ month: Int) -> Int {
        let date = dateStartingMonthAtIndex(month)
        return calendar.numberOfDaysInMonthForDate(date)
    }
    
    fileprivate func columnForDayAtIndexPath(_ indexPath: IndexPath) -> Int {
        let date = dateForDayAtIndexPath(indexPath)
        var weekday = calendar.component(.weekday, from: date)
        weekday = (weekday + 7 - calendar.firstWeekday) % 7
        return weekday
    }
    
    fileprivate func dateRangeForYMEventsRowView(_ rowView: EventsRowView) -> DateRange {
        let start = calendar.date(byAdding: .day, value: rowView.daysRange.location, to: rowView.referenceDate)
        let end = calendar.date(byAdding: .day, value: NSMaxRange(rowView.daysRange), to: rowView.referenceDate)
        return DateRange(start: start!, end: end!)
    }
    
    fileprivate func offsetForMonth(date: Date) -> CGFloat {
        let startOfMonth = calendar.startOfMonthForDate(date)
        
        let comps = calendar.dateComponents([.month], from: startDate, to: startOfMonth)
        let monthsDiff = labs(comps.month!)
        
        var offset: CGFloat = 0
        
        var month = (startOfMonth as NSDate).earlierDate(startDate)
        for _ in 0..<monthsDiff {
            offset += scrollDirection == .vertical ? self.bounds.height : self.bounds.width
            month = calendar.date(byAdding: .month, value: 1, to: month)!
        }
        
        if startOfMonth.compare(startDate) == .orderedAscending {
            offset = -offset
        }
        return offset
    }
    
    fileprivate func monthFromOffset(_ offset: CGFloat) -> Date {
        var month = startDate
        if scrollDirection == .vertical {
            let height = bounds.height
            var y = offset > 0 ? height : 0
            
            while y < fabs(offset) {
                month = calendar.date(byAdding: .month, value: offset > 0 ? 1 : -1, to: month)!
                y += height
            }
        } else {
            let width = self.bounds.width
            var x = offset > 0 ? width : 0
            
            while x < fabs(offset) {
                month = calendar.date(byAdding: .month, value: offset > 0 ? 1 : -1, to: month)!
                x += width
            }
        }
        return month
    }
    
    public func reload() {
        deselectEventWithDelegate(true)
        clearRowsCacheInDateRange(nil)
        self.reloadData()
    }
    
    fileprivate func maxSizeForFont(_ font: UIFont, toFitStrings strings: [String], inSize size: CGSize) -> CGFloat {
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = 0.1
        
        var fontSize = font.pointSize
        for str in strings {
            let attrStr = NSAttributedString(string: str, attributes: [NSAttributedStringKey.font : font])
            attrStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: context)
            fontSize = min(fontSize, font.pointSize * context.actualScaleFactor)
        }
        return floor(fontSize)
    }
}

// MARK: - CalendarView Rows Handling
extension CalendarView {
    
    fileprivate var visibleEventRows: [EventsRowView] {
        var rows: [EventsRowView] = []
        if let visibleRange = visibleDays {
            eventRowsCache.forEach({ date, rowView in
                if visibleRange.contains(date: date) {
                    rows.append(rowView)
                }
            })
        }
        return rows
    }
    
    fileprivate func clearRowsCacheInDateRange(_ range: DateRange?) {
        if let range = range {
            eventRowsCache.forEach({ date, rowView in
                if range.contains(date: date) {
                    removeRowAtDate(date)
                }
            })
        } else {
            eventRowsCache.forEach({ date, rowView in
                removeRowAtDate(date)
            })
        }
    }
    
    fileprivate func removeRowAtDate(_ date: Date) {
        if let remove = eventRowsCache.removeValue(forKey: date) {
            reuseQueue.enqueueReusableObject(remove)
        }
    }
    
    fileprivate func eventsRowViewAtDate(_ rowStart: Date) -> EventsRowView {
        var eventsRowView = eventRowsCache.value(forKey: rowStart)
        if eventsRowView == nil {
            eventsRowView = reuseQueue.dequeueReusableObjectWithIdentifier("EventsRowViewIdentifier") as! EventsRowView?
            let referenceDate = calendar.startOfMonthForDate(rowStart)
            let first = calendar.dateComponents([.day], from: referenceDate, to: rowStart).day
            if let range = calendar.range(of: .day, in: .weekOfMonth, for: rowStart) {
                let numDays = range.upperBound - range.lowerBound
                
                eventsRowView?.referenceDate = referenceDate
                eventsRowView?.maxVisibleLines = maxVisibleEvents
                eventsRowView?.itemHeight = eventViewHeight
                eventsRowView?.eventsRowDelegate = self
                eventsRowView?.daysRange = NSMakeRange(first!, numDays)
                eventsRowView?.dayWidth = bounds.width / 7
                
                eventsRowView?.reload()
            }
        }
        
        cacheRow(eventsRowView!, forDate: rowStart)
        
        return eventsRowView!
    }
    
    fileprivate func cacheRow(_ eventsView: EventsRowView, forDate date: Date) {
        eventRowsCache.updateValue(eventsView, forKey: date)
        
        if eventRowsCache.count >= rowCacheSize {
            if let first = eventRowsCache.first?.0 {
                removeRowAtDate(first)
            }
        }
    }
    
    fileprivate func monthRowViewAtIndexPath(_ indexPath: IndexPath) -> MonthWeekView {
        let rowStart = dateForDayAtIndexPath(indexPath)
        var rowView: MonthWeekView!
        var dequeued: Bool = false
        while !dequeued {
            guard let weekView = self.dequeueReusableSupplementaryView(ofKind: MonthWeekView.kind, withReuseIdentifier: MonthWeekView.identifier, for: indexPath) as? MonthWeekView else {
                fatalError()
            }
            rowView = weekView
            if !visibleEventRows.contains(rowView.eventsView) {
                dequeued = true
            }
        }
        
        let eventsView = eventsRowViewAtDate(rowStart)
        
        rowView.eventsView = eventsView
        return rowView!
    }
}


// MARK: - CalendarLayoutDelegate
extension CalendarView: CalendarLayoutDelegate {
    
    
    /// Select cell item from date manually.
    public func selectDayCell(at date: Date) {
        // select cells
        guard let indexPath = indexPathForDate(date) else { return }
        self.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
        self.collectionView(self, didSelectItemAt: indexPath)
        
    }
    
    /// Deselect cell item of selecting indexPath manually.
    public func deselectDayCells() {
        // deselect cells
        self.indexPathsForSelectedItems?.forEach {
            self.deselectItem(at: $0, animated: false)
        }
    }
    
    // MARK: - YMCalendarLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout: CalendarLayout, columnForDayAtIndexPath indexPath: IndexPath) -> Int {
        return columnForDayAtIndexPath(indexPath)
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = dateForDayAtIndexPath(indexPath)
        self.calendarDelegate?.calendarView?(self, didSelectDayCellAtDate: date)
        
        collectionView.layoutIfNeeded()
        
        if allowsMultipleSelection {
            if let hasSelectedIndex = selectedDates.index(of: date) {
                // if indexPath has been selected, deselect it.
                if let index = indexPathForDate(selectedDates[hasSelectedIndex]),
                    let deselectCell = collectionView.cellForItem(at: index) as? MonthDayCollectionCell {
                    deselectCell.deselect(withAnimation: deselectAnimation)
                }
                selectedDates.remove(at: hasSelectedIndex)
            } else {
                // animate select cell
                selectedDates.append(date)
                if let selectedCell = collectionView.cellForItem(at: indexPath) as? MonthDayCollectionCell {
                    selectedCell.select(withAnimation: selectAnimation)
                }
            }
        } else {
            var needsReload = false
            
            // deselect all selected dates
            selectedDates.forEach {
                if let index = indexPathForDate($0),
                    let deselectCell = collectionView.cellForItem(at: index) as? MonthDayCollectionCell {
                    deselectCell.deselect(withAnimation: deselectAnimation)
                } else {
                    // if collectionView couldn't find cell by cellForItem(at:_),
                    // should reload() in completion after animation.
                    needsReload = true
                }
            }
            selectedDates = [date]
            
            // animate select cell
            if let selectedCell = collectionView.cellForItem(at: indexPath) as? MonthDayCollectionCell {
                selectedCell.select(withAnimation: selectAnimation) { _ in
                    if needsReload {
                        self.reload()
                    }
                }
            }
        }
    }
}

// MARK: - EventsRowViewDelegate
extension CalendarView: EventsRowViewDelegate {
    
    func eventsRowView(_ view:  EventsRowView, numberOfEventsForDayAtIndex day: Int) -> Int {
        var comps = DateComponents()
        comps.day = day
        guard let date = calendar.date(byAdding: comps, to: view.referenceDate),
            let count = self.calendarDataSource?.calendarView(self, numberOfEventsAtDate: date) else {
                return 0
        }
        return count
    }
    
    func eventsRowView(_ view:  EventsRowView, rangeForEventAtIndexPath indexPath: IndexPath) -> NSRange {
        var comps = DateComponents()
        comps.day = indexPath.section
        guard let date = calendar.date(byAdding: comps, to: view.referenceDate),
            let dateRange = self.calendarDataSource?.calendarView(self, dateRangeForEventAtIndex: indexPath.item, date: date) else {
                return NSRange()
        }
        
        let start = max(0, calendar.dateComponents([.day], from: view.referenceDate, to: dateRange.start).day!)
        var end = calendar.dateComponents([.day], from: view.referenceDate, to: dateRange.end).day!
        if dateRange.end.timeIntervalSince(calendar.startOfDay(for: dateRange.end)) >= 0 {
            end += 1
        }
        end = min(end, NSMaxRange(view.daysRange))
        return NSMakeRange(start, end - start)
    }
    
    func eventsRowView(_ view:  EventsRowView, cellForEventAtIndexPath indexPath: IndexPath) ->  EventView  {
        var comps = DateComponents()
        comps.day = indexPath.section
        guard let date = calendar.date(byAdding: comps, to: view.referenceDate),
            let eventView = self.calendarDataSource?.calendarView(self, eventViewForEventAtIndex: indexPath.item, date: date) else {
                fatalError()
        }
        return eventView
    }
    
    func eventsRowView(_ view:  EventsRowView, shouldSelectCellAtIndexPath indexPath: IndexPath) -> Bool {
        if !allowsSelection {
            return false
        }
        var comps = DateComponents()
        comps.day = indexPath.section
        guard let date = calendar.date(byAdding: comps, to: view.referenceDate),
            let shouldSelect = self.calendarDelegate?.calendarView?(self, shouldSelectEventAtIndex: indexPath.item, date: date) else {
                return true
        }
        return shouldSelect
    }
    
    func eventsRowView(_ view:  EventsRowView, didSelectCellAtIndexPath indexPath: IndexPath) {
        deselectEventWithDelegate(true)
        
        var comps = DateComponents()
        comps.day = indexPath.section
        guard let date = calendar.date(byAdding: comps, to: view.referenceDate) else {
            return
        }
        
        selectedEventDate = date
        selectedEventIndex = indexPath.item
        
        self.calendarDelegate?.calendarView?(self, didSelectEventAtIndex: indexPath.item, date: date)
    }
    
    func eventsRowView(_ view:  EventsRowView, shouldDeselectCellAtIndexPath indexPath: IndexPath) -> Bool {
        if !allowsSelection {
            return false
        }
        var comps = DateComponents()
        comps.day = indexPath.section
        guard let date = calendar.date(byAdding: comps, to: view.referenceDate),
            let shouldDeselect = self.calendarDelegate?.calendarView?(self, shouldDeselectEventAtIndex: indexPath.item, date: date) else {
                return true
        }
        return shouldDeselect
    }
    
    func eventsRowView(_ view:  EventsRowView, didDeselectCellAtIndexPath indexPath: IndexPath) {
        var comps = DateComponents()
        comps.day = indexPath.section
        guard let date = calendar.date(byAdding: comps, to: view.referenceDate) else {
            return
        }
        if selectedEventDate == date && indexPath.item == selectedEventIndex {
            selectedEventDate = nil
            selectedEventIndex = 0
        }
        
        self.calendarDelegate?.calendarView?(self, didDeselectEventAtIndex: indexPath.item, date: date)
    }
}
