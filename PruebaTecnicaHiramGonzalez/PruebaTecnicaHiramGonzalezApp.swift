//
//  PruebaTecnicaHiramGonzalezApp.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 13/10/24.
//

import SwiftUI

@main
struct PruebaTecnicaHiramGonzalezApp: App {
    
    // Se inicializa una instancia de Core Data stack
    @StateObject private var coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Se inyecta el ManagedObjectContext al Environment para que pueda ser accedido desde adentro del proyecto.
                .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
            
        }
    }
}
