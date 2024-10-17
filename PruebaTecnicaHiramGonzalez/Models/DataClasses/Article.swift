//
//  Article.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 13/10/24.
//

import Foundation

struct Article: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let author: String
    let publicationDate: String
    let abstract: String
}
