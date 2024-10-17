//
//  ViewModelTests.swift
//  ViewModelTests
//
//  Created by Hiram González on 16/10/24.
//

import XCTest
import Combine
@testable import PruebaTecnicaHiramGonzalez


final class ViewModelTests: XCTestCase {
    
    var viewModel: HomeScreenViewModel!
    var cancellables: AnyCancellable?

    override func setUpWithError() throws {
        // Se configura el objeto Network para el test de una llamada a la API
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        viewModel = HomeScreenViewModel(session: session)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = nil
    }

    
    // MARK: - Este test sirve para probar que los articulos son cargados correctamente
    func testFetchArticles() {
        // Se obtienen los datos de prueba
        guard let url = Bundle(for: type(of: self)).url(forResource: "JSONResponseTest", withExtension: "json") else {
            XCTFail("Could not find JSON Test file.")
            return
        }
        
        // El array que se espera obtener luego de la prueba
        let expectedFinalResult = [Article(title: "Is Green Tea Really ‘Nature’s Ozempic’?",
                                           author: "By Dani Blum",
                                           publicationDate: "2024-09-24",
                                           abstract: "Here’s what experts said about the beverage’s link to weight loss.")
        ]
        
        do {
            let data = try Data(contentsOf: url)
            // Se crea la respuesta de prueba de la API
            MockURLProtocol.mockResponses[url] = (data: data, response: nil, error: nil)
            
            
            viewModel.fetchArticles()
            
            // Se comprueba que los datos sean los esperados
            cancellables = viewModel.objectWillChange.eraseToAnyPublisher().sink { _ in
                XCTAssertEqual(self.viewModel.articles.count, 1)
                XCTAssertEqual(self.viewModel.articles.first?.title, expectedFinalResult.first?.title)
                XCTAssertEqual(self.viewModel.articles.first?.author, expectedFinalResult.first?.author)
                XCTAssertEqual(self.viewModel.articles.first?.publicationDate, expectedFinalResult.first?.publicationDate)
                XCTAssertEqual(self.viewModel.articles.first?.abstract, expectedFinalResult.first?.abstract)
                XCTAssertTrue(self.viewModel.wifiAvailable)
                XCTAssertTrue(self.viewModel.serverAvailable)
                XCTAssertFalse(self.viewModel.isLoading)
            }
            
        } catch {
            XCTFail("URL does not contain JSON test file.")
        }
    } // func
    
    
    
    // MARK: - Este test sirve para testear que cada Article se agrega correctamente al path
    func testAddArticleToPath() throws {
        let article = Article(title: "Is Green Tea Really ‘Nature’s Ozempic’?",
                              author: "By Dani Blum",
                              publicationDate: "2024-09-24",
                              abstract: "Here’s what experts said about the beverage’s link to weight loss.")
        
        
        viewModel.addArticleToPath(article)
        
        cancellables = viewModel.objectWillChange.eraseToAnyPublisher().sink { _ in
            XCTAssertEqual(self.viewModel.navigationPath.count, 1)
        }
        
        
    }


}
