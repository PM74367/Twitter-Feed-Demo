//
//  FeedPresenter.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//

import Foundation

protocol FeedView: AnyObject {
    func showLoading()
    func hideLoading()

    func showTweets(_ tweets: [Tweet])
    func appendTweets(_ tweets: [Tweet])

    func showEmptyState()
    func showError(_ message: String)

    func stopRefreshing()
    func stopPaginationLoading()
}

protocol FeedPresenterProtocol {
    func viewDidLoad()
    func refresh()
    func loadMore()
}

final class FeedPresenter: FeedPresenterProtocol {

    weak var view: FeedView?

    private let interactor: FeedInteractor

    private var tweets: [Tweet] = []
    private var isLoading = false
    private var nextCursor: String?

    init(view: FeedView,
         interactor: FeedInteractor) {
        self.view = view
        self.interactor = interactor
    }

    func viewDidLoad() {
        loadTweets(isRefresh: false)
    }

    func refresh() {
        loadTweets(isRefresh: true)
    }

    func loadMore() {
        guard !isLoading, nextCursor != nil else { return }
        loadTweets(isRefresh: false)
    }

    private func loadTweets(isRefresh: Bool) {

        isLoading = true

        if self.tweets.isEmpty && !isRefresh {
            view?.showLoading()
        }

        interactor.fetchTweets(cursor: nextCursor) { [weak self] result in

            guard let self else { return }

            self.isLoading = false

            self.view?.hideLoading()
            self.view?.stopRefreshing()
            self.view?.stopPaginationLoading()

            switch result {

            case .success(let tweetModel):
                let tweets = tweetModel.tweets
                self.nextCursor = tweetModel.nextCursor

                self.tweets.append(contentsOf: tweets)
                if tweets.isEmpty {
                    self.view?.showEmptyState()
                } else {
                    self.view?.showTweets(self.tweets)
                }


            case .failure(let error):

                if self.tweets.isEmpty || isRefresh {
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
