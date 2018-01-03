//
//  CollectionReusable.swift
//  calendar
//
//  Created by YeeEmotion on 2017. 12. 26..
//  Copyright © 2017년 YeeEmotion. All rights reserved.
//

import Foundation
import UIKit

internal protocol CollectionReusable {}

extension CollectionReusable where Self: UICollectionReusableView {
    static var kind: String {
        return "\(type(of: self))Kind"
    }
    
    static var identifier: String {
        return "\(type(of: self))Identifier"
    }
    
}
