//
//  CalendarViewController.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 18..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import UIKit

public let KwyeeCalendarStoreKey = "Kwyee.calendar"
public let CALENDAR_VIEW_ID = "CalendarViewController"
private let reuseIdentifier = "BaseballDateCell"

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var calendarWeekView: CalendarWeekView!
    
    // 달력 객채
    var calendar = Calendar.current
    
    // 달력에 선택된 Event Date 객채
    fileprivate var selectedEventDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        // WeekView 설정
        calendarWeekView.appearance = self
        calendarWeekView.calendar = self.calendar
        calendarWeekView.backgroundColor = .white
        
        // Delegate 설정
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        self.calendarView.appearance = self
        
        // 월 달력 설정
        self.calendarView.calendar = self.calendar
        self.calendarView.backgroundColor = .dark
        self.calendarView.scrollDirection = .vertical
        self.calendarView.isPagingEnabled = true
        
        // 이벤트 설정들
        self.calendarView.eventViewHeight = 14
        self.calendarView.registerClass(EventStandardView.self, forEventCellReuseIdentifier: "EventStandardView")
        
        // Register cell classes
//        self.calendarView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK:- CalendarWeekBarAppearance
extension CalendarViewController: CalendarWeekBarAppearance {
    func horizontalGridColor() -> UIColor {
        return .white
    }
    
    func verticalGridColor() -> UIColor {
        return .white
    }
    
    func calendarWeekView(textAtWeekday weekday: Int) -> String {
        return WEEK_SYMBOLE[weekday - 1]
    }
    
    func calendarWeekView(setWeekdayTextColor weekday: Int) -> UIColor {
        switch weekday {
        case 1: // Sun
            return .deeppink
        case 7: // Sat
            return .turquoise
        default:
            return .white
        }
    }
}


// MAKR:- CalendarDelegate
extension CalendarViewController : CalendarDelegate {
    func calendarView(_ view: CalendarView, didSelectDayCellAtDate date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        navigationItem.title = formatter.string(from: date)
    }
}


// MAKR:- CalendarDataSource
extension CalendarViewController : CalendarDataSource {
    func calendarView(_ view: CalendarView, numberOfEventsAtDate date: Date) -> Int {
        if calendar.isDateInToday(date)
            || calendar.isDate(date, inSameDayAs: calendar.endOfDayForDate(date))
            || calendar.isDate(date, inSameDayAs: calendar.startOfMonthForDate(date))  {
            return 1
        }
        return 0
    }
    
    func calendarView(_ view: CalendarView, dateRangeForEventAtIndex index: Int, date: Date) -> DateRange? {
        if calendar.isDateInToday(date)
            || calendar.isDate(date, inSameDayAs: calendar.endOfDayForDate(date))
            || calendar.isDate(date, inSameDayAs: calendar.startOfMonthForDate(date)) {
            return DateRange(start: date, end: calendar.endOfDayForDate(date))
        }
        return nil
    }
    
    func calendarView(_ view: CalendarView, eventViewForEventAtIndex index: Int, date: Date) -> EventView {
        guard let view = view.dequeueReusableCellWithIdentifier("EventStandardView", forEventAtIndex: index, date: date) as? EventStandardView else {
            fatalError()
        }
        
        if calendar.isDateInToday(date) {
            view.title = "today"
        }
        view.textColor = .white
        view.backgroundColor = .seagreen
        
        return view
    }
}


// MARK:- CalendarAppearance
extension CalendarViewController: CalendarAppearance {
    func weekBarHorizontalGridColor(in view: CalendarWeekView) -> UIColor {
        return .white
    }
    
    func weekBarVerticalGridColor(in view: CalendarWeekView) -> UIColor {
        return .white
    }
    
    func dayLabelAlignment(in view: UICollectionView) -> DayLabelAlignment {
        return .center
    }
    
    func calendarViewAppearance(_ view: UICollectionView, dayLabelTextColorAtDate date: Date) -> UIColor {
        let weekday = calendar.component(.weekday, from: date)
        switch weekday {
        case 1: // Sun
            return .deeppink
        case 7: // Sat
            return .turquoise
        default:
            return .white
        }
    }
    
    func calendarViewAppearance(_ view: UICollectionView, dayLabelSelectedTextColorAtDate date: Date) -> UIColor {
        return .white
    }
    
    func calendarViewAppearance(_ view: UICollectionView, dayLabelSelectedBackgroundColorAtDate date: Date) -> UIColor {
        return .deeppink
    }
}












