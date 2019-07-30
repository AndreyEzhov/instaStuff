//
//  TemplatesStorage.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class TemplatesStorage {
    
    // MARK: - Properties
    
    private(set) lazy var coreDataStack = CoreDataStack(modelName: "Sets", applicationDocumentsDirectory: applicationDocumentsDirectory)
    
    private(set) var templateSets: [SetWithTemplates] = []
    
    private(set) var stuffItems: [StuffItem] = []
    
    private var stufItemsById: [StuffItem.Id: StuffItem] = [:]
    
    private(set) var usersTemplates: [Template] = []
    
    private lazy var usersTemplatesUpdate = BehaviorSubject(value: Void())
    
    private(set) lazy var usersTemplatesUpdateObserver = usersTemplatesUpdate.asObserver()
    
    private lazy var saveCurrentStorySignal = BehaviorSubject(value: Void())
    
    private(set) lazy var saveCurrentStoryObserver = saveCurrentStorySignal.asObserver()
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    // MARK: - Consruction
    
    init() {
        let debug = false
        if debug {
            fillCoreData()
            ["sqlite", "sqlite-wal", "sqlite-shm"].forEach({ ext in
                let fileName = "Sets.\(ext)"
                let url = applicationDocumentsDirectory.appendingPathComponent(fileName)
                if FileManager.default.fileExists(atPath: url.path) {
                    let urlLocal = URL(string: "file:///Users/aezhov/xCode/Other/InstaStuff/InstaStuff/InstaStuff/Classes/Managers/CoreData/Data/\(fileName)")
                    try? FileManager.default.copyItem(at: url, to: urlLocal!)
                }
            })
        } else {
            ["sqlite", "sqlite-wal", "sqlite-shm"].forEach({ ext in
                let url = applicationDocumentsDirectory.appendingPathComponent("Sets.\(ext)")
                if FileManager.default.fileExists(atPath: url.path) == false {
                    let bundleURL = Bundle.main.url(forResource: "Sets", withExtension: ext)
                    try? FileManager.default.copyItem(at: bundleURL!, to: url)
                }
            })
        }
        setupStuffItems()
        setupSets()
        loadUsersTemplates()
    }
    
    // MARK: - Functions
    
    func save(_ template: Template) {
        if let index = usersTemplates.firstIndex(where: { $0.name == template.name }) {
            usersTemplates.remove(at: index)
        }
        usersTemplates.insert(template, at: 0)
        saveTemplateInCD(template)
        usersTemplatesUpdate.onNext(())
    }
    
    func saveCurrentStory() {
        saveCurrentStorySignal.onNext(())
    }
    
    func deleteUsersTemplate(_ template: Template) -> Int? {
        guard let index = usersTemplates.firstIndex(of: template) else { return nil }
        usersTemplates.remove(at: index)
        deleteTemplateFromDB(template)
        return index
    }
    
    // MARK: - Private Functions
    
    private func loadUsersTemplates() {
        usersTemplates.removeAll()
        let tempalteFetch: NSFetchRequest<CDTemplate> = CDTemplate.fetchRequest()
        tempalteFetch.predicate = NSPredicate(format: "createdByUser == 1")
        tempalteFetch.sortDescriptors = [NSSortDescriptor(key: "lastChangeDate", ascending: false)]
        
        do {
            let results = try coreDataStack.managedContext.fetch(tempalteFetch)
            if results.count > 0 {
                usersTemplates = results.compactMap { cdTemplate -> Template? in
                    return template(from: cdTemplate)
                    }.compactMap { $0 }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    private func setupStuffItems() {
        stuffItems.removeAll()
        stufItemsById.removeAll()
        let setFetch: NSFetchRequest<CDStuffItem> = CDStuffItem.fetchRequest()
        setFetch.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let results = try coreDataStack.managedContext.fetch(setFetch)
            stuffItems = results.compactMap { cdStuffItem -> StuffItem? in
                guard let imageName = cdStuffItem.imageName else {
                    return nil
                }
                let id = Int(cdStuffItem.id)
                let item = StuffItem(stuffId: id, imageName: imageName)
                stufItemsById[id] = item
                return item
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    private func setupSets() {
        let setFetch: NSFetchRequest<CDSet> = CDSet.fetchRequest()
        setFetch.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        do {
            let results = try coreDataStack.managedContext.fetch(setFetch)
            if results.count > 0 {
                templateSets = results.compactMap { currentSet -> SetWithTemplates? in
                    return templateSet(from: currentSet)
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
}


// MARK: - Core Data to Items

extension TemplatesStorage {
    
    private func templateSet(from cdSet: CDSet) -> SetWithTemplates? {
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
    
    private func template(from currentTemplate: CDTemplate) -> Template? {
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
                        createdByUser: currentTemplate.createdByUser)
    }
    
    private func createStoryEditableItem(from itemInTemplate: CDAbstractTemplateItem) -> StoryEditableItem? {
        switch itemInTemplate {
            //            case let item as CDPhotoItemInTemplate:
            //                return photoFrameAreaDescription(from: item)
            //            case let item as CDTextItemInTemplate:
            //                return textFrameAreaDescription(from: item)
            //            case let item as CDViewInTemplate:
        //                return viewAreaDescription(from: item)
        case let item as CDStuffItemInTemplate:
            return stuffEditableItem(from: item)
        case let item as CDTextItemInTemplate:
            return textEditableItem(from: item)
        default:
            return nil
        }
    }
    
    private func stuffEditableItem(from item: CDStuffItemInTemplate) -> StoryEditableItem? {
        guard let stuff = stufItemsById[StuffItem.Id(item.itemId)], let settings = generateSettings(from: item.settings) else { return nil }
        return StoryEditableStuffItem(stuff,
                                      settings: settings)
    }
    
    private func textEditableItem(from item: CDTextItemInTemplate) -> StoryEditableItem? {
        guard let settings = generateSettings(from: item.settings) else { return nil }
        guard let textSettings = generateTextSettings(from: item.textSettings) else { return nil }
        let textItem = TextItem.init(textSetups: textSettings,
                                     ratio: CGFloat(item.ratio))
        return StoryEditableTextItem(textItem, settings: settings)
    }
    
    private func generateSettings(from itemSettings: CDTemplateSettings?) -> Settings? {
        guard let itemSettings = itemSettings else { return nil }
        let centerPoint = CGPoint(x: CGFloat(itemSettings.midX), y: CGFloat(itemSettings.midY))
        return Settings(center: centerPoint,
                        sizeWidth: CGFloat(itemSettings.widthScale),
                        angle: CGFloat(itemSettings.angle))
    }
    
    private func generateTextSettings(from itemSettings: CDTextSettings?) -> TextSetups? {
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



//
//    private func photoFrameAreaDescription(from photoItemInFrame: CDPhotoItemInTemplate) -> FrameAreaDescription? {
//        guard let photoItem = photoItemInFrame.photoItem, let settings = photoItemInFrame.settings else {
//            return nil
//        }
//        let customSettings = photoItemCustomSettings(from: photoItemInFrame.additionalSettings)
//
//        let type = FrameAreaDescription.FrameAreaType.photoFrame(self.photoItem(from: photoItem), customSettings)
//        return FrameAreaDescription(settings: generateSettings(from: settings),
//                                    frameArea: type)
//    }
//
//    private func photoItem(from cdPhotoItem: CDPhotoItem) -> PhotoItem {
//        let settings = generateSettings(from: cdPhotoItem.settings)
//        return PhotoItem(frameName: cdPhotoItem.name ?? "", photoAreaLocation: settings)
//    }
//
//    private func textFrameAreaDescription(from textItemInFrame: CDTextItemInTemplate) -> FrameAreaDescription? {
//        guard let settings = textItemInFrame.settings else {
//            return nil
//        }
//        let textSetups = TextSetups.init(textType: .none,
//                                         aligment: .center,
//                                         fontSize: 36,
//                                         lineSpacing: 1,
//                                         fontType: .futura,
//                                         kern: 0,
//                                         color: .black)
//        let textItem = TextItem.init(textSetups: textSetups, defautText: "Type your text")
//
//        let type = FrameAreaDescription.FrameAreaType.textFrame(textItem)
//        return FrameAreaDescription(settings: generateSettings(from: settings),
//                                    frameArea: type)
//    }
//
//    private func viewAreaDescription(from viewInFrame: CDViewInTemplate) -> FrameAreaDescription? {
//        guard let settings = viewInFrame.settings else {
//            return nil
//        }
//        let viewItem = ViewItem(color: (viewInFrame.color as? UIColor) ?? UIColor.white)
//
//        let type = FrameAreaDescription.FrameAreaType.viewFrame(viewItem)
//        return FrameAreaDescription(settings: generateSettings(from: settings),
//                                    frameArea: type)
//    }
//
//    private func photoItemCustomSettings(from addSettings: CDPhotoItemSettings?) -> PhotoItemCustomSettings? {
//        guard let addSettings = addSettings else {
//            return nil
//        }
//        return PhotoItemCustomSettings(closeButtonPosition: PhotoItemCustomSettings.CloseButtonPosition(rawValue: addSettings.closeButtonPosition),
//                                       plusLocation: CGPoint(x: CGFloat(addSettings.plusLocationX), y: CGFloat(addSettings.plusLocationY)))
//    }
//
