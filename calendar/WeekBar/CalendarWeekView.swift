//
//  CalendarWeekView.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import UIKit

public class CalendarWeekView: UIView {
    // week view의 각종 설정(높이, 색상, 폰트 등)을 위한 delegate
    public var appearance : CalendarWeekBarAppearance?
    
    public var calendar = Calendar.current {
        didSet {
            setNeedsLayout()
        }
    }
    
    // 요일 Text를 표기하는 Label 배열
    private var weekdayLabels: [UILabel] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        weekViewInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        weekViewInit()
    }
    
    private func weekViewInit() {
        backgroundColor = .white
        
        for _ in 0..<7 {
            let label = UILabel()
            label.textAlignment = .center
            label.lineBreakMode = .byClipping
            weekdayLabels.append(label)
            addSubview(label)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let colWidth = bounds.width / 7                     // 요일별 '열'의 width 계산
        let firstWeekday = calendar.firstWeekday            // 현재시점의 달력 첫째날 (1일)
        
        for i in 0..<weekdayLabels.count {
            var weekDay = firstWeekday + i
            // 7의 배수를 만들기
            if weekDay > 7 {
                weekDay %= 7
            }
            
            let x = CGFloat.init(i) * colWidth + colWidth / 2
            let y = bounds.height / 2
            let center = CGPoint(x: x, y: y)
            
            weekdayLabels[i].frame.size = CGSize(width: colWidth, height: bounds.height)
            weekdayLabels[i].center = center
            
            let appearance = self.appearance
            // 요일별 글자, 색상 설정
            weekdayLabels[i].text = appearance?.calendarWeekBarView(self, textAtWeekday: weekDay)
            weekdayLabels[i].textColor = appearance?.calendarWeekBarView(self, textColorAtWeekday: weekDay)
            
            // 요일별 폰트, Bg 설정
            weekdayLabels[i].backgroundColor = appearance?.calendarWeekBarView(self, backgroundColorAtWeekday: weekDay)
            weekdayLabels[i].font = appearance?.calendarWeekBarView(self, fontAtWeekday: weekDay)
            
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // ==============================================
        // 격자 무늬 그리기 시작
        let currentContext = UIGraphicsGetCurrentContext()
        
        let colWidth = rect.width / 7
        let rowHeight = rect.height
        
        var x1: CGFloat
        var x2: CGFloat
        var y1: CGFloat
        var y2: CGFloat
        
        let appearance = self.appearance
        
        
        // row선 그리기 : width가 0 이상일 경우에만..
        let horizontalGridWidth = appearance?.weekBarHorizontalGridWidth(in: self)
        if Int(horizontalGridWidth!) > 0 {
            
            currentContext?.setStrokeColor((appearance?.weekBarHorizontalGridColor(in: self).cgColor)!)
            currentContext?.setLineWidth(horizontalGridWidth!)
            currentContext?.beginPath()
            
            for y in 0...2 {
                x1 = 0
                x2 = rect.width
                
                y1 = rowHeight * CGFloat(y)
                y2 = y1
                
                currentContext?.move(to: CGPoint(x: x1, y: y1))
                currentContext?.addLine(to: CGPoint(x: x2, y: y2))
            }
            currentContext?.strokePath()
        }
        
        let verticalGridWidth = appearance?.weekBarVerticalGridWidth(in: self)
        
        if Int(verticalGridWidth!) > 0 {
            currentContext?.setStrokeColor((appearance?.weekBarVerticalGridColor(in: self).cgColor)!)
            currentContext?.setLineWidth(verticalGridWidth!)
            currentContext?.beginPath()
            
            for x  in 0...7 {
                x1 = colWidth * CGFloat(x)
                x2 = x1
                
                y1 = 0
                y2 = rect.height
                
                currentContext?.move(to: CGPoint(x: x1, y: y1))
                currentContext?.addLine(to: CGPoint(x: x2, y: y2))
            }
            currentContext?.strokePath()
        }
    }
    
    

}
















