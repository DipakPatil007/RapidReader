//
//  BookmarksViewController.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//

import UIKit

final class BookmarksViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let repository = ArticleRepository()
    private var items: [Article] = [] {
        didSet {
            tableView.reloadData()
            updateEmptyState()
        }
    }
    private let refreshControl = UIRefreshControl()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No bookmarks yet ⭐\nSave your favorite articles here."
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        setupTable()
        setupEmptyState()
        loadBookmarks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }

    private func setupTable() {
        tableView.register(ArticleTableViewCell.self,
                           forCellReuseIdentifier: ArticleTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        refreshControl.addTarget(self, action: #selector(pulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupEmptyState() {
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func updateEmptyState() {
        emptyLabel.isHidden = !items.isEmpty
        tableView.isHidden = items.isEmpty
    }

    private func loadBookmarks() {
        items = repository.fetchBookmarkedArticles()
    }

    @objc private func pulled() {
        loadBookmarks()
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ArticleTableViewCell.identifier,
            for: indexPath
        ) as? ArticleTableViewCell else { return UITableViewCell() }

        let article = items[indexPath.row]
        let isBookMark = repository.isArticleBookmarked(articleID: article.id)
        cell.configure(with: article, isBookMark: isBookMark)
        cell.bookmarkAction = { [weak self] in
            guard let self = self else { return }
            self.repository.toggleBookmark(articleID: article.id)
            self.loadBookmarks()
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = items[indexPath.row]
        navigationController?.pushViewController(ArticleDetailViewController(article: article), animated: true)
    }

    // Space between cells
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120 // cell height
        }

        func tableView(_ tableView: UITableView,
                       heightForHeaderInSection section: Int) -> CGFloat {
            return 12 // spacing between cells
        }

        func tableView(_ tableView: UITableView,
                       viewForHeaderInSection section: Int) -> UIView? {
            let spacer = UIView()
            spacer.backgroundColor = .clear
            return spacer
        }
}
