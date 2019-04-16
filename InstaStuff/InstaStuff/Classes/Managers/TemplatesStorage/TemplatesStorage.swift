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
        let setFetch: NSFetchRequest<Set> = Set.fetchRequest()
        setFetch.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let results = try coreDataStack.managedContext.fetch(setFetch)
            if results.count > 0 {
                templateSets = results.map { currentSet -> TemplateSet in
                    let templatesRaw = (currentSet.templates?.array) as? [Templates]
                    let templates = templatesRaw?.compactMap { (currentTemplate: Templates) -> FrameTemplate in
                        
                        let itemsRaw = (currentTemplate.items?.array) as? [ItemInTemplate]
                        
                        let frameAreas = itemsRaw?.compactMap({ (itemInTemplate: ItemInTemplate) -> FrameAreaDescription? in
                            return frameAreaDescription(from: itemInTemplate)
                        })
                        
                        return FrameTemplate(id: currentTemplate.templateId ?? "",
                                             name: currentTemplate.templateName ?? "",
                                             frameAreas: frameAreas ?? [])
                    }
                    return TemplateSet(id: currentSet.id,
                                       themeColor: (currentSet.themeColor as? UIColor) ?? UIColor.white,
                                       name: currentSet.setName ?? "",
                                       templates: templates ?? [])
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    private func frameAreaDescription(from itemInTemplate: ItemInTemplate) -> FrameAreaDescription? {
        guard let item = itemInTemplate.item else {
            return nil
        }
        
        let settings = generateSettings(from: itemInTemplate.settings)
        let internalSettings = generateSettings(from: itemInTemplate.item?.internalSettings)
        
        switch ItemType.init(rawValue: item.itemType) {
        case .photo?:
            let photoItem = PhotoItem(frameName: itemInTemplate.item?.itemName ?? "", photoAreaLocation: internalSettings)
            let customSettings = photoItemCustomSettings(from: itemInTemplate.addSettings)
            
            let type = FrameAreaDescription.FrameAreaType.photoFrame(photoItem, customSettings)
            
            return FrameAreaDescription(settings: settings,
                                        frameArea: type)
        case .text?:
            let textSetups = TextSetups.init(textType: .none,
                                             aligment: .center,
                                             fontSize: 36,
                                             lineSpacing: 1,
                                             fontType: .futura,
                                             kern: 0,
                                             color: .black)
            let textItem = TextItem.init(textSetups: textSetups, defautText: "Type your text")
            let type = FrameAreaDescription.FrameAreaType.textFrame(textItem)
            return FrameAreaDescription(settings: settings,
                                        frameArea: type)
        default:
            return nil
        }
        
    }
    
    private func photoItemCustomSettings(from addSettings: AdditionalSettings?) -> PhotoItemCustomSettings? {
        guard let addSettings = addSettings else {
            return nil
        }
        return PhotoItemCustomSettings(closeButtonPosition: PhotoItemCustomSettings.CloseButtonPosition(rawValue: addSettings.closeButtonPosition),
                                       plusLocation: CGPoint(x: CGFloat(addSettings.plusLocationX), y: CGFloat(addSettings.plusLocationY)))
    }
    
    private func generateSettings(from itemSettings: ItemSettings?) -> Settings {
        let centerPoint = CGPoint(x: CGFloat(itemSettings?.centerX ?? 0.5), y: CGFloat(itemSettings?.centerY ?? 0.5))
        return Settings(center: centerPoint,
                        sizeWidth: CGFloat(itemSettings?.width ?? 1),
                        angle: CGFloat(itemSettings?.rotation ?? 0),
                        ratio: CGFloat(itemSettings?.ratio ?? 1))
    }
    
}


