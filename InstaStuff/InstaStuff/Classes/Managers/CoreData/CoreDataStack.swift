//
//  CoreDataStack.swift
//  InstaStuff
//
//  Created by aezhov on 12/04/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
//        do {
//            try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
//                                                                        configurationName: nil,
//                                                                        at: Bundle.main.url(forResource: "Sets", withExtension: "sqlite"),
//                                                                        options: nil)
//        } catch let error as NSError {
//            print("Unresolved error \(error), \(error.userInfo)")
//        }
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
