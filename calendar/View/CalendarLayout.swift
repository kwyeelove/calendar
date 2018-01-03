//
//  CalendarLayout.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import UIKit

class CalendarLayout: UICollectionViewLayout {
    
    typealias AttrDict = [IndexPath : UICollectionViewLayoutAttributes]
    
    // 달력의 스크롤 방향을 결정하는 변수
    private var scrollDirection: ScrollDirection
    //
    private var layoutAttrDict: [String:AttrDict] = [:]
    //
    weak var delegate: CalendarLayoutDelegate!
    
    var dayHeaderHeight: CGFloat = 18.0
    var contentSize: CGSize = .zero
    
    init(scrollDirection: ScrollDirection) {
        self.scrollDirection = scrollDirection
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.scrollDirection = .horizontal
        super.init(coder: aDecoder)
    }
    
    fileprivate func widthForColumnRange(_ range: NSRange) -> CGFloat {
        let availableWidth = collectionView?.bounds.size.width ?? 300
        let columnWidth = availableWidth / 7
        
        if NSMaxRange(range) == 7 {
            return availableWidth - columnWidth * CGFloat((7 - range.length))
        }
        return columnWidth * CGFloat(range.length)
    }
    
    fileprivate func columnWidth(colIndex: Int) -> CGFloat {
        return widthForColumnRange(NSRange(location: colIndex, length: 1))
    }

    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        let numberOfMonths = collectionView.numberOfSections
        
        var monthsAttrDict: AttrDict = [:]
        var dayCellsAttrDict: AttrDict = [:]
        var rowsAttrDict: AttrDict = [:]
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for month in 0..<numberOfMonths {
            /// which column is first day of month from left
            var col: Int = delegate.collectionView(collectionView, layout: self, columnForDayAtIndexPath: IndexPath(item: 0, section: month))
            let numberOfdaysInMonth: Int = collectionView.numberOfItems(inSection: month)
            let numberOfRows = Int(ceil(Double(col + numberOfdaysInMonth) / 7.0))
            let rowHeight = collectionView.bounds.height / CGFloat(numberOfRows)
            var day: Int = 0
            
            var monthRect = CGRect()
            monthRect.origin = CGPoint(x: x, y: y)
            
            for _ in 0..<numberOfRows {
                let colRange = NSMakeRange(col, min(7 - col, numberOfdaysInMonth - day))
                let path = IndexPath(item: day, section: month)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: MonthWeekReusableView.kind, with: path)
                let width = widthForColumnRange(NSRange(location: col, length: colRange.length))
                
                // difference of scrollDirection is x-postition of frame.
                if scrollDirection == .vertical {
                    // In vertical, x-postion of rowViews must be between 0 ~ bouds.width.
                    let px: CGFloat = widthForColumnRange(NSRange(location: 0, length: col))
                    attributes.frame = CGRect(x: px, y: y + dayHeaderHeight + 4, width: width, height: rowHeight - dayHeaderHeight - 4)
                } else {
                    let width = widthForColumnRange(NSRange(location: col, length: colRange.length))
                    // In horizontal, x-position will be between 0 ~ contentSize.width.
                    // `var x` represents left edge of its month.
                    attributes.frame = CGRect(x: x + widthForColumnRange(NSRange(location: 0, length: col)), y: y + dayHeaderHeight + 4, width: width, height: rowHeight - dayHeaderHeight - 4)
                }
                attributes.zIndex = 1
                rowsAttrDict.updateValue(attributes, forKey: path)
                
                while col < NSMaxRange(colRange) {
                    let path = IndexPath(item: day, section: month)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: path)
                    
                    let px: CGFloat
                    if scrollDirection == .vertical {
                        px = widthForColumnRange(NSRange(location: 0, length: col))
                    } else {
                        px = widthForColumnRange(NSRange(location: 0, length: col)) + x
                    }
                    
                    let width = widthForColumnRange(NSRange(location: col, length: 1))
                    attributes.frame = CGRect(x: px, y: y, width: width, height: rowHeight)
                    dayCellsAttrDict.updateValue(attributes, forKey: path)
                    
                    col += 1
                    day += 1
                }
                
                y += rowHeight
                col = 0
            }
            
            if scrollDirection == .vertical {
                monthRect.size = CGSize(width: collectionView.bounds.size.width, height: y - monthRect.origin.y)
            } else {
                x += collectionView.bounds.size.width
                y = 0
                
                monthRect.size = CGSize(width: x - monthRect.origin.x, height: collectionView.bounds.height)
            }
            
            let path = IndexPath(item: 0, section: month)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: MonthBackgroundView.kind, with: path)
            attributes.frame = monthRect
            attributes.zIndex = 0
            monthsAttrDict.updateValue(attributes, forKey: path)
        }
        
        if scrollDirection == .vertical {
            x = collectionView.bounds.width
        } else {
            y = collectionView.bounds.height
        }
        contentSize = CGSize(width: x, height: y)
        
        collectionView.contentInset = .zero
        
        layoutAttrDict.updateValue(dayCellsAttrDict, forKey: "DayCellAttrDict")
        layoutAttrDict.updateValue(monthsAttrDict, forKey: "MonthsAttrDict")
        layoutAttrDict.updateValue(rowsAttrDict, forKey: "WeekAttrDict")
    }
}
