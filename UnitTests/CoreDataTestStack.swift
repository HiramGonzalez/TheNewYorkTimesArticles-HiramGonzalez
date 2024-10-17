//
//  CoreDataTestStack.swift
//  ViewModelTests
//
//  Created by Hiram González on 16/10/24.
//

import Foundation
import CoreData

class CoreDataTestStack {
    
    static let shared = CoreDataTestStack()
    
    // MARK: - Se crea el persistentContainer para los tests
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // Con esto se especifica que se almacena en memoria y no en disco
        container.persistentStoreDescriptions = [description]
        
        
        container.loadPersistentStores { description, error in
            if let error = error as? NSError {
                print("Error loading persistent stores from Core Data Model. \(error.localizedDescription)")
            }
            
        }
        
        return container
    }()
    
    // MARK: - Se crea el contexto
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
