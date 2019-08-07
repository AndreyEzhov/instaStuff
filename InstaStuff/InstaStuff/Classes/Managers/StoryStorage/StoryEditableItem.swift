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
    
    override var ratio: CGFloat? {
        return photoItem.ratio
    }
    
    var photoItem: PhotoItem
    
    var customSettings: PhotoItemCustomSettings?
    
    let image: BehaviorSubject<UIImage?>
    
    private var renderedPhoto: UIImage? {
        //        let photoWidth = Consts.UIGreed.screenWidth * photoItem.photoAreaLocation.sizeWidth * settings.sizeWidth
        //        let photoSize = CGSize(width: photoWidth,
        //                               height: photoWidth / photoItem.photoAreaLocation.ratio)
        //        UIGraphicsBeginImageContext(photoSize)
        //
        //        UIColor.white.setFill()
        //        let context = UIGraphicsGetCurrentContext()
        //        context?.fill(CGRect(origin: .zero, size: photoSize))
        //
        //        if let context = UIGraphicsGetCurrentContext(),
        //            let photo = ((try? self.image.value()) as UIImage??), let unwrapedPhoto = photo {
        //            context.translateBy(x: photoSize.width / 2.0 + editablePhotoTransform.currentTranslation.x / scale,
        //                                y: photoSize.height / 2.0 + editablePhotoTransform.currentTranslation.y / scale)
        //            context.rotate(by: editablePhotoTransform.currentRotation)
        //            context.scaleBy(x: editablePhotoTransform.currentScale,
        //                            y: editablePhotoTransform.currentScale)
        //            let minRatio = min(unwrapedPhoto.size.width/photoSize.width, unwrapedPhoto.size.height/photoSize.height)
        //            let size = CGSize(width: unwrapedPhoto.size.width / minRatio, height: unwrapedPhoto.size.height / minRatio)
        //            unwrapedPhoto.draw(in: CGRect(origin: CGPoint(x: -size.width / 2.0, y: -size.height / 2.0), size: size))
        //        }
        //
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //        return image
        return nil
    }
    
    override var renderedImage: UIImage? {
        let frameWidth = Consts.UIGreed.screenWidth * settings.sizeWidth
        let size = CGSize(width: frameWidth, height: frameWidth / photoItem.ratio)
        UIGraphicsBeginImageContext(size)
        photoItem.framePlaceImage?.draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    init(_ photoItem: PhotoItem, customSettings: PhotoItemCustomSettings?, settings: Settings) {
        image = BehaviorSubject(value: nil)
        self.customSettings = customSettings
        self.photoItem = photoItem
        super.init(settings)
    }
    
    func update(image: UIImage?) {
        //editablePhotoTransform.identity()
        self.image.onNext(image)
    }
    
    override func copy() -> StoryEditableItem {
        return StoryEditablePhotoItem(photoItem, customSettings: customSettings, settings: settings)
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
