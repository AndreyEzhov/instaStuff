//
//  StorySlide.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class StorySlide {
    
    // MARK: - Properties
    
    let template: FrameTemplate
    
    let items: [StoryEditableItem]
    
    // MARK: - Construction
    
    init(template: FrameTemplate) {
        self.template = template
        items = template.frameAreas.map {
            switch $0.frameArea {
            case .photoFrame(let photoItem):
                return StoryEditablePhotoItem(photoItem, settings: $0.settings)
            case .textFrame(let textItem):
                return StoryEditableTextItem(textItem, settings: $0.settings)
            case .stuffFrame(let stuffItem):
                return StoryEditableStuffItem(stuffItem, settings: $0.settings)
            }
        }
    }
    
}
