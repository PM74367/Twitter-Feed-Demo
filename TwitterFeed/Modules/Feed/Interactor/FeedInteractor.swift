//
//  FeedInteractor.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//


import Foundation

final class FeedInteractor {

    private let service = FeedService()
    private let cache = CacheManager.shared

    private let tweetsCacheFile = "tweets_cache"

    func fetchTweets(
        cursor: String?,
        completion: @escaping (Result<TweetModel, Error>) -> Void
    ) {

        service.fetchTweets(cursor: cursor) { [weak self] result in

            guard let self else { return }

            switch result {

            case .success(let tweets):
                self.cache.save(tweets,
                                fileName: self.tweetsCacheFile)

                completion(.success(tweets))

            case .failure(let error):
                if let cached: TweetModel = self.cache.read(
                    fileName: self.tweetsCacheFile,
                    as: TweetModel.self
                ) {
                    completion(.success(cached))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
