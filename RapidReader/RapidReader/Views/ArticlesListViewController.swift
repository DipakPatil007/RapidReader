//
//  ArticlesListViewController.swift
//  Rapid-Reader
//
//  Created by Dipak on 16/09/25.
//

import UIKit

final class ArticlesListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = ArticlesListViewModel()
    private let refreshControl = UIRefreshControl()
    private var isBookMark = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Headlines"
        view.backgroundColor = .systemBackground
        setupTable()
        bind()
        viewModel.loadCached()
        viewModel.refresh()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    private func setupTable() {
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        refreshControl.addTarget(self, action: #selector(pulled), for: .valueChanged)
        tableView.refreshControl = refreshControl

        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.delegate = self
    }

    private func bind() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        viewModel.onError = { [weak self] err in
            self?.refreshControl.endRefreshing()
            let ac = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }

    @objc private func pulled() {
        viewModel.refresh()
    }

}

extension ArticlesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filtered.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
        let article = viewModel.filtered[indexPath.row]
        let isBookmarked = viewModel.isBookMarked(article: article)
        cell.configure(with: article, isBookMark: isBookmarked)
        cell.bookmarkAction = { [weak self] in
            let isBookMark = self?.viewModel.toggleBookmark(article: article)
            cell.configure(with: article, isBookMark: isBookMark!)
        }
        return cell
    }
}

extension ArticlesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.filtered[indexPath.row]
        let vc = ArticleDetailViewController(article: article)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArticlesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(query: "")
    }
}
