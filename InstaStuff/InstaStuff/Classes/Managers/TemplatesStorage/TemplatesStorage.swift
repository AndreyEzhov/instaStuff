//
//  TemplatesStorage.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import CoreData

class TemplatesStorage {
    
    // MARK: - Properties
    
    let coreDataStack = CoreDataStack(modelName: "Sets")
    
    private(set) var templateSets: [TemplateSet] = []
    
    // MARK: - Consruction
    
    init() {
        fillCoreData()
        setupSets()
    }
    
    // MARK: - Private Functions
    
    private func setupSets() {
        let setFetch: NSFetchRequest<CDSet> = CDSet.fetchRequest()
        setFetch.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let results = try coreDataStack.managedContext.fetch(setFetch)
            if results.count > 0 {
                templateSets = results.compactMap { currentSet -> TemplateSet? in
                    return templateSet(from: currentSet)
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    private func templateSet(from cdSet: CDSet) -> TemplateSet? {
        guard let templatesRaw = cdSet.templates?.array as? [CDTemplate], let name = cdSet.name, let themeColor = cdSet.themeColor as? UIColor else {
            return nil
        }
        let templates = templatesRaw.compactMap { (currentTemplate) -> FrameTemplate? in
            return template(from: currentTemplate)
        }
        return TemplateSet(id: cdSet.id,
                           themeColor: themeColor,
                           name: name,
                           templates: templates)
    }
    
    private func template(from currentTemplate: CDTemplate) -> FrameTemplate? {
        guard let templateId = currentTemplate.id, let name = currentTemplate.name, let areas = currentTemplate.items?.array as? [CDItemInTemplate] else {
            return nil
        }
        
        let frameAreas = areas.compactMap { (currentArea) -> FrameAreaDescription? in
            return frameAreaDescription(from: currentArea)
        }
        
        return FrameTemplate(id: templateId,
                             name: name,
                             frameAreas: frameAreas)
    }
    
    private func frameAreaDescription(from itemInTemplate: CDItemInTemplate) -> FrameAreaDescription? {
        switch itemInTemplate {
        case let item as CDPhotoItemInTemplate:
            return photoFrameAreaDescription(from: item)
        case let item as CDTextItemInTemplate:
            return textFrameAreaDescription(from: item)
        default:
            return nil
        }
    }
    
    private func photoFrameAreaDescription(from photoItemInFrame: CDPhotoItemInTemplate) -> FrameAreaDescription? {
        guard let photoItem = photoItemInFrame.photoItem, let settings = photoItemInFrame.settings else {
            return nil
        }
        let customSettings = photoItemCustomSettings(from: photoItemInFrame.additionalSettings)
        
        let type = FrameAreaDescription.FrameAreaType.photoFrame(self.photoItem(from: photoItem), customSettings)
        return FrameAreaDescription(settings: generateSettings(from: settings),
                                    frameArea: type)
    }
    
    private func photoItem(from cdPhotoItem: CDPhotoItem) -> PhotoItem {
        let settings = generateSettings(from: cdPhotoItem.settings)
        return PhotoItem(frameName: cdPhotoItem.name ?? "", photoAreaLocation: settings)
    }
    
    private func textFrameAreaDescription(from textItemInFrame: CDTextItemInTemplate) -> FrameAreaDescription? {
        guard let settings = textItemInFrame.settings else {
            return nil
        }
        let textSetups = TextSetups.init(textType: .none,
                                         aligment: .center,
                                         fontSize: 36,
                                         lineSpacing: 1,
                                         fontType: .futura,
                                         kern: 0,
                                         color: .black)
        let textItem = TextItem.init(textSetups: textSetups, defautText: "Type your text")
        
        let type = FrameAreaDescription.FrameAreaType.textFrame(textItem)
        return FrameAreaDescription(settings: generateSettings(from: settings),
                                    frameArea: type)
    }

    private func photoItemCustomSettings(from addSettings: CDPhotoItemSettings?) -> PhotoItemCustomSettings? {
        guard let addSettings = addSettings else {
            return nil
        }
        return PhotoItemCustomSettings(closeButtonPosition: PhotoItemCustomSettings.CloseButtonPosition(rawValue: addSettings.closeButtonPosition),
                                       plusLocation: CGPoint(x: CGFloat(addSettings.plusLocationX), y: CGFloat(addSettings.plusLocationY)))
    }
    
    private func generateSettings(from itemSettings: CDSettings?) -> Settings {
        let centerPoint = CGPoint(x: CGFloat(itemSettings?.centerX ?? 0.5), y: CGFloat(itemSettings?.centerY ?? 0.5))
        return Settings(center: centerPoint,
                        sizeWidth: CGFloat(itemSettings?.width ?? 1),
                        angle: CGFloat(itemSettings?.rotation ?? 0),
                        ratio: CGFloat(itemSettings?.ratio ?? 1))
    }
    
}


