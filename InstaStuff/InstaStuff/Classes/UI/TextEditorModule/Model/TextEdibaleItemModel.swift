//
//  TextEdibaleItemModel.swift
//  InstaStuff
//
//  Created by aezhov on 16/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

enum TextEditableItem {
    case bold, italic
    
    var name: String {
        switch self {
        case .bold:
            return "bold"
        case .italic:
            return "italic"
        }
    }
}

class TextEdibaleItemModel {
    
    // MARK: - Properties
    
    let imageName: String
    
    var selectedImage: UIImage? {
        return UIImage(named: imageName + "_selected")
    }
    
    var dafaultImage: UIImage? {
        return UIImage(named: imageName + "_default")
    }
    
    // MARK: - Construction
    
    init(item: TextEditableItem) {
        imageName = item.name
    }
    
}
