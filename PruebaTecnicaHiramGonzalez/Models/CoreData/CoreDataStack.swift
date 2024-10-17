//
//  CoreDataStack.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 14/10/24.
//

import Foundation
import CoreData

class CoreDataStack: ObservableObject {
    
    static let shared = CoreDataStack()
    private let context: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext? = nil) {
        self.context = context
    }
    
    
    // MARK: - Se crea el persistentContainer para acceder a las funciones de CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                print("Error loading persistent stores from Core Data Model. \(error.localizedDescription)")
            }
            
        }
        
        return container
    }()
    
    
    
    // MARK: - Funcion para hacer fetch de los articulos almacenados localmente
    func fetchStoredData() async -> [Article]? {
        // Se crea el fetch request para traer los datos almacenados
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleDataModel")
        
        
        do {
            let viewContext = context ?? persistentContainer.viewContext
            
            let data = try viewContext.fetch(fetchRequest) // Se ejecuta el fetch
            
            var articles = [Article]()
            // Se transforman los datos guardados para convertirse en objetos Article
            for article in data {
                let decodedArticle = article as! NSManagedObject
                
                let tempArticle = Article(title: decodedArticle.value(forKey: "title") as! String,
                                          author: decodedArticle.value(forKey: "author") as! String,
                                          publicationDate: decodedArticle.value(forKey: "publicationDate") as! String,
                                          abstract: decodedArticle.value(forKey: "abstract") as! String)
                
                articles.append(tempArticle)
            }
            
            return articles // se regresan los objetos Article decodificados
        } catch {
            print("No se pudieron obtener los datos almacenados localmente o hubo un problema en su decodificación.")
            
            return nil // En caso de error, no se regresa nada
        }
    } // func fetchStoredData
    
    
    
    // Metodo para guardar los cambios en el almacenamiento local
    func save() {
        // Verificar que hayan cambios en el contexto
        let viewContext = context ?? persistentContainer.viewContext
        
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save() // Guardar los cambios
        } catch {
            print("Error al guardar el contexto:", error.localizedDescription)
        }
    } // func save
    
    
    
    // Este metodo sirve para almacenar los articulos mas recientes
    // en la memoria del telefono
    func saveData(_ articles: [Article]) {
        let viewContext = context ?? persistentContainer.viewContext
        
        guard let articleEntity = NSEntityDescription.entity(forEntityName: "ArticleDataModel", in: viewContext) else { return } // Se crea la entidad de Article, en caso de error, no se puede continuar con la operacion
        
        
        guard deleteArticlesInLocalStorage() else { return } // Se eliminan primero los articulos en memoria, en caso de error, se cancela la operacion
        
        
        // Se almacenan cada uno de los articulos actualizados
        for article in articles {
            // Se crea un objeto temporal del articulo para asignar los valores
            // de cada propiedad
            let tempArticle = NSManagedObject(entity: articleEntity, insertInto: viewContext)
            
            tempArticle.setValue(article.title, forKey: "title")
            tempArticle.setValue(article.author, forKey: "author")
            tempArticle.setValue(article.publicationDate, forKey: "publicationDate")
            tempArticle.setValue(article.abstract, forKey: "abstract")
        }
        
        CoreDataStack.shared.save() // Se guardan los cambios
    } // func saveData
    
    
    
    // Este metodo es para borrar los articulos viejos de la memoria del
    // dispositivo
    func deleteArticlesInLocalStorage() -> Bool {
        
        // Se crea el fetchRequest para todos los objetos Article en memoria
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleDataModel")
        
        let viewContext = context ?? persistentContainer.viewContext
        
        do {
            let oldArticles = try viewContext.fetch(fetchRequest) // Se hace el fetch para obtener resultados
            
            // Se eliminan uno a uno los articulos almacenados
            for article in oldArticles {
                viewContext.delete(article as! NSManagedObject)
            }
            
            return true
        } catch(let e) {
            // Si no se pueden eliminar los articulos, entonces no se puede proceder con la operacion
            print("No se pudo eliminar los articulos almacenados en memoria: \(e.localizedDescription)")
            
            return false
        }
    } // func deleteArticlesInLocalStore
    
    
}
