//
//  StorySlide.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class StoryItem {
    
    // MARK: - Properties
    
    let template: FrameTemplate
    
    let items: [StoryEditableItem]
    
    // MARK: - Construction
    
    init(template: FrameTemplate) {
        self.template = template
        items = template.frameAreas.map {
            switch $0.frameArea {
            case .photoFrame(let photoItem, let customSettings):
                return StoryEditablePhotoItem(photoItem, customSettings: customSettings, settings: $0.settings)
            case .textFrame(let textItem):
                return StoryEditableTextItem(textItem, settings: $0.settings)
            case .stuffFrame(let stuffItem):
                return StoryEditableStuffItem(stuffItem, settings: $0.settings)
            case .viewFrame(let viewItem):
                return StoryEditableViewItem(viewItem, settings: $0.settings)
            }
        }
    }
    
}
