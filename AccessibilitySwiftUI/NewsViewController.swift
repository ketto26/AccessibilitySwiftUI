//
//  NewsViewController.swift
//  AccessibilitySwiftUI
//
//  Created by Keto Nioradze on 27.12.23.
//

import UIKit
import SwiftUI

class NewsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    internal var newsViewModel: NewsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsViewModel.onDidFetch = { [weak self] in self?.didFetch() }
        setupLayout()
        Task {
            do {
                try await newsViewModel.viewDidLoad()
            } catch {
                showAlert(with: error)
            }
        }
    }
    
    func showAlert(with error: Error) {
        let alertController = UIAlertController(title: "Error happened", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        tableView.bounces = false
        title = "News App"
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.dataSource = self
    }

}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsItem = newsViewModel.news[indexPath.row]
        let cell = UITableViewCell()
        var configuration = cell.defaultContentConfiguration()
        configuration.text = newsItem.title
        configuration.secondaryText = newsItem.description
        cell.contentConfiguration = configuration
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = "News Cell \(indexPath.row + 1)"
        cell.accessibilityValue = newsItem.title + newsItem.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.news.count
    }
}

extension NewsViewController {
    func didFetch() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


struct NewsControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = NewsViewController

    func makeUIViewController(context: Context) -> NewsViewController {
        let controller = NewsViewController()
        let viewModel = NewsViewModel(
            newsService: NewsService(
                urlSession: .shared
            )
        )
        
        controller.newsViewModel = viewModel
        return controller
    }

    func updateUIViewController(_ uiViewController: NewsViewController, context: Context) {
        // Update your view controller if needed
    }
}
