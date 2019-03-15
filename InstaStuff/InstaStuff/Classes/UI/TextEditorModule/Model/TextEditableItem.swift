//
//  TextEditableItem.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

enum EdibleField {
    case slider
    case values
}

struct TextEditableItem {
    
    let imageName: String
    
    let fieldType: EdibleField
    
    var selectedImage: UIImage? {
        return UIImage(named: imageName + "_selected")
    }
    
    var dafaultImage: UIImage? {
        return UIImage(named: imageName + "_default")
    }
    
    static var defaultSet: [TextEditableItem] {
        return [TextEditableItem(imageName: "backgroundColor", fieldType: .slider),
                TextEditableItem(imageName: "alignmentLeft", fieldType: .slider),
                TextEditableItem(imageName: "bold", fieldType: .slider),
                TextEditableItem(imageName: "fontColor", fieldType: .slider),
                TextEditableItem(imageName: "fontSize", fieldType: .slider),
                TextEditableItem(imageName: "letterSpacing", fieldType: .slider),
                TextEditableItem(imageName: "rowSpacing", fieldType: .slider),
                TextEditableItem(imageName: "backgroundColor", fieldType: .slider),
                TextEditableItem(imageName: "alignmentLeft", fieldType: .slider),
                TextEditableItem(imageName: "bold", fieldType: .slider)]
    }
    
}
