//
//  NewsModel.swift
//  AccessibilitySwiftUI
//
//  Created by Keto Nioradze on 27.12.23.
//

import Foundation

struct NewsResponse: Decodable {
    let news: [NewsModel]
    
    enum CodingKeys: String, CodingKey {
        case news = "data"
    }
}

struct NewsModel: Decodable {
    let uuid: UUID
    let title: String
    let description: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case title
        case description
        case imageUrl = "image_url"
    }
}
