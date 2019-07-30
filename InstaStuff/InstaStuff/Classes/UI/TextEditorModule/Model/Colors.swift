//
//  Colors.swift
//  InstaStuff
//
//  Created by aezhov on 27/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

enum ColorEnum {
    
    static let allCases: [ColorEnum] = [.white, .r206g181b141, .r248g229b210, .r227g220b184, .r219g192b178, .r186g142b105, .r150g174b160, .r80g76b69, .black]
    
    case white, r206g181b141, r248g229b210, r227g220b184, r219g192b178, r186g142b105, r150g174b160, r80g76b69, black
    
    var color: UIColor {
        switch self {
        case .white:
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .r206g181b141:
            return #colorLiteral(red: 0.8078431373, green: 0.7098039216, blue: 0.5529411765, alpha: 1)
        case .r248g229b210:
            return #colorLiteral(red: 0.9725490196, green: 0.8980392157, blue: 0.8235294118, alpha: 1)
        case .r227g220b184:
            return #colorLiteral(red: 0.8901960784, green: 0.862745098, blue: 0.7215686275, alpha: 1)
        case .r219g192b178:
            return #colorLiteral(red: 0.8588235294, green: 0.7529411765, blue: 0.6980392157, alpha: 1)
        case .r186g142b105:
            return #colorLiteral(red: 0.7294117647, green: 0.5568627451, blue: 0.4117647059, alpha: 1)
        case .r150g174b160:
            return #colorLiteral(red: 0.5882352941, green: 0.6823529412, blue: 0.6274509804, alpha: 1)
        case .r80g76b69:
            return #colorLiteral(red: 0.3137254902, green: 0.2980392157, blue: 0.2705882353, alpha: 1)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
}
