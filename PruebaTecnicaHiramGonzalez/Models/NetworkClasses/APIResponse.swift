//
//  APIResponse.swift
//  PruebaTecnicaHiramGonzalez
//
//  Created by Hiram González on 13/10/24.
//

import Foundation

struct APIResponse: Decodable {
    
    let results: [ArticleJSONObject]?
    
}


struct ArticleJSONObject: Equatable, Decodable {
    let published_date: String?
    let byline: String?
    let title: String?
    let abstract: String?
}
