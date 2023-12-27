//
//  NewsService.swift
//  AccessibilitySwiftUI
//
//  Created by Keto Nioradze on 27.12.23.
//

import Foundation

enum ServiceError: Error {
    case invalidUrl
}


struct NewsService {

    let urlSession: URLSession
    let jsonDecoder: JSONDecoder
    
    init(
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func getNews() async throws -> [NewsModel] {
        var urlComponents = URLComponents(string: Constants.baseUrl)
        let apiTokenQueryItem = URLQueryItem(name: Constants.tokenKey, value: Constants.tokenValue)
        let searchQueryItem = URLQueryItem(name: Constants.searchKey, value: Constants.searchValue)
        urlComponents?.queryItems = [apiTokenQueryItem, searchQueryItem]
        
        guard let url = urlComponents?.url else { throw ServiceError.invalidUrl }
        
        let request = URLRequest(url: url)
        let result = try await urlSession.data(for: request)
        let response = try jsonDecoder.decode(NewsResponse.self, from: result.0)
        return response.news
    }
}

extension NewsService {
    enum Constants {
        static let baseUrl = "https://api.thenewsapi.com/v1/news/all"
        static let tokenValue = "MN4WLkdQCb6T285DxH0S8H4hm2rxdafiFf3Nxdm9"
        static let tokenKey = "api_token"
        static let searchKey = "search"
        static let searchValue = "Georgia"
    }
}
