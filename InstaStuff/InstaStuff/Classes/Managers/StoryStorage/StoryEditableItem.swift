//
//  StoryPhotoItem.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 03.03.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift

class StoryEditableItem {
    
    let settings: Settings
    
    fileprivate init(_ settings: Settings) {
        self.settings = settings
    }
    
}

struct EditableTransform {
    var currentTranslation: CGPoint = .zero
    
    var currentRotation: CGFloat = 0
    
    var currentScale: CGFloat = 1
    
    var transform: CGAffineTransform {
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: currentTranslation.x, y: currentTranslation.y)
        transform = transform.rotated(by: currentRotation)
        transform = transform.scaledBy(x: currentScale, y: currentScale)
        return transform
    }
    
    mutating func identity() {
        currentTranslation = .zero
        currentRotation = 0
        currentScale = 1
    }
}

class StoryEditablePhotoItem: StoryEditableItem {
    
    let photoItem: PhotoItem
    
    let image: BehaviorSubject<UIImage?>
    
    var editablePhotoTransform = EditableTransform()
    
    init(_ photoItem: PhotoItem, settings: Settings) {
        image = BehaviorSubject(value: nil)
        self.photoItem = photoItem
        super.init(settings)
    }
    
    func update(image: UIImage?) {
        editablePhotoTransform.identity()
        self.image.onNext(image)
    }
    
}

class StoryEditableTextItem: StoryEditableItem {
    
    let textItem: TextItem
    
    let text: BehaviorSubject<String>
    
    init(_ textItem: TextItem, settings: Settings) {
        self.textItem = textItem
        text = BehaviorSubject(value: textItem.defautText)
        super.init(settings)
    }
    
}

class StoryEditableStuffItem: StoryEditableItem {
    
    let stuffItem: StuffItem
    
    init(_ stuffItem: StuffItem, settings: Settings) {
        self.stuffItem = stuffItem
        super.init(settings)
    }
}
