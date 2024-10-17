//
//  ArticleView.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 13/10/24.
//

import SwiftUI

struct ArticleView: View, Hashable {
    
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.largeTitle)
                    .bold()
                
                if article.author.count >= 18 {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(article.author)
                        
                        Text("Publication Date: \(article.publicationDate)")
                    }
                    .foregroundStyle(.gray)
                    .font(.system(size: 17))
                } else {
                    HStack {
                        Text(article.author)
                        
                        Text("Publication Date: \(article.publicationDate)")
                    }
                    .foregroundStyle(.gray)
                    .font(.system(size: 17))
                }
    
                
                Text(article.abstract)
                    .padding(.top, 3)
                    .font(.system(size: 20))
            } // VStack
            .padding(.horizontal)
        } // ScrollView
    }
}

#Preview {
    ArticleView(article: Article(title: "Padding didn't work since it only", author: "By Testing Testing, Testing Testing, Testing Testing, Testing Testing, Testing Testing, Testing Testing", publicationDate: "20-27-20", abstract: "padding didn't work since it only increased the size of the item/cell and not the spacing between, but .environment(.defaultMinListRowHeight, 20) seemed to wor"))
}
