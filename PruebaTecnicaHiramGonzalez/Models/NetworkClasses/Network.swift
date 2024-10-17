//
//  Network.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 13/10/24.
//

import Foundation
import Network

struct Network {
    
    let urlString = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=qTl6HA9lEk9bHwEMNSrdjRAceMnSqQEZ"
    let monitor = NWPathMonitor()
    let session: URLSession

    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    

    // MARK: - El metodo principal que se usa para hacer el request a la API
    func fetchMostPopularArticles(completion: @escaping (Result<[Article], CustomErrors>) -> Void) {
        
        // Primero se verifica el estado de la conexion a internet
        if !checkWifiStatus() {
            completion(.failure(CustomErrors.wifiError)) // En caso de error, se cancela la operacion
        }
        
        // Se crea el objeto URL para hacer el request
        guard let url = URL(string: urlString) else {
            // En caso de error, se cancela la operacion
            completion(.failure(CustomErrors.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        // Se crea el objeto task que realiza la peticion a la API
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                // En caso de recibir un error, se informa en consola
                print("Error at fetching: \(error.localizedDescription)")
                completion(.failure(.invalidAPIResponse))
            }
            
            
            // En caso de recibir datos en formato JSON, se decodifica
            if let data = data {
                let decodedResult = self.decodeJSON(data: data)
                
                guard let decodedArray = decodedResult?.results else {
                    // En caso de fallar en la decodificacion, se cancela
                    // la operacion
                    completion(.failure(CustomErrors.decodingFailed))
                    return
                }
                
                // Se almacenan los articulos en formato JSON a objetos Article
                let articles = convertToArticleArray(from: decodedArray)
                
                // Se almacenan los nuevos articulos en la memoria del telefono
                // como un proceso en segundo plano
                DispatchQueue.global(qos: .background).async {
                    saveArticlesInLocalMemory(articles)
                }
                
                // Se completa la operacion devolviendo los articulos
                completion(.success(articles))
            } // if data
        }
        
        task.resume()
    } // func fetchMostPopularArticles
    
    
    // Este metodo es para decodificar el JSON recibido de la API a objetos Swift
    func decodeJSON(data: Data) -> APIResponse? {
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedResults = try jsonDecoder.decode(APIResponse.self, from: data)
            return decodedResults
        } catch {
            print("Could not decode data from API Response.")
            return nil
        }
    } // func decodeJSON
    
    
    
    // Este metodo sirve para convertir objetos ArticleJSONObject a Article
    func convertToArticleArray(from decodedArticles: [ArticleJSONObject]) -> [Article] {
        // Se almacenan los articulos en formato JSON a objetos Article
        var articles = [Article]()
        for article in decodedArticles {
            let newArticle = Article(title: article.title ?? "",
                                     author: article.byline ?? "N/A",
                                     publicationDate: article.published_date ?? "N/D",
                                     abstract: article.abstract ?? "")
            
            articles.append(newArticle)
        }
        
        return articles
    }
    
    
    
    // Este metodo sirve para verificar el estado del WiFi del dispositivo
    func checkWifiStatus() -> Bool {
        var result: Bool = true
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                result = true // Es caso de haber conexion WiFi, devolvera True
            } else {
                result = false // En caso contrario, devolvera False
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        return result
    } // func checkWifiStatus
    
    
    // Este metodo sirve para invocar al metodo que almacena los datos en la memoria
    func saveArticlesInLocalMemory(_ articles: [Article]) {
        CoreDataStack.shared.saveData(articles)
    }
}
