//
//  FeedService.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//


final class FeedService {

    func fetchTweets(
        cursor: String?,
        completion: @escaping(Result<TweetModel, Error>) -> Void
    ) {

        let endpoint = "https://mock.endpoint.com/"+(cursor ?? "")

        APIClient.shared.request(endpoint: endpoint,
                                 completion: completion)
    }
}
