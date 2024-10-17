//
//  HomeScreenViewModel.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 13/10/24.
//

import Foundation
import SwiftUI

class HomeScreenViewModel: ObservableObject {
    
    @Published var navigationPath = NavigationPath()
    @Published var articles = [Article]()
    @Published var wifiAvailable = true
    @Published var serverAvailable = true
    @Published var isLoading = true
    
    let session: URLSession
    let network: Network
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
        self.network = Network(session: session)
    }
    
    
    // MARK: - Metodo para hacer el llamado a la API o para manejar errores
    func fetchArticles() {
        self.network.fetchMostPopularArticles() { result in
            
            // En caso de que la llamada fuese exitosa
            switch result {
            case .success(let articlesData):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.wifiAvailable = true
                    self.serverAvailable = true
                    self.articles = articlesData // Se asignan los articulos a la variable para mostrarse en la vista
                }
               
            // En caso de de que la llamada no funcione
            case .failure(let error):
                // Se verifica el tipo de error
                if error == .wifiError {
                    DispatchQueue.main.async {
                        self.wifiAvailable = false
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.serverAvailable = false
                    }
                    
                }
                
                
                // En caso de haber articulos almacenados en el telefono, se recuperan
                // y se guardan en la variable articles para mostrarlos en la vista
                Task {
                    if let articles = await CoreDataStack.shared.fetchStoredData() {
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.articles = articles
                        }
                    }
                } // task
                
            }
        } // func fetchArticles
    }
    
    func addArticleToPath(_ article: Article) {
        DispatchQueue.main.async {
            self.navigationPath.append(article)
        }
    } // func
}
