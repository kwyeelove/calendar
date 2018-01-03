//
//  MonthWeekReusableView.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import UIKit

final internal class MonthWeekReusableView: UICollectionReusableView, CollectionReusable {
    
    var eventsView = EventsRowView(frame: .zero) {
        didSet {
            oldValue.removeFromSuperview()
            addSubview(eventsView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        addSubview(eventsView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        eventsView.frame = bounds
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
}
