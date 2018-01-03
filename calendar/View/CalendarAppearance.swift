//
//  CalendarAppearance.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 22..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation
import UIKit

public protocol CalendarAppearance: class {
    func horizontalGridColor(in view: UICollectionView) -> UIColor
    func horizontalGridWidth(in view: UICollectionView) -> CGFloat
    func verticalGridColor(in view: UICollectionView) -> UIColor
    func verticalGridWidth(in view: UICollectionView) -> CGFloat
    
    func dayLabelAlignment(in view: UICollectionView) -> DayLabelAlignment
    func calendarViewAppearance(_ view: UICollectionView, dayLabelFontAtDate date: Date) -> UIFont
    func calendarViewAppearance(_ view: UICollectionView, dayLabelTextColorAtDate date: Date) -> UIColor
    func calendarViewAppearance(_ view: UICollectionView, dayLabelBackgroundColorAtDate date: Date) -> UIColor
    func calendarViewAppearance(_ view: UICollectionView, dayLabelSelectedTextColorAtDate date: Date) -> UIColor
    func calendarViewAppearance(_ view: UICollectionView, dayLabelSelectedBackgroundColorAtDate date: Date) -> UIColor
}

extension CalendarAppearance {
    public func horizontalGridColor(in view: UICollectionView) -> UIColor {
        return .black
    }
    
    public func horizontalGridWidth(in view: UICollectionView) -> CGFloat {
        return 0.3
    }
    
    public func verticalGridColor(in view: UICollectionView) -> UIColor {
        return .black
    }
    
    public func verticalGridWidth(in view: UICollectionView) -> CGFloat {
        return 0.3
    }
    
    public func dayLabelAlignment(in view: UICollectionView) -> DayLabelAlignment {
        return .left
    }
    
    public func calendarViewAppearance(_ view: UICollectionView, dayLabelFontAtDate date: Date) -> UIFont {
        return .systemFont(ofSize: 10.0)
    }
    
    public func calendarViewAppearance(_ view: UICollectionView, dayLabelTextColorAtDate date: Date) -> UIColor {
        return .black
    }
    
    public func calendarViewAppearance(_ view: UICollectionView, dayLabelBackgroundColorAtDate date: Date) -> UIColor {
        return .clear
    }
    
    public func calendarViewAppearance(_ view: UICollectionView, dayLabelSelectedTextColorAtDate date: Date) -> UIColor {
        return .white
    }
    
    public func calendarViewAppearance(_ view: UICollectionView, dayLabelSelectedBackgroundColorAtDate date: Date) -> UIColor {
        return .black
    }
}

