//
//  NetworkService.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case server(Int)
    case decoding(Error)
}

final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        print("\(Date()): API url : \(url)")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let e = error { completion(.failure(.transport(e))); return }
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                completion(.failure(.server(http.statusCode))); return
            }
            guard let data = data else { completion(.failure(.invalidURL)); return }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let obj = try decoder.decode(T.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }
        task.resume()
    }
}
