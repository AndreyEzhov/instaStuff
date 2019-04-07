//
//  ViewPlace.swift
//  InstaStuff
//
//  Created by aezhov on 07/04/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class ViewPlace: UIView, TemplatePlaceble {
    
    // MARK: - Properties
    
    let storyEditableViewItem: StoryEditableViewItem
    
    var storyEditableItem: StoryEditableItem {
        return storyEditableViewItem
    }
    
    // MARK: - Construction
    
    init(_ item: StoryEditableViewItem) {
        storyEditableViewItem = item
        super.init(frame: .zero)
        backgroundColor = item.viewItem.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
