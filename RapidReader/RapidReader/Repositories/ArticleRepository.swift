//
//  ArticleRepository.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//

import Foundation
import CoreData

protocol ArticleRepositoryProtocol {
    func fetchRemoteArticles(completion: @escaping (Result<[Article], Error>) -> Void)
    func fetchCachedArticles() -> [Article]
    func saveArticlesToCache(_ articles: [Article])
    func toggleBookmark(articleID: String)
    func fetchBookmarkedArticles() -> [Article]
    func isArticleBookmarked(articleID: String) -> Bool
}

final class ArticleRepository: ArticleRepositoryProtocol {
    private let network: NetworkService
    private let core = CoreDataStack.shared

    // Example endpoint: replace with your API and key
    private let apiURLString = Constant.data.apiURLString + (Constant.data.apiKey ?? "")

    init(network: NetworkService = .shared) {
        self.network = network
    }

    func fetchRemoteArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = URL(string: apiURLString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        network.fetch(url: url) { (result: Result<ArticleResponse, NetworkError>) in
            switch result {
                case .success(let response):
                    // No need to map again if Article already generates its own id
                    print("\(Date()) Response received...")
                    completion(.success(response.articles))
                case .failure(let error):
                    print("\(Date()) Error while fetching data from server...")
                    completion(.failure(error))
            }
        }
    }

    func fetchCachedArticles() -> [Article] {
        let ctx = core.viewContext
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        do {
            let results = try ctx.fetch(req)
            return results.map { $0.toArticle() }
        } catch {
            print("Fetch cached error: \(error)")
            return []
        }
    }

    func saveArticlesToCache(_ articles: [Article]) {
        let ctx = core.viewContext
        articles.forEach { article in
            let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", article.id)
            if let existing = (try? ctx.fetch(req))?.first {
                existing.populate(from: article)
            } else {
                let cd = CDArticle(context: ctx)
                cd.populate(from: article)
            }
        }
        core.saveContext()
    }

    func toggleBookmark(articleID: String) {
        let ctx = core.viewContext
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", articleID)
        if let cd = (try? ctx.fetch(req))?.first {
            cd.isBookmarked.toggle()
            core.saveContext()
        }
    }

    func fetchBookmarkedArticles() -> [Article] {
        let ctx = core.viewContext
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.predicate = NSPredicate(format: "isBookmarked == YES")
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        do {
            return try ctx.fetch(req).map { $0.toArticle() }
        } catch {
            print("bookmarks fetch error: \(error)")
            return []
        }
    }

    func isArticleBookmarked(articleID: String) -> Bool {
        let ctx = core.viewContext
        let req: NSFetchRequest<CDArticle> = CDArticle.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", articleID)
        return ((try? ctx.fetch(req))?.first?.isBookmarked) ?? false
    }
}
