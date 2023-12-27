//
//  NewsViewModel.swift
//  AccessibilitySwiftUI
//
//  Created by Keto Nioradze on 27.12.23.
//

import Foundation

final class NewsViewModel {
    var onDidFetch: (() -> Void)?
    private let newsService: NewsService
    var news: [NewsModel] = []
    
    init(newsService: NewsService) {
        self.newsService = newsService
    }
    
    func viewDidLoad() async throws {
        try await fetchNews()
    }
    
    private func fetchNews() async throws {
        let news = try await newsService.getNews()
        self.news = news
        onDidFetch?()
    }
}
