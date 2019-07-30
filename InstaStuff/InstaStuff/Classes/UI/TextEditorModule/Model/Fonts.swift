//
//  Fonts.swift
//  InstaStuff
//
//  Created by aezhov on 27/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

enum FontEnum: String, CaseIterable {
    case cheque, solena, journalism, chalkboardSE, didot, futura, baskerville
    
    var name: String {
        switch self {
        case .cheque:
            return "CHEQUE"
        case .solena:
            return "Solena"
        case .journalism:
            return "Journalism"
        case .chalkboardSE:
            return "Chalkboard SE"
        case .didot:
            return "Didot"
        case .futura:
            return "Futura"
        case .baskerville:
            return "Baskerville"
        }
    }
}

enum Aligment: Int {
    case left, center, right
}

extension Aligment: CaseIterable {
    var image: UIImage {
        switch self {
        case .left:
            return #imageLiteral(resourceName: "leftAlignment")
        case .right:
            return #imageLiteral(resourceName: "rightAlignment")
        case .center:
            return #imageLiteral(resourceName: "centerAlignment")
        }
    }
    
    var textAlignment: NSTextAlignment {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        case .center:
            return .center
        }
    }
}
