//
//  CDArticle+Mapping.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//

import CoreData
import Foundation

extension CDArticle {
    func populate(from article: Article) {
        self.id = article.id
        self.title = article.title
        self.author = article.author
        self.articleDescription = article.description
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        if self.isBookmarked == nil { self.isBookmarked = false }
    }

    func toArticle() -> Article {
        Article(id: id ?? "", title: title ?? "Untitled", author: author, description: articleDescription, url: url ?? "", urlToImage: urlToImage, publishedAt: publishedAt)
    }
}
