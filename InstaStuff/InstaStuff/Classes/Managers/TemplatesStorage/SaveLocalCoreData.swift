//
//  TemplatesStorage+Ext.swift
//  InstaStuff
//
//  Created by aezhov on 12/04/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Save Delete

extension TemplatesStorage {
    
    func saveTemplateInCD(_ template: Template, context: NSManagedObjectContext) {
        let items: [CDAbstractItemInTemplate] = template.storyEditableItem.map { item in
            switch item {
            case let stuff as StoryEditableStuffItem:
                return stuffInTemplate(stuff: stuff, context: context)
            case let text as StoryEditableTextItem:
                return textItemInTemplate(text: text, context: context)
            case let photo as StoryEditablePhotoItem:
                return photoItemInTemplate(photo: photo, context: context)
            default:
                return nil
            }
            }.compactMap { $0 }
        
        deleteTemplateFromDB(template, context: context)
        
        let cdTemplate = CDTemplate(context: context)
        cdTemplate.lastChangeDate = Date()
        cdTemplate.elements = NSOrderedSet(array: items)
        cdTemplate.name = template.name
        cdTemplate.backGroundColor = template.backgroundColor
        cdTemplate.backGroundImageName = template.backgroundImageName
        
        try? context.save()
    }
    
    func deleteTemplateFromDB(_ template: Template, context: NSManagedObjectContext) {
        let tempalteFetch: NSFetchRequest<CDTemplate> = CDTemplate.fetchRequest()
        tempalteFetch.predicate = NSPredicate(format: "name == '\(template.name)'")
        
        do {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: tempalteFetch as! NSFetchRequest<NSFetchRequestResult>)
            try context.execute(deleteRequest)
        } catch {
            
        }
        coreDataStack.saveContext()
    }
}


// MARK: - Item to Core Data

extension TemplatesStorage {
    
    func stuffInTemplate(stuff: StoryEditableStuffItem, context: NSManagedObjectContext) -> CDStuffItemInTemplate {
        return stuffInTemplate(itemId: stuff.stuffItem.stuffId,
                               centerX: stuff.settings.center.x,
                               centerY: stuff.settings.center.y,
                               angle: stuff.settings.angle,
                               widthScale: stuff.settings.sizeWidth,
                               applyScale: false,
                               context: context)
    }
    
    func textItemInTemplate(text: StoryEditableTextItem, context: NSManagedObjectContext) -> CDTextItemInTemplate {
        let textItem = text.textItem
        let textSetups = textItem.textSetups
        let itemInTemplate = dataToTextItemInTemplate(ratio: textItem.ratio,
                                                      centerX: text.settings.center.x,
                                                      centerY: text.settings.center.y,
                                                      angle: text.settings.angle,
                                                      widthScale: text.settings.sizeWidth,
                                                      applyScale: false,
                                                      text: textSetups.currentText.value,
                                                      context: context)
        itemInTemplate.textSettings = textSettings(aligment: textSetups.aligment,
                                                   color: textSetups.color,
                                                   backgroundColor: textSetups.backgroundColor,
                                                   fontSize: textSetups.fontSize,
                                                   kern: textSetups.kern,
                                                   lineSpacing: textSetups.lineSpacing,
                                                   fontName: textSetups.fontType,
                                                   text: textSetups.currentText.value,
                                                   context: context)
        return itemInTemplate
    }
    
    func photoItemInTemplate(photo: StoryEditablePhotoItem, context: NSManagedObjectContext) -> CDPhotoFrameInTemplate {
        let item = photo.photoItem
        let photoFrameInTemplate = dataToPhotoFrameInTemplate(itemId: item.frameId,
                                                              centerX: photo.settings.center.x,
                                                              centerY: photo.settings.center.y,
                                                              angle: photo.settings.angle,
                                                              widthScale: photo.settings.sizeWidth,
                                                              applyScale: false,
                                                              photoName: photo.imageName.value,
                                                              context: context)
        return photoFrameInTemplate
    }
    
    
}


