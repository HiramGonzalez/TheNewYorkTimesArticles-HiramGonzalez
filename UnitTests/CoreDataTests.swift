//
//  CoreDataTests.swift
//  ViewModelTests
//
//  Created by Hiram González on 16/10/24.
//

import XCTest
import CoreData
@testable import PruebaTecnicaHiramGonzalez

final class CoreDataTests: XCTestCase {
    
    var coreDataManager: CoreDataStack!
    var testContext: NSManagedObjectContext!
    

    override func setUpWithError() throws {
        self.testContext = CoreDataTestStack.shared.viewContext
        self.coreDataManager = CoreDataStack(context: self.testContext)
    }

    override func tearDownWithError() throws {
        self.testContext = nil
        self.coreDataManager = nil
    }

    // MARK: - Este metodo sirve para testear que se estan guardando los datos en el dispositivo
    func testSaveData() throws {
        let dataToSave = [Article(title: "Is Green Tea Really ‘Nature’s Ozempic’?",
                                  author: "By Dani Blum",
                                  publicationDate: "2024-09-24",
                                  abstract: "Here’s what experts said about the beverage’s link to weight loss.")
        ]
        
        
        coreDataManager.saveData(dataToSave)
        
        Task {
            let fetchedData = await coreDataManager.fetchStoredData()
            
            if let articles = fetchedData {
                XCTAssertEqual(articles.count, 1)
                XCTAssertEqual(articles.first?.title, dataToSave.first?.title)
                XCTAssertEqual(articles.first?.author, dataToSave.first?.author)
                XCTAssertEqual(articles.first?.publicationDate, dataToSave.first?.publicationDate)
                XCTAssertEqual(articles.first?.abstract, dataToSave.first?.abstract)
            } else {
                XCTFail("Nil value obtained from local storage.")
            }
        }
    } // func
    
    
    // MARK: - Este metodo sirve para testear la funcion fetch para los datos
    func testFetchData() {
        let dataToSave = [Article(title: "Small-Town Pennsylvania Is Changing, and Democrats See Opportunity",
                                  author: "By Campbell Robertson, Robert Gebeloff and Rachel Wisniewski For The New York Times",
                                  publicationDate: "2024-10-16",
                                  abstract: "Lancaster County, famous for its Amish communities, regularly votes Republican. But the demographics are shifting here and throughout the state.")
        ]
        
        
        coreDataManager.saveData(dataToSave)
        
        Task {
            let fetchedData = await coreDataManager.fetchStoredData()
            
            if let articles = fetchedData {
                XCTAssertEqual(articles.count, 1)
                XCTAssertEqual(articles.first?.title, dataToSave.first?.title)
                XCTAssertEqual(articles.first?.author, dataToSave.first?.author)
                XCTAssertEqual(articles.first?.publicationDate, dataToSave.first?.publicationDate)
                XCTAssertEqual(articles.first?.abstract, dataToSave.first?.abstract)
            } else {
                XCTFail("Nil value obtained from local storage.")
            }
        }
    } // func
    
    
    // MARK: - Este metodo sirve para testear el metodo de eliminar datos en memoria
    func testDeleteArticles() {
        let storedData = [Article(title: "Is Green Tea Really ‘Nature’s Ozempic’?",
                                  author: "By Dani Blum",
                                  publicationDate: "2024-09-24",
                                  abstract: "Here’s what experts said about the beverage’s link to weight loss.")
        ]
        
        
        coreDataManager.saveData(storedData) // Se guarda un elemento de prueba
        
        
        let result = coreDataManager.deleteArticlesInLocalStorage()
        XCTAssertTrue(result) // Se verifica que la funcion se ejecuto correctamente
        
        
        // Ahora se comprobara que el array esta vacio
        Task {
            let fetchedData = await coreDataManager.fetchStoredData()
            
            if let articles = fetchedData {
                XCTAssertEqual(articles.count, 0) // Se verifica que el array no tiene elementos
            } else {
                XCTFail("Nil value obtained from local storage.")
            }
        }
    } // func
    

}
