//
//  ImageCache.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    func image(for url: URL, completion: @escaping (UIImage?) -> Void) {
        if let img = cache.object(forKey: url.absoluteString as NSString) { completion(img); return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let d = data, let img = UIImage(data: d) else { completion(nil); return }
            self.cache.setObject(img, forKey: url.absoluteString as NSString)
            completion(img)
        }.resume()
    }
}
