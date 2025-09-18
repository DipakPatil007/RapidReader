//
//  ArticleDetailViewController.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//

import UIKit

final class ArticleDetailViewController: UIViewController {
    private let article: Article
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let textView = UITextView()

    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }

    private func setup() {
        title = article.title
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)

        view.addSubview(imageView)
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 220),

            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        textView.text = article.description ?? "Open in browser: \(article.url)"
        if let urlStr = article.urlToImage, let url = URL(string: urlStr) {
            ImageCache.shared.image(for: url) { [weak self] img in
                DispatchQueue.main.async { self?.imageView.image = img }
            }
        }
    }
}
