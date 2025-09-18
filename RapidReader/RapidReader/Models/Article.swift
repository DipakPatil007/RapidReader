//
//  Article.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//
import Foundation

struct ArticleResponse: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
}

struct Article: Decodable, Equatable {
    let id: String
    let title: String
    let author: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date?
    let source: Source?

    // MARK: - Memberwise initializer for manual creation
    init(id: String = UUID().uuidString,
         title: String,
         author: String? = nil,
         description: String? = nil,
         url: String,
         urlToImage: String? = nil,
         publishedAt: Date? = nil,
         source: Source? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.source = source
    }
    
    // Custom init for generating `id`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = UUID().uuidString // always generate our own id
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.url = try container.decode(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.publishedAt = try container.decodeIfPresent(Date.self, forKey: .publishedAt)
        self.source = try container.decodeIfPresent(Source.self, forKey: .source)
    }

    enum CodingKeys: String, CodingKey {
        case title
        case author
        case description
        case url
        case urlToImage
        case publishedAt
        case source
    }
}

struct Source: Decodable, Equatable {
    let id: String?
    let name: String?
}
