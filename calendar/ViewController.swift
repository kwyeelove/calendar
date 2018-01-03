//
//  ViewController.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 18..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = Date.getToday()
        let calendar = Date.gregorianCalendar()
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
//        todayComponents.month = todayComponents.month! + 1
//        todayComponents.day = 0
        let datePickerDate = calendar.date(from: todayComponents)
        
        self.datePicker.setDate(datePickerDate!, animated: true)
        self.datePicker.locale = Locale.current
        self.datePicker.datePickerMode = .date
        getDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func getDate() {
        
        let today = Date.getToday()
        
        let calendar : Calendar = Date.gregorianCalendar()
        var todayComponents : DateComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        var startComponets = todayComponents
        startComponets.month = (12 - todayComponents.month!) + 1
        startComponets.day = 0
        
        var endComponets = todayComponents
        endComponets.month = ((12 - todayComponents.month!) + todayComponents.month!) + 1
        endComponets.day = 0
        
        let startDate = calendar.date(from: startComponets)
        let endDate = calendar.date(from: endComponets)
        
        print("\n today = \(startDate?.description) \n lastDay = \(endDate?.description)")
    }
    
    @IBAction func showCalendar(button: UIButton) {
        
    }
}

