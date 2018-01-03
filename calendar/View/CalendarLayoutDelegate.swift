//
//  CalendarLayoutDelegate.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation
import UIKit

internal protocol CalendarLayoutDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: CalendarLayout, columnForDayAtIndexPath indexPath: IndexPath) -> Int
}
