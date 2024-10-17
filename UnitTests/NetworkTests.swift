//
//  NetworkTests.swift
//  ViewModelTests
//
//  Created by Hiram González on 16/10/24.
//

import XCTest
//import JSONRespo
@testable import PruebaTecnicaHiramGonzalez


final class NetworkTests: XCTestCase {
    
    
    var network = Network()

    override func setUpWithError() throws {
        // Se configura el objeto Network para el test de una llamada a la API
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        network = Network(session: session)
    }

    override func tearDownWithError() throws { }
    
    
    // Test para comprobar el resultado de la llamada a la API
    func testSuccessfulAPICall() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "JSONResponseTest", withExtension: "json") else {
            XCTFail("Could not find JSON Test file.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            // Se crea la respuesta de prueba de la API
            MockURLProtocol.mockResponses[url] = (data: data, response: nil, error: nil)
            
            // Resultado esperado
            let expectedFinalResult = [Article(title: "Is Green Tea Really ‘Nature’s Ozempic’?",
                                               author: "By Dani Blum",
                                               publicationDate: "2024-09-24",
                                               abstract: "Here’s what experts said about the beverage’s link to weight loss.")
            ]
            
            network.fetchMostPopularArticles { result in
                switch result {
                case .success(let successData):
                    
                    // Se evalua si el resultado final es igual al esperado
                    XCTAssertEqual(successData.first?.title, expectedFinalResult.first?.title)
                    XCTAssertEqual(successData.first?.author, expectedFinalResult.first?.author)
                    XCTAssertEqual(successData.first?.publicationDate, expectedFinalResult.first?.publicationDate)
                    XCTAssertEqual(successData.first?.abstract, expectedFinalResult.first?.abstract)
                    
                case .failure(let e):
                    // En caso de error
                    XCTFail("Call should have been successful, but didn't.")
                }
                
            }
            
        } catch {
            XCTFail("URL does not contain JSON test file.")
        }

    }
    
    
    // Test para comprobar que se decodifica el JSON de forma correcta
    func testDecodeJSON() throws {
        // Resultado esperado
        let expectedFinalResult: [ArticleJSONObject]? = [
            ArticleJSONObject(published_date: "2024-09-24",
                              byline: "By Dani Blum",
                              title: "Is Green Tea Really ‘Nature’s Ozempic’?",
                              abstract: "Here’s what experts said about the beverage’s link to weight loss.")
        
        ]
        
        
        if let url = Bundle(for: type(of: self)).url(forResource: "JSONResponseTest", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: url)
                
                let decodedResponse = network.decodeJSON(data: data)
                // Se evalua si el resultado final es igual al esperado
                XCTAssertEqual(decodedResponse?.results?.first?.title, expectedFinalResult?.first?.title)
                XCTAssertEqual(decodedResponse?.results?.first?.byline, expectedFinalResult?.first?.byline)
                XCTAssertEqual(decodedResponse?.results?.first?.published_date, expectedFinalResult?.first?.published_date)
                XCTAssertEqual(decodedResponse?.results?.first?.abstract, expectedFinalResult?.first?.abstract)
            } catch {
                XCTFail("URL does not contain JSON test file.")
            }
        } else {
            XCTFail("URL to JSON file not found.")
        }
    } // func testDecodeJSON
    
    
    func testConvertToArticleArray() {
        // Array decodificado del JSON a convertir
        let originalArray: [ArticleJSONObject] = [
            ArticleJSONObject(published_date: "2024-09-24",
                              byline: "By Dani Blum",
                              title: "Is Green Tea Really ‘Nature’s Ozempic’?",
                              abstract: "Here’s what experts said about the beverage’s link to weight loss.")
        ]
        
        
        // Array que esperamos obtener al final
        let expectedFinalResult = [Article(title: "Is Green Tea Really ‘Nature’s Ozempic’?",
                                           author: "By Dani Blum",
                                           publicationDate: "2024-09-24",
                                           abstract: "Here’s what experts said about the beverage’s link to weight loss.")
        ]
        
        let result = network.convertToArticleArray(from: originalArray)
        
        XCTAssertEqual(result.first?.title, expectedFinalResult.first?.title)
        XCTAssertEqual(result.first?.author, expectedFinalResult.first?.author)
        XCTAssertEqual(result.first?.publicationDate, expectedFinalResult.first?.publicationDate)
        XCTAssertEqual(result.first?.abstract, expectedFinalResult.first?.abstract)
    }
    
    // Se comprueba si la funcion para verificar el estado del WiFi funciona correctamente
    func testNetworkVerification() {
        let result = network.checkWifiStatus()
        
        XCTAssertNotNil(result)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
