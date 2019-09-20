//
//  DataToCoreData.swift
//  InstaStuff
//
//  Created by aezhov on 05/08/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import CoreData

extension TemplatesStorage {
    
    func dataToPhotoFrameInTemplate(itemId: Int, centerX: CGFloat, centerY: CGFloat, angle: CGFloat, widthScale: CGFloat, applyScale: Bool = true, photoName: String?, context: NSManagedObjectContext) -> CDPhotoFrameInTemplate {
        let frameInTemplate = CDPhotoFrameInTemplate(context: context)
        frameInTemplate.photoName = photoName
        frameInTemplate.itemId = Int64(itemId)
        let settings = generateSettings(centerX: centerX, centerY: centerY, angle: angle, widthScale: widthScale, applyScale: applyScale, context: context)
        frameInTemplate.settings = settings
        return frameInTemplate
    }
    
    func photoFrame(itemId: Int, ratio: CGFloat, frameName: String?, isShape: Bool, context: NSManagedObjectContext) -> CDPhotoFrameItem {
        
        let photoFrame = CDPhotoFrameItem(context: context)
        
        photoFrame.frameImageName = frameName
        photoFrame.ratio = Float(ratio)
        photoFrame.id = Int64(itemId)
        photoFrame.isShape = isShape
        return photoFrame
    }
    
    func photoFrameSettings(centerX: CGFloat, centerY: CGFloat, angle: CGFloat, widthScale: CGFloat, ratio: CGFloat, round: CGFloat, context: NSManagedObjectContext) -> CDPhotoFrameSettings {
        let photoFrameSettings = CDPhotoFrameSettings(context: context)
        photoFrameSettings.midX = Float(centerX)
        photoFrameSettings.midY = Float(centerY)
        photoFrameSettings.angle = Float(angle)
        photoFrameSettings.width = Float(widthScale)
        photoFrameSettings.ratio = Float(ratio)
        photoFrameSettings.round = Float(round)
        return photoFrameSettings
    }
    
    func dataToTextItemInTemplate(ratio: CGFloat, centerX: CGFloat, centerY: CGFloat, angle: CGFloat, widthScale: CGFloat, applyScale: Bool = true, text: String? = nil, context: NSManagedObjectContext) -> CDTextItemInTemplate {
        
        let textInTemplate = CDTextItemInTemplate(context: context)
        
        textInTemplate.ratio = Float(ratio)
        let settings = generateSettings(centerX: centerX, centerY: centerY, angle: angle, widthScale: widthScale, applyScale: applyScale, context: context)
        
        textInTemplate.settings = settings
        
        return textInTemplate
    }
    
    func generateSettings(centerX: CGFloat, centerY: CGFloat, angle: CGFloat, widthScale: CGFloat, applyScale: Bool = true, context: NSManagedObjectContext) -> CDItemSettings {
        let settings = CDItemSettings(context: context)
        settings.midX = Float(centerX / (applyScale ? 108.0 : 1))
        settings.midY = Float(centerY / (applyScale ? 192.0 : 1))
        settings.angle = Float(angle)
        settings.widthScale = Float(widthScale / (applyScale ? 108.0 : 1))
        return settings
    }
    
    func defaultTextSettings(context: NSManagedObjectContext) -> CDTextSettings {
        return textSettings(aligment: .center, color: .black, backgroundColor: .clear, fontSize: 40, kern: 1, lineSpacing: 1, fontName: .cheque, text: "Type your text", context: context)
    }
    
    func textSettings(aligment: Aligment, color: UIColor, backgroundColor: UIColor, fontSize: CGFloat, kern: CGFloat, lineSpacing: CGFloat, fontName: FontEnum, text: String, context: NSManagedObjectContext) -> CDTextSettings {
        
        let textSettings = CDTextSettings(context: context)
        textSettings.aligment = Int64(aligment.rawValue)
        textSettings.backgroundColor = backgroundColor
        textSettings.color = color
        textSettings.fontSize = Float(fontSize)
        textSettings.kern = Float(kern)
        textSettings.lineSpacing = Float(lineSpacing)
        textSettings.fontName = fontName.rawValue
        textSettings.text = text
        
        return textSettings
    }
    
    func stuffInTemplate(itemId: Int, centerX: CGFloat, centerY: CGFloat, angle: CGFloat, widthScale: CGFloat, applyScale: Bool = true, context: NSManagedObjectContext) -> CDStuffItemInTemplate {
        let stuffInTemplate = CDStuffItemInTemplate(context: context)
        stuffInTemplate.itemId = Int64(itemId)
        
        let settings = generateSettings(centerX: centerX, centerY: centerY, angle: angle, widthScale: widthScale, applyScale: applyScale, context: context)
        
        stuffInTemplate.settings = settings
        
        return stuffInTemplate
    }
    
}
