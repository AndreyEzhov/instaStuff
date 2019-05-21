//
//  Consts+Custom.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

extension Consts {
    
    struct UIGreed {
        static let editButtonsSize: CGFloat = 30
        
        static let photoRatio: CGFloat = 9.0 / 16.0
        
        static let screenWidth: CGFloat = 1080
        
        static let screenHeight: CGFloat = 1920
        
        static let safeInsets: CGFloat = ((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0))
        
        static let safeAreaInsetsBottom: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    struct Colors {
        
        static let applicationColor = Colors.r248g242b236
        
        static let applicationColorSelected = Colors.r219g192b178
        
        static let applicationTintColor = UIColor.black
        
        static let photoplaceColor = Colors.r219g219b219
        
        static let keyboardColor = #colorLiteral(red: 0.8235294118, green: 0.8352941176, blue: 0.8588235294, alpha: 1)
        
        static let text = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        
        static let r248g242b236 = #colorLiteral(red: 0.9725490196, green: 0.9490196078, blue: 0.9254901961, alpha: 1)
        
        static let r112g112b112 = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        
        static let r219g192b178 = #colorLiteral(red: 0.8588235294, green: 0.7529411765, blue: 0.6980392157, alpha: 1)
        
        static let r219g219b219 = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
        
    }
}
