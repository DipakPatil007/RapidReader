//
//  ArticlesListViewModel.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//

import Foundation

final class ArticlesListViewModel {
    private let repository: ArticleRepositoryProtocol
    private(set) var articles: [Article] = [] {
        didSet { self.onUpdate?() }
    }
    var filtered: [Article] = [] { didSet { self.onUpdate?() } }

    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?

    init(repo: ArticleRepositoryProtocol = ArticleRepository()) {
        self.repository = repo
    }

    func loadCached() {
        self.articles = repository.fetchCachedArticles()
        self.filtered = articles
    }

    func refresh() {
        repository.fetchRemoteArticles { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let arts):
                    self.articles = arts
                    self.repository.saveArticlesToCache(arts)
                    self.filtered = arts
                case .failure(let e):
                    self.onError?(e)
                }
            }
        }
    }

    func search(query: String) {
        if query.isEmpty { filtered = articles; return }
        filtered = articles.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    func toggleBookmark(article: Article) -> Bool {
        repository.toggleBookmark(articleID: article.id)
        return repository.isArticleBookmarked(articleID: article.id)
    }

    func isBookMarked(article : Article) -> Bool {
        return repository.isArticleBookmarked(articleID: article.id)
    }
}
