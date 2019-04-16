//
//  TemplatesStorage+Ext.swift
//  InstaStuff
//
//  Created by aezhov on 12/04/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import CoreData

enum ItemType: Int16 {
    case photo = 0
    case text = 1
}

extension TemplatesStorage {
    
    func fillCoreData() {
        let setFetch: NSFetchRequest<Set> = Set.fetchRequest()
        let itemSettingsFetch: NSFetchRequest<ItemSettings> = ItemSettings.fetchRequest()
        let itemInTemplateFetch: NSFetchRequest<ItemInTemplate> = ItemInTemplate.fetchRequest()
        let itemsFetch: NSFetchRequest<Items> = Items.fetchRequest()
        let templatesFetch: NSFetchRequest<Templates> = Templates.fetchRequest()
        [setFetch, itemSettingsFetch, itemInTemplateFetch, itemsFetch, templatesFetch].forEach { fetch in
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
            do {
                try coreDataStack.managedContext.execute(deleteRequest)
            } catch {
                
            }
        }
        let set1 = [set1template1(), set1template2(), set1template3(), set1template4(), set1template5(), set1template6(), set1template7(), set1template8(), set1template9(), set1template10(), set1template11(), set1template12(), set1template13(), set1template14()]
        [(1, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), "Casual", set1), (2, #colorLiteral(red: 0.8901960784, green: 0.862745098, blue: 0.7215686275, alpha: 1), "Lifestyle", []), (3, #colorLiteral(red: 0.8588235294, green: 0.7529411765, blue: 0.6980392157, alpha: 1), "Love", [])].forEach { tupple in
            let set = Set(context: coreDataStack.managedContext)
            set.id = Int64(tupple.0)
            set.themeColor = tupple.1
            set.setName = tupple.2
            set.templates = NSOrderedSet(array: tupple.3)
        }
        coreDataStack.saveContext()
    }
    
