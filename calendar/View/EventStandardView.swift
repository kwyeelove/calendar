//
//  EventStandardView.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 28..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation
import UIKit

public class EventStandardView: EventView {
    
    private let kSpace: CGFloat = 2
    
    public var title: String = ""
    
    public var textColor: UIColor = .white
    
    public var font: UIFont = .systemFont(ofSize: 12.0)
    
    public var attrString = NSMutableAttributedString()
    
    public var baselineOffset: Float = 0.0
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        setNeedsDisplay()
    }
    
    override public func draw(_ rect: CGRect) {
        let drawRect = rect.insetBy(dx: kSpace, dy: 0)
        redrawStringInRect(drawRect)
        
        attrString.draw(with: drawRect, options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin], context: nil)
    }

    private func redrawStringInRect(_ rect: CGRect) {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byClipping
        
        let attributedString = NSMutableAttributedString(string: title,
                                                         attributes: [
                                                            NSAttributedStringKey.font : font,
                                                            NSAttributedStringKey.paragraphStyle : style,
                                                            NSAttributedStringKey.foregroundColor : textColor,
                                                            NSAttributedStringKey.baselineOffset : baselineOffset])
        
        attrString = attributedString
    }
    
}
