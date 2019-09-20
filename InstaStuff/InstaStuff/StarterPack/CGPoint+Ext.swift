//
//  CGPoint+Ext.swift
//  InstaStuff
//
//  Created by aezhov on 19/09/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

extension CGPoint {
    
    static public func +=(left: inout CGPoint, right: CGPoint) {
        left = CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}


extension CGSize {
    var ratio: CGFloat {
        return width / height
    }
}
