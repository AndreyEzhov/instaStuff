//
//  StuffPlace.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 10.03.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class StuffPlace: UIImageView, TemplatePlaceble {
    
    // MARK: - Properties
    
    let storyEditableStuffItem: StoryEditableStuffItem
    
    var storyEditableItem: StoryEditableItem {
        return storyEditableStuffItem
    }
    
    // MARK: - Construction
    
    init(_ item: StoryEditableStuffItem) {
        storyEditableStuffItem = item
        super.init(frame: .zero)
        image = storyEditableStuffItem.stuffItem.stuffImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