    func set1template1() -> Templates {
        let itemInTemplate = emptyFrameItemSettings(ratioX: 82.0, ratioY: 160.0, centerX: 54, centerY: 36)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [itemInTemplate])
        template.templateName = "Name 1"
        template.templateId = "template1"
        return template
    }
    
    func set1template2() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 96.0, ratioY: 85.0, centerX: 54, centerY: 52)
        let item2InTemplate = emptyFrameItemSettings(ratioX: 96.0, ratioY: 85.0, centerX: 54, centerY: 140)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate])
        template.templateName = "Name 2"
        template.templateId = "template2"
        return template
    }
    
    func set1template3() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 77.0, ratioY: 107.0, centerX: 65, centerY: 58)
        let item2InTemplate = emptyFrameItemSettings(ratioX: 58.0, ratioY: 90.0, centerX: 35, centerY: 140)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate])
        template.templateName = "Name 3"
        template.templateId = "template3"
        return template
    }
    
    func set1template4() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 70.0, ratioY: 98.0, centerX: 54, centerY: 124)
        let addSettings1 = AdditionalSettings(context: coreDataStack.managedContext)
        addSettings1.closeButtonPosition = 2
        item1InTemplate.addSettings = addSettings1
        let item2InTemplate = emptyFrameItemSettings(ratioX: 48.0, ratioY: 74.0, centerX: 30, centerY: 55)
        let item3InTemplate = emptyFrameItemSettings(ratioX: 48.0, ratioY: 74.0, centerX: 78, centerY: 72)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate, item3InTemplate])
        template.templateName = "Name 4"
        template.templateId = "template4"
        return template
    }
    
    func set1template5() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 44, ratioY: 80, centerX: 30, centerY: 58)
        let item2InTemplate = emptyFrameItemSettings(ratioX: 44, ratioY: 80, centerX: 78, centerY: 58)
        let item3InTemplate = emptyFrameItemSettings(ratioX: 44, ratioY: 80, centerX: 30, centerY: 142)
        let item4InTemplate = emptyFrameItemSettings(ratioX: 44, ratioY: 80, centerX: 78, centerY: 142)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate, item3InTemplate, item4InTemplate])
        template.templateName = "Name 5"
        template.templateId = "template5"
        return template
    }
    
    func set1template6() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 60, ratioY: 80, centerX: 68, centerY: 50)
        let item2InTemplate = emptyFrameItemSettings(ratioX: 60, ratioY: 80, centerX: 40, centerY: 142)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate])
        template.templateName = "Name 6"
        template.templateId = "template6"
        return template
    }
    
    func set1template7() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 70, ratioY: 134, centerX: 39, centerY: 92)
        let item2InTemplate = emptyFrameItemSettings(ratioX: 58, ratioY: 68, centerX: 72, centerY: 92)
        item2InTemplate.settings?.rotation = Float(.pi * 10 / 180.0)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate])
        template.templateName = "Name 7"
        template.templateId = "template7"
        return template
    }
    
    func set1template8() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 94, ratioY: 60, centerX: 54, centerY: 34)
        let item2InTemplate = emptyFrameItemSettings(ratioX: 80, ratioY: 120, centerX: 54, centerY: 117)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate])
        template.templateName = "Name 8"
        template.templateId = "template8"
        return template
    }
    
    func set1template9() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 108, ratioY: 192, centerX: 54, centerY: 94)
        let addSettings1 = AdditionalSettings(context: coreDataStack.managedContext)
        addSettings1.closeButtonPosition = 0
        addSettings1.plusLocationX = 0.5
        addSettings1.plusLocationY = 12.0/192.0
        item1InTemplate.addSettings = addSettings1
        let item2InTemplate = emptyFrameItemSettings(ratioX: 80, ratioY: 140, centerX: 54, centerY: 94)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate])
        template.templateName = "Name 9"
        template.templateId = "template9"
        return template
    }
    
    func set1template10() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 108, ratioY: 192, centerX: 54, centerY: 96)
        let addSettings1 = AdditionalSettings(context: coreDataStack.managedContext)
        addSettings1.closeButtonPosition = 0
        addSettings1.plusLocationX = 12.0/108.0
        addSettings1.plusLocationY = 37.0/192.0
        item1InTemplate.addSettings = addSettings1
        
        let item2InTemplate = emptyFrameItemSettings(ratioX: 80, ratioY: 100, centerX: 63, centerY: 66)
        
        let item3InTemplate = emptyFrameItemSettings(ratioX: 70, ratioY: 80, centerX: 40, centerY: 134)
        let addSettings3 = AdditionalSettings(context: coreDataStack.managedContext)
        addSettings3.closeButtonPosition = 1
        addSettings3.plusLocationX = 0.5
        addSettings3.plusLocationY = 0.5
        item3InTemplate.addSettings = addSettings3
        
        let item4InTemplate = emptyFrameItemSettings(ratioX: 43, ratioY: 43, centerX: 75, centerY: 108)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate, item3InTemplate, item4InTemplate])
        template.templateName = "Name 10"
        template.templateId = "template10"
        return template
    }
    
    func set1template11() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 80, ratioY: 128, centerX: 54, centerY: 77)
        let item2InTemplate = emptyTextItemSettings(ratioX: 80, ratioY: 34, centerX: 54, centerY: 162)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate])
        template.templateName = "Name 11"
        template.templateId = "template11"
        return template
    }
    
    func set1template12() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 80, ratioY: 90, centerX: 54, centerY: 96)
        let item2InTemplate = emptyTextItemSettings(ratioX: 80, ratioY: 34, centerX: 54, centerY: 162)
        let item3InTemplate = emptyTextItemSettings(ratioX: 80, ratioY: 34, centerX: 54, centerY: 30)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate, item3InTemplate])
        template.templateName = "Name 12"
        template.templateId = "template12"
        return template
    }
    
    func set1template13() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 88, ratioY: 94, centerX: 54, centerY: 96)
        let item2InTemplate = emptyFrameItemSettings(ratioX: 68, ratioY: 64, centerX: 54, centerY: 148)
        let item3InTemplate = emptyTextItemSettings(ratioX: 88, ratioY: 34, centerX: 54, centerY: 30)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate, item3InTemplate])
        template.templateName = "Name 13"
        template.templateId = "template13"
        return template
    }
    
    func set1template14() -> Templates {
        let item1InTemplate = emptyFrameItemSettings(ratioX: 108, ratioY: 192, centerX: 54, centerY: 96)
        let addSettings1 = AdditionalSettings(context: coreDataStack.managedContext)
        addSettings1.closeButtonPosition = 0
        addSettings1.plusLocationX = 0.5
        addSettings1.plusLocationY = 12.0/192.0
        item1InTemplate.addSettings = addSettings1
        let item2InTemplate = emptyFrameItemSettings(ratioX: 80, ratioY: 120, centerX: 54, centerY: 84)
        let item3InTemplate = emptyTextItemSettings(ratioX: 80, ratioY: 34, centerX: 54, centerY: 163)
        
        let template = Templates(context: coreDataStack.managedContext)
        template.items = NSOrderedSet(array: [item1InTemplate, item2InTemplate, item3InTemplate])
        template.templateName = "Name 14"
        template.templateId = "template14"
        return template
    }
    
    private func emptyFrameItemSettings(ratioX: CGFloat, ratioY: CGFloat, centerX: CGFloat, centerY: CGFloat) -> ItemInTemplate {
        let itemSettings = ItemSettings(context: coreDataStack.managedContext)
        itemSettings.centerX = 0.5
        itemSettings.centerY = 0.5
        itemSettings.width = 1
        itemSettings.rotation = 0
        itemSettings.ratio = Float(ratioX/ratioY)
        
        let item = Items(context: coreDataStack.managedContext)
        item.itemType = ItemType.photo.rawValue
        item.itemName = "empty\(Int(ratioX))to\(Int(ratioY))"
        item.internalSettings = itemSettings
        
        let itemSettingsInFrame = ItemSettings(context: coreDataStack.managedContext)
        itemSettingsInFrame.centerX = Float(centerX/108.0)
        itemSettingsInFrame.centerY = Float(centerY/192.0)
        itemSettingsInFrame.width = Float(ratioX/108.0)
        itemSettingsInFrame.rotation = 0
        itemSettingsInFrame.ratio = Float(ratioX/ratioY)
        
        let itemInTemplate = ItemInTemplate(context: coreDataStack.managedContext)
        itemInTemplate.item = item
        itemInTemplate.settings = itemSettingsInFrame
        
        return itemInTemplate
    }
    
    private func emptyTextItemSettings(ratioX: CGFloat, ratioY: CGFloat, centerX: CGFloat, centerY: CGFloat) -> ItemInTemplate {
        let itemSettings = ItemSettings(context: coreDataStack.managedContext)
        
        let item = Items(context: coreDataStack.managedContext)
        item.itemType = ItemType.text.rawValue
        item.itemName = "empty\(Int(ratioX))to\(Int(ratioY))"
        item.internalSettings = itemSettings
        
        let itemSettingsInFrame = ItemSettings(context: coreDataStack.managedContext)
        itemSettingsInFrame.centerX = Float(centerX/108.0)
        itemSettingsInFrame.centerY = Float(centerY/192.0)
        itemSettingsInFrame.width = Float(ratioX/108.0)
        itemSettingsInFrame.rotation = 0
        itemSettingsInFrame.ratio = Float(ratioX/ratioY)
        
        let itemInTemplate = ItemInTemplate(context: coreDataStack.managedContext)
        itemInTemplate.item = item
        itemInTemplate.settings = itemSettingsInFrame
        
        return itemInTemplate
    }
    
}


