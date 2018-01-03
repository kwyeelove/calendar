//
//  EventView.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import UIKit

open class EventView: UIView, ReusableObject {

    public var reuseIdentifier: String = ""
    
    public var selected: Bool = false
    
    public var visibleHeight: CGFloat = 0
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
    }
    
    public func prepareForReuse() {
        selected = false
    }

}
