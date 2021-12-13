//
//  DataController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/28/21.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
       viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
       // viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
    
    func clearDataFromController(){
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//           //try myPersistentStoreCoordinator.execute(deleteRequest, with: myContext)
//        } catch let error as NSError {
//            // TODO: handle the error
//        }
//        
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let url = self?.persistentContainer.persistentStoreDescriptions.first?.url else { return }
            
            let persistentStoreCoordinator = self?.persistentContainer.persistentStoreCoordinator
            
            do {
                try persistentStoreCoordinator?.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
                try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
                print("Done deleting")
            } catch {
                print("Attempted to clear persistent store: " + error.localizedDescription)
            }
        }
    }
}

// MARK: - Autosaving

extension DataController {
    func autoSaveViewContext(interval:TimeInterval = 300) {
//        if auth.data.appLockStatus == .walletUnlocked {
//            auth.updateLocalPrefs()
//        }
        
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
