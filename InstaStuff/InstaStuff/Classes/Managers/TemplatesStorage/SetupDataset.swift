//
//  SetupDataset.swift
//  InstaStuff
//
//  Created by aezhov on 05/08/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import CoreData

extension TemplatesStorage {
    
    func fillCoreData(context: NSManagedObjectContext) {
        
        let CDSetFetch: NSFetchRequest<CDSet> = CDSet.fetchRequest()
        let CDTemplateFetch: NSFetchRequest<CDTemplate> = CDTemplate.fetchRequest()
        let CDTemplateSettingsFetch: NSFetchRequest<CDTemplateSettings> = CDTemplateSettings.fetchRequest()
        
        let CDAbstractTemplateItemFetch: NSFetchRequest<CDAbstractTemplateItem> = CDAbstractTemplateItem.fetchRequest()
        let CDPhotoFrameInTemplateFetch: NSFetchRequest<CDPhotoFrameInTemplate> = CDPhotoFrameInTemplate.fetchRequest()
        let CDStuffItemInTemplateFetch: NSFetchRequest<CDStuffItemInTemplate> = CDStuffItemInTemplate.fetchRequest()
        let CDAbstractItemFetch: NSFetchRequest<CDAbstractItem> = CDAbstractItem.fetchRequest()
        let CDStuffItemFetch: NSFetchRequest<CDStuffItem> = CDStuffItem.fetchRequest()
        let CDPhotoFrameItemFetch: NSFetchRequest<CDPhotoFrameItem> = CDPhotoFrameItem.fetchRequest()
        let CDTextSettingsFetch: NSFetchRequest<CDTextSettings> = CDTextSettings.fetchRequest()
        let CDPhotoFrameSettingsFetch: NSFetchRequest<CDPhotoFrameSettings> = CDPhotoFrameSettings.fetchRequest()
        
        [CDSetFetch,
         CDTemplateFetch,
         CDTemplateSettingsFetch,
         CDAbstractTemplateItemFetch,
         CDPhotoFrameInTemplateFetch,
         CDStuffItemInTemplateFetch,
         CDAbstractItemFetch,
         CDStuffItemFetch,
         CDPhotoFrameItemFetch,
         CDTextSettingsFetch,
         CDPhotoFrameSettingsFetch
            ].forEach { fetch in
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch as! NSFetchRequest<NSFetchRequestResult>)
                do {
                    try context.execute(deleteRequest)
                } catch {
                    
                }
        }
        
        setupFrames(context: context)
        fillWithStuff(context: context)
        
        let set1 = [set1template1(context: context)]
        //, set1template2(), set1template3(), set1template4(), set1template5(), set1template6(), set1template7(), set1template8(), set1template9(), set1template10(), set1template11(), set1template12(), set1template13(), set1template14()]
        
        [(1, #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), "Casual", set1), (2, #colorLiteral(red: 0.8901960784, green: 0.862745098, blue: 0.7215686275, alpha: 1), "Lifestyle", []), (3, #colorLiteral(red: 0.8588235294, green: 0.7529411765, blue: 0.6980392157, alpha: 1), "Love", [])].forEach { tupple in
            let set = CDSet(context: context)
            set.priority = Int64(tupple.0)
            set.buyId = "0"
            set.themeColor = tupple.1
            set.name = tupple.2
            set.templates = NSOrderedSet(array: tupple.3)
        }
        
        try? context.save()
    }
    
    func fillWithStuff(context: NSManagedObjectContext) {
        [(1, "stuff_1"), (2, "stuff_2"), (3, "stuff_3"), (4, "stuff_4")].forEach { args in
            let stuff = CDStuffItem(context: context)
            stuff.id = Int64(args.0)
            stuff.buyId = "0"
            stuff.imageName = args.1
        }
    }
    
    func setupFrames(context: NSManagedObjectContext) {
        setupShapes(context: context)
        setupPhotoFrames(context: context)
    }
    
