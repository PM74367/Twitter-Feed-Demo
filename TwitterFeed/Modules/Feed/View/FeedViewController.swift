//
//  FeedViewController.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//

import UIKit

final class FeedViewController: UIViewController {

    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()

    // MARK: - Loading UI

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No tweets available"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.isHidden = true
        return label
    }()

    private let paginationSpinner = UIActivityIndicatorView(style: .medium)

    private var tweets: [Tweet] = []

    var presenter: FeedPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true

        // MARK: - TableView

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        tableView.register(
            TweetCell.self,
            forCellReuseIdentifier: TweetCell.reuseIdentifier
        )

        // MARK: - Refresh Control

        refreshControl.addTarget(
            self,
            action: #selector(refreshFeed),
            for: .valueChanged
        )

        tableView.refreshControl = refreshControl

        // MARK: - Activity Indicator

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        // MARK: - Empty State

        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Error Label

        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - Pagination Spinner

        paginationSpinner.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        paginationSpinner.hidesWhenStopped = true

        // MARK: - Add Subviews

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        view.addSubview(errorLabel)

        // MARK: - Constraints

        NSLayoutConstraint.activate([

            // TableView

            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            // Activity Indicator

            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),

            // Empty State

            emptyStateLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            emptyStateLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),

            emptyStateLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 20
            ),

            emptyStateLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -20
            ),

            // Error Label

            errorLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            errorLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),

            errorLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),

            errorLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            )
        ])
    }

    @objc private func refreshFeed() {
        presenter.refresh()
    }

    private func hideStateViews() {
        emptyStateLabel.isHidden = true
        errorLabel.isHidden = true
    }
}

// MARK: - UITableView

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return tweets.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let tweetCell = tableView.dequeueReusableCell(
            withIdentifier: TweetCell.reuseIdentifier,
            for: indexPath
        ) as? TweetCell

        tweetCell?.configure(with: tweets[indexPath.row])

        return tweetCell ?? UITableViewCell()
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == tweets.count - 2 {
            presenter.loadMore()
        }
    }
}

// MARK: - FeedView

extension FeedViewController: FeedView {

    func showLoading() {
        hideStateViews()

        if tweets.isEmpty {
            activityIndicator.startAnimating()
        } else {
            paginationSpinner.startAnimating()
            tableView.tableFooterView = paginationSpinner
        }
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        paginationSpinner.stopAnimating()
        tableView.tableFooterView = nil
    }

    func showTweets(_ tweets: [Tweet]) {
        hideStateViews()

        self.tweets = tweets
        tableView.reloadData()
    }

    func appendTweets(_ tweets: [Tweet]) {
        let startIndex = self.tweets.count

        self.tweets.append(contentsOf: tweets)

        let endIndex = self.tweets.count

        let indexPaths = (startIndex..<endIndex).map {
            IndexPath(row: $0, section: 0)
        }

        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }

    func showEmptyState() {
        hideLoading()

        tweets.removeAll()
        tableView.reloadData()

        emptyStateLabel.isHidden = false
    }

    func showError(_ message: String) {
        hideLoading()

        errorLabel.text = message
        errorLabel.isHidden = false

        if tweets.isEmpty {
            tableView.isHidden = true
        }

        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }

    func stopRefreshing() {
        refreshControl.endRefreshing()
    }

    func stopPaginationLoading() {
        paginationSpinner.stopAnimating()
        tableView.tableFooterView = nil
    }
}
