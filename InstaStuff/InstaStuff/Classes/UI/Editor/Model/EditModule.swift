//
//  EditModule.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class EditModule {

    // MARK: - Properties
    
    let height: CGFloat
    
    let controller: UIViewController
    
    // MARK: - Construction
    
    init(estimatedHeight: CGFloat, controller: UIViewController) {
        height = estimatedHeight
        self.controller = controller
    }
}
