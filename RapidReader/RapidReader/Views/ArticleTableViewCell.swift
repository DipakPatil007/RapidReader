//
//  ArticleTableViewCell.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//
import UIKit

final class ArticleTableViewCell: UITableViewCell {
    static let identifier = "ArticleCell"
    private let thumb = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let bookmarkButton = UIButton(type: .system)
    var bookmarkAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        // Thumbnail
        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.contentMode = .scaleAspectFill
        thumb.clipsToBounds = true
        thumb.layer.cornerRadius = 8
        thumb.layer.masksToBounds = true
        thumb.widthAnchor.constraint(equalToConstant: 100).isActive = true
        thumb.heightAnchor.constraint(equalToConstant: 100).isActive = true
        thumb.backgroundColor = UIColor.secondarySystemBackground

        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label

        // Author
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        authorLabel.textColor = .secondaryLabel

        // Bookmark button
        bookmarkButton.setTitle("☆ Bookmark", for: .normal)
        bookmarkButton.setTitleColor(tintColor, for: .normal)
        bookmarkButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        bookmarkButton.backgroundColor = UIColor.systemGray6
        bookmarkButton.layer.cornerRadius = 6
        bookmarkButton.layer.borderWidth = 0.5
        bookmarkButton.layer.borderColor = UIColor.systemGray3.cgColor
        bookmarkButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)

        // Vertical stack
        let vStack = UIStackView(arrangedSubviews: [titleLabel, authorLabel, bookmarkButton])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 6
        vStack.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        contentView.addSubview(thumb)
        contentView.addSubview(vStack)

        NSLayoutConstraint.activate([
            thumb.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            thumb.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumb.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            vStack.leadingAnchor.constraint(equalTo: thumb.trailingAnchor, constant: 14),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            vStack.centerYAnchor.constraint(equalTo: thumb.centerYAnchor)
        ])

        // Cell styling
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
    }

    func configure(with article: Article, isBookMark: Bool) {
        titleLabel.text = article.title
        authorLabel.text = article.author ?? "Unknown"
        // change the state of the bookmark
        updateBookmarkButton(isBookmarked: isBookMark)
        thumb.image = nil
        if let urlStr = article.urlToImage, let url = URL(string: urlStr) {
            ImageCache.shared.image(for: url) { [weak self] img in
                DispatchQueue.main.async { self?.thumb.image = img }
            }
        }
    }

    @objc private func bookmarkTapped() {
        UIView.animate(withDuration: 0.15,
                       animations: { self.bookmarkButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) },
                       completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.bookmarkButton.transform = .identity
            }
        })
        bookmarkAction?()
    }

    private func updateBookmarkButton(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.setTitle("★ Bookmarked", for: .normal)
            bookmarkButton.setTitleColor(.systemYellow, for: .normal)
            bookmarkButton.layer.borderColor = UIColor.systemYellow.cgColor
        } else {
            bookmarkButton.setTitle("☆ Bookmark", for: .normal)
            bookmarkButton.setTitleColor(tintColor, for: .normal)
            bookmarkButton.layer.borderColor = UIColor.systemGray3.cgColor
        }
    }
}
