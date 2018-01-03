//
//  ReusableObject.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation

public protocol ReusableObject: class {
    
    init()
    
    var reuseIdentifier: String { get set }
    
    func prepareForReuse()
}
