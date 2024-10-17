//
//  ArticleThumbnail.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 13/10/24.
//

import SwiftUI

struct ArticleThumbnail: View {
    
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .lineLimit(1)
                .font(.system(size: 20))
                .bold()
            
            HStack {
                Text("\(article.author)")
                
                Text("•")
                
                Text("\(article.publicationDate)")
            }
            .foregroundStyle(.gray)
            .lineLimit(1)
            
            HStack {
                Text(article.abstract)
                    .lineLimit(1)
                    .padding(.top, 3)
                
                Text("Ver más")
                    .foregroundStyle(.blue)
            }
            
        } // VStack
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))

    }
}

#Preview {
    ZStack {
        Color.gray
        ArticleThumbnail(article: Article(title: "Test Ttitle", author: "Test Author", publicationDate: "10/20/24", abstract: "Publication Date: 10/20/24Publication Date: 10/20/24Publication Date: 10/20/24Publication Date: 10/20/24Publication Date: 10/20/24Publication Date: 10/2"))
    }
}
