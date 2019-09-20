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
    
    private(set) lazy var localCoreDataStack = CoreDataStack(modelName: "LocalSets", applicationDocumentsDirectory: applicationDocumentsDirectory)
    
    private(set) var templateSets: [SetWithTemplates] = []
    
    private(set) var stuffItems: [StuffItem] = []
    
    private(set) var stufItemsById: [StuffItem.Id: StuffItem] = [:]
    
    private(set) var photoItemsShape: [PhotoItem] = []
    
    private(set) var photoItemsFrame: [PhotoItem] = []
    
    private(set) var photoItemsById: [PhotoItem.Id: PhotoItem] = [:]
    
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
        let contextGlobal = coreDataStack.managedContext
        fillCoreData(context: contextGlobal)
        setupStuffItems(context: contextGlobal)
        setupPhotoItems(context: contextGlobal)
        setupSets(context: contextGlobal)
        loadUsersTemplates(context: localCoreDataStack.managedContext)
    }
    
    // MARK: - Functions
    
    func save(_ template: Template) {
        if let index = usersTemplates.firstIndex(where: { $0.name == template.name }) {
            usersTemplates.remove(at: index)
        }
        usersTemplates.insert(template, at: 0)
        saveTemplateInCD(template, context: localCoreDataStack.managedContext)
        usersTemplatesUpdate.onNext(())
    }
    
    func saveCurrentStory() {
        saveCurrentStorySignal.onNext(())
    }
    
    func deleteUsersTemplate(_ template: Template) -> Int? {
        guard let index = usersTemplates.firstIndex(of: template) else { return nil }
        usersTemplates.remove(at: index)
        deleteTemplateFromDB(template, context: localCoreDataStack.managedContext)
        return index
    }
    
    // MARK: - Private Functions
    
    private func loadUsersTemplates(context: NSManagedObjectContext) {
        usersTemplates.removeAll()
        let tempalteFetch: NSFetchRequest<CDTemplate> = CDTemplate.fetchRequest()
        tempalteFetch.sortDescriptors = [NSSortDescriptor(key: "lastChangeDate", ascending: false)]
        
        do {
            let results = try context.fetch(tempalteFetch)
            if results.count > 0 {
                usersTemplates = results.compactMap { cdTemplate -> Template? in
                    return template(from: cdTemplate)
                    }.compactMap { $0 }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    private func setupStuffItems(context: NSManagedObjectContext) {
        stuffItems.removeAll()
        stufItemsById.removeAll()
        let setFetch: NSFetchRequest<CDStuffItem> = CDStuffItem.fetchRequest()
        setFetch.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let results = try context.fetch(setFetch)
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
    
    private func setupPhotoItems(context: NSManagedObjectContext) {
        photoItemsShape.removeAll()
        photoItemsFrame.removeAll()
        photoItemsById.removeAll()
        let setFetch: NSFetchRequest<CDPhotoFrameItem> = CDPhotoFrameItem.fetchRequest()
        setFetch.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let results = try context.fetch(setFetch)
            results.forEach { cdPhotoItem in
                guard let settings = frameSettings(from: cdPhotoItem) else { return }
                let positionSettings = photoPositionSettings(from: cdPhotoItem)
                let id = Int(cdPhotoItem.id)
                let item = PhotoItem(frameId: id,
                                     frameImageName: cdPhotoItem.frameImageName,
                                     ratio: CGFloat(cdPhotoItem.ratio),
                                     photoInFrameSettings: settings,
                                     photoPositionSettings: positionSettings)
                photoItemsById[id] = item
                if cdPhotoItem.isShape {
                    photoItemsShape.append(item)
                } else {
                    photoItemsFrame.append(item)
                }
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    private func setupSets(context: NSManagedObjectContext) {
        let setFetch: NSFetchRequest<CDSet> = CDSet.fetchRequest()
        setFetch.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        do {
            let results = try context.fetch(setFetch)
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
