//
//  TextSetups.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

struct TextSetups {
    
    struct TextType: OptionSet {
        let rawValue: Int
        
        static let bold = TextType(rawValue: 1 << 0)
        static let italic = TextType(rawValue: 1 << 1)
    }

    let textType: TextType

}