    func setupPhotoFrames(context: NSManagedObjectContext) {
        let photoFrame1_1 = photoFrame(itemId: 1001,
                                       ratio: 1080.0/1200.0,
                                       frameName: "frame1_1",
                                       isShape: false,
                                       context: context)
        photoFrame1_1.photoSettings = photoFrameSettings(centerX: 0.5,
                                                         centerY: 5.0/12.0,
                                                         angle: 0,
                                                         widthScale: 900.0/1080.0,
                                                         ratio: 90.0/82.0,
                                                         round: 0,
                                                         context: context)
    }
    
    func setupShapes(context: NSManagedObjectContext) {
        
        let shape_1_to_1 = photoFrame(itemId: 2001,
                                      ratio: 1,
                                      frameName: "square",
                                      isShape: true,
                                      context: context)
        
        shape_1_to_1.photoSettings = photoFrameSettings(centerX: 0.5,
                                                        centerY: 0.5,
                                                        angle: 0,
                                                        widthScale: 1,
                                                        ratio: 1,
                                                        round: 0,
                                                        context: context)
        
        
        let shape_1_to_2 = photoFrame(itemId: 2002,
                                      ratio: 1/2,
                                      frameName: "1_to_2",
                                      isShape: true,
                                      context: context)
        
        shape_1_to_2.photoSettings = photoFrameSettings(centerX: 0.5,
                                                        centerY: 0.5,
                                                        angle: 0,
                                                        widthScale: 1,
                                                        ratio: 1/2,
                                                        round: 0,
                                                        context: context)
        
        let shape_2_to_1 = photoFrame(itemId: 2003,
                                      ratio: 2/1,
                                      frameName: "2_to_1",
                                      isShape: true,
                                      context: context)
        
        shape_2_to_1.photoSettings = photoFrameSettings(centerX: 0.5,
                                                        centerY: 0.5,
                                                        angle: 0,
                                                        widthScale: 1,
                                                        ratio: 2/1,
                                                        round: 0,
                                                        context: context)
        
        let shape_round = photoFrame(itemId: 2004,
                                     ratio: 1,
                                     frameName: "round",
                                     isShape: true,
                                     context: context)
        
        shape_round.photoSettings = photoFrameSettings(centerX: 0.5,
                                                       centerY: 0.5,
                                                       angle: 0,
                                                       widthScale: 1,
                                                       ratio: 1,
                                                       round: 0.5,
                                                       context: context)
        
        let shape_round_2 = photoFrame(itemId: 2005,
                                       ratio: 0.68,
                                       frameName: "round_2",
                                       isShape: true,
                                       context: context)
        
        shape_round_2.photoSettings = photoFrameSettings(centerX: 0.5,
                                                         centerY: 0.5,
                                                         angle: 0,
                                                         widthScale: 1,
                                                         ratio: 0.68,
                                                         round: 0.5,
                                                         context: context)
    }
    
    
    func set1template1(context: NSManagedObjectContext) -> CDTemplate {
        let itemInTemplate = stuffInTemplate(itemId: 2, centerX: 50, centerY: 50, angle: .pi / 2, widthScale: 25, context: context)
        let textInTemplate = dataToTextItemInTemplate(ratio: 2, centerX: 54, centerY: 120, angle: 0, widthScale: 90, context: context)
        textInTemplate.textSettings = defaultTextSettings(context: context)
        let frame = dataToPhotoFrameInTemplate(itemId: 2005, centerX: 50, centerY: 80, angle: 0, widthScale: 70, context: context)
        
        let template = CDTemplate(context: context)
        template.elements = NSOrderedSet(array: [frame, textInTemplate, itemInTemplate])
        template.name = "set1_template1"
        template.backGroundColor = UIColor.white
        template.backGroundImageName = nil
        template.lastChangeDate = Date()
        return template
    }
}
