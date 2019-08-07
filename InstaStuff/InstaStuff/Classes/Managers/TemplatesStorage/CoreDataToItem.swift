//
//  CoreDataToItem.swift
//  InstaStuff
//
//  Created by aezhov on 05/08/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import CoreData

extension TemplatesStorage {
    
    func templateSet(from cdSet: CDSet) -> SetWithTemplates? {
        guard let templatesRaw = cdSet.templates?.array as? [CDTemplate], let name = cdSet.name, let themeColor = cdSet.themeColor as? UIColor, let buyId = cdSet.buyId else {
            return nil
        }
        let templates = templatesRaw.compactMap { (currentTemplate) -> Template? in
            return template(from: currentTemplate)
        }
        return SetWithTemplates(buyId: buyId,
                                themeColor: themeColor,
                                name: name,
                                templates: templates)
    }
    
    
    func frameSettings(from photoFrame: CDPhotoFrameItem) -> PhotoInFrameSettings? {
        guard let settings = photoFrame.photoSettings else { return nil }
        return PhotoInFrameSettings(center: CGPoint(x: CGFloat(settings.midX), y: CGFloat(settings.midY)),
                                    sizeWidth: CGFloat(settings.width),
                                    angle: CGFloat(settings.angle),
                                    ratio: CGFloat(settings.ratio),
                                    round: CGFloat(settings.round))
    }
    
    func template(from currentTemplate: CDTemplate) -> Template? {
        guard let name = currentTemplate.name,
            let backgroundColor = currentTemplate.backGroundColor as? UIColor,
            let areas = currentTemplate.elements?.array as? [CDAbstractTemplateItem] else {
                return nil
        }
        
        let storyEditableItem = areas.compactMap { currentArea -> StoryEditableItem? in
            return createStoryEditableItem(from: currentArea)
        }
        
        return Template(name: name,
                        backgroundColor: backgroundColor,
                        backgroundImageName: currentTemplate.backGroundImageName,
                        storyEditableItem: storyEditableItem,
                        createdByUser: currentTemplate.managedObjectContext == localCoreDataStack.managedContext)
    }
    
    func createStoryEditableItem(from itemInTemplate: CDAbstractTemplateItem) -> StoryEditableItem? {
        switch itemInTemplate {
        case let item as CDPhotoFrameInTemplate:
            return frameEditableItem(from: item)
        case let item as CDStuffItemInTemplate:
            return stuffEditableItem(from: item)
        case let item as CDTextItemInTemplate:
            return textEditableItem(from: item)
        default:
            return nil
        }
    }
    
    func frameEditableItem(from item: CDPhotoFrameInTemplate) -> StoryEditablePhotoItem? {
        guard let photoItem = photoItemsById[Int(item.itemId)],
            let settings = generateSettings(from: item.settings) else {
                return nil
        }
        return StoryEditablePhotoItem(photoItem,
                                      customSettings: nil,
                                      settings: settings)
    }
    
    func stuffEditableItem(from item: CDStuffItemInTemplate) -> StoryEditableItem? {
        guard let stuff = stufItemsById[StuffItem.Id(item.itemId)], let settings = generateSettings(from: item.settings) else { return nil }
        return StoryEditableStuffItem(stuff,
                                      settings: settings)
    }
    
    func textEditableItem(from item: CDTextItemInTemplate) -> StoryEditableItem? {
        guard let settings = generateSettings(from: item.settings) else { return nil }
        guard let textSettings = generateTextSettings(from: item.textSettings) else { return nil }
        let textItem = TextItem.init(textSetups: textSettings,
                                     ratio: CGFloat(item.ratio))
        return StoryEditableTextItem(textItem, settings: settings)
    }
    
    func generateSettings(from itemSettings: CDTemplateSettings?) -> Settings? {
        guard let itemSettings = itemSettings else { return nil }
        let centerPoint = CGPoint(x: CGFloat(itemSettings.midX), y: CGFloat(itemSettings.midY))
        return Settings(center: centerPoint,
                        sizeWidth: CGFloat(itemSettings.widthScale),
                        angle: CGFloat(itemSettings.angle))
    }
    
    func generateTextSettings(from itemSettings: CDTextSettings?) -> TextSetups? {
        guard let itemSettings = itemSettings else { return nil }
        return TextSetups(aligment: Aligment(rawValue: Int(itemSettings.aligment)) ?? .center,
                          fontSize: CGFloat(itemSettings.fontSize),
                          lineSpacing: CGFloat(itemSettings.lineSpacing),
                          fontType: FontEnum(rawValue: itemSettings.fontName ?? "") ?? .cheque,
                          kern: CGFloat(itemSettings.kern),
                          color: itemSettings.color as? UIColor ?? .black,
                          backgroundColor: itemSettings.backgroundColor as? UIColor ?? .clear,
                          currentText: itemSettings.text ?? "")
    }
}
