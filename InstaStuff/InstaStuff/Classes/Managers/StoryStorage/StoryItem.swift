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
    
    var backgroundImage: UIImage?
    
    var backgroundColor: UIColor
    
    var items: [StoryEditableItem]
    
    // MARK: - Construction
    
    init(template: Template) {
        backgroundImage = template.backgroundImage
        backgroundColor = template.backgroundColor
        items = template.storyEditableItem
    }
    
    // MARK: - Functions
    
    func exportImage() -> UIImage? {
        let width = Consts.UIGreed.screenWidth
        let height = Consts.UIGreed.screenHeight
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        
        backgroundColor.setFill()
        let context = UIGraphicsGetCurrentContext()
        context?.fill(CGRect(origin: .zero, size: size))
        
        backgroundImage?.draw(in: CGRect(origin: .zero, size: size))
        
        items.forEach { item in
            guard let image = item.renderedImage(scale: 1) else {
                return
            }

            var size: CGSize
//            if item is StoryEditableTextItem {
//                size = image.size
//            } else {
                let currentWidth = item.settings.sizeWidth * width
                size = CGSize(width: currentWidth,
                              height: currentWidth * image.size.height / image.size.width)
            //}

            let frame = CGRect(origin: CGPoint(x: -size.width / 2.0, y: -size.height / 2.0), size: size)

            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()
                context.translateBy(x: width * item.settings.center.x,
                                    y: height * item.settings.center.y)
                context.concatenate(CGAffineTransform(rotationAngle: item.settings.angle))
                image.draw(in: frame)
                context.restoreGState()
            }
        }
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return myImage
    }
    
}
