//
//  ContentView.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 13/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = HomeScreenViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                if !viewModel.articles.isEmpty {
                    List(viewModel.articles) { article in
                        ArticleThumbnail(article: article)
                            .onTapGesture {
                                viewModel.addArticleToPath(article)
                            }
                    }
                    .listRowSpacing(10)
                    
                    
                } else {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.8)
                    } else {
                        VStack(spacing: 10) {
                            if !viewModel.wifiAvailable {
                                Image(systemName: "wifi.exclamationmark")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                Text("Tu dispositivo no tiene conexión a internet y no hay artículos almacenados localmente para leer. Conectate a internet y vuelve a intentarlo.")
                            } else {
                                Image(systemName: "xmark.icloud")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                Text("Hubo un error en la conexión con los servidores de The New York Times y no tienes artículos almacenados localmente para leer. Vuelve a intentarlo más tarde.")
                            }
                                
                        } // Vstack
                        .padding(.horizontal)
                    }
                    
                } // else
            } // Zstack
            .navigationDestination(for: Article.self) { article in
                ArticleView(article: article)
            }
            .navigationTitle("The New York Times")
        } // NavStack
        
        .onAppear {
            viewModel.fetchArticles()
        }
    }
}

#Preview {
    ContentView()
}
