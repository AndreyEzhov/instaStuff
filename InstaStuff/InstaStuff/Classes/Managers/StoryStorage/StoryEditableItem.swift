//
//  StoryPhotoItem.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 03.03.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StoryEditableItem {
    
    var settings: Settings
    
    var ratio: CGFloat? {
        return nil
    }
    
    var renderedImage: UIImage? {
        return nil
    }
    
    fileprivate init(_ settings: Settings) {
        self.settings = settings
    }
    
    func copy() -> StoryEditableItem {
        return StoryEditableItem(settings)
    }
    
}

class StoryEditablePhotoItem: StoryEditableItem {
    // КРИВО
    private static let imageHandler = ImageHandler()
    
    override var ratio: CGFloat? {
        return photoItem.ratio
    }
    
    var photoItem: PhotoItem
    
    var customSettings: PhotoItemCustomSettings?
    
    let imageName: BehaviorRelay<String?>
    
    var image: UIImage? {
        return StoryEditablePhotoItem.imageHandler.loadImage(named: imageName.value)
    }
    
    private func renderedPhoto(size: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        let imageSize: CGSize
        if (size.width / size.height) > (image.size.width / image.size.height) {
            imageSize = CGSize(width: size.width, height: image.size.height / image.size.width * size.width)
        } else {
            imageSize = CGSize(width: image.size.width / image.size.height * size.height, height: size.height)
        }
        
        UIGraphicsBeginImageContext(size)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: photoItem.photoInFrameSettings.round * size.width).addClip()
            context.translateBy(x: size.width / 2.0,
                                y: size.height / 2.0)
            let frame = CGRect(origin: CGPoint(x: -imageSize.width / 2.0,
                                               y: -imageSize.height / 2.0),
                               size: imageSize)
            image.draw(in: frame)
            context.restoreGState()
        }
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    override var renderedImage: UIImage? {
        let frameWidth = Consts.UIGreed.screenWidth * settings.sizeWidth
        let frameHeigth = frameWidth / photoItem.ratio
        let size = CGSize(width: frameWidth, height: frameWidth / photoItem.ratio)
        UIGraphicsBeginImageContext(size)
        
        // Рисуем фотографию
        let photoWidth = frameWidth * photoItem.photoInFrameSettings.sizeWidth
        let photoHeigth = photoWidth / photoItem.photoInFrameSettings.ratio
        let photoSize = CGSize(width: photoWidth, height: photoHeigth)
        if let photo = renderedPhoto(size: photoSize), let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            context.translateBy(x: frameWidth * photoItem.photoInFrameSettings.center.x,
                                y: frameHeigth * photoItem.photoInFrameSettings.center.y)
            context.concatenate(CGAffineTransform(rotationAngle: photoItem.photoInFrameSettings.angle))
            let frame = CGRect(origin: CGPoint(x: -photoSize.width / 2.0,
                                               y: -photoSize.height / 2.0),
                               size: photoSize)
            photo.draw(in: frame)
            context.restoreGState()
        }
        
        photoItem.framePlaceImage?.draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    init(_ photoItem: PhotoItem, customSettings: PhotoItemCustomSettings?, settings: Settings, dafultImageName: String?) {
        imageName = BehaviorRelay(value: dafultImageName)
        self.customSettings = customSettings
        self.photoItem = photoItem
        super.init(settings)
    }
    
    func update(imageName: String?) {
        //editablePhotoTransform.identity()
        self.imageName.accept(imageName)
    }
    
    override func copy() -> StoryEditableItem {
        return StoryEditablePhotoItem(photoItem,
                                      customSettings: customSettings,
                                      settings: settings,
                                      dafultImageName: imageName.value)
    }
    
}

class StoryEditableTextItem: StoryEditableItem {
    
    static var defaultItem: StoryEditableTextItem {
        let settings = Settings(center: CGPoint(x: 0.5, y: 0.6), sizeWidth: 0.8, angle: 0)
        return StoryEditableTextItem(TextItem.defaultTextItem,
                                     settings: settings)
    }
    
    override var ratio: CGFloat? {
        return textItem.ratio
    }
    
    var textItem: TextItem
    
    override var renderedImage: UIImage? {
        let textWidth = Consts.UIGreed.screenWidth * settings.sizeWidth
        let attributes = textItem.textSetups.attributes(with: 1)
        let attributedString = NSAttributedString(string: textItem.textSetups.currentText.value, attributes: attributes)
        var rect = attributedString.boundingRect(with: CGSize(width: textWidth, height: Consts.UIGreed.screenHeight),
                                                 options: .usesLineFragmentOrigin, context: nil)
        rect = CGRect(origin: .zero, size: CGSize(width: textWidth, height: rect.height))
        UIGraphicsBeginImageContext(rect.size)
        attributedString.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    init(_ textItem: TextItem, settings: Settings) {
        self.textItem = textItem
        super.init(settings)
    }
    
    override func copy() -> StoryEditableItem {
        return StoryEditableTextItem(textItem.copy(), settings: settings)
    }
    
}

class StoryEditableStuffItem: StoryEditableItem {
    
    override var renderedImage: UIImage? {
        guard let ratio = ratio, let image = stuffItem.stuffImage else { return nil }
        let width = Consts.UIGreed.screenWidth * settings.sizeWidth
        let size = CGSize(width: width, height: width / ratio)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    override var ratio: CGFloat? {
        guard let image = stuffItem.stuffImage else { return nil }
        return image.size.width / image.size.height
    }
    
    let stuffItem: StuffItem
    
    init(_ stuffItem: StuffItem, settings: Settings) {
        self.stuffItem = stuffItem
        super.init(settings)
    }
    
    override func copy() -> StoryEditableItem {
        return StoryEditableStuffItem(stuffItem, settings: settings)
    }
}

class StoryEditableViewItem: StoryEditableItem {
    
    override var renderedImage: UIImage? {
        //        let width = Consts.UIGreed.screenWidth
        //        let viewWidth = width * settings.sizeWidth
        //        let viewSize = CGSize(width: viewWidth,
        //                              height: viewWidth / settings.ratio)
        //        UIGraphicsBeginImageContext(viewSize)
        //        viewItem.color.setFill()
        //        let context = UIGraphicsGetCurrentContext()
        //        context?.fill(CGRect(origin: .zero, size: viewSize))
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //        return image
        return nil
    }
    
    let viewItem: ViewItem
    
    init(_ viewItem: ViewItem, settings: Settings) {
        self.viewItem = viewItem
        super.init(settings)
    }
}
