//
//  CalendarSettings.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation
import UIKit


public enum DayLabelAlignment {
    case left, center, right
}

public enum ScrollDirection {
    case horizontal
    case vertical
}

public enum SelectAnimation {
    case none, bounce, fade
}

let WEEK_SYMBOLE = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
let WEEK_VIEW_HORIZONTAL_GRID_WIDTH: CGFloat      = 0.3
let WEEK_VIEW_VERTICAL_GRID_WIDTH : CGFloat        = 0.3

