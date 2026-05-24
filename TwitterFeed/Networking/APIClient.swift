//
//  APIClient.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//

import Foundation

final class APIClient {

    static let shared = APIClient()

    func request<T: Decodable>(
        endpoint: String,
        completion: @escaping(Result<T, Error>) -> Void
    ) {

        let mockData: T = getMockTweets(endpoint: endpoint)
//        
//        DispatchQueue.main.async {
//            completion(.success(mockData))
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            completion(.success(mockData))
            completion(.failure(NSError(domain: "Test", code: 123)))
        }
    }
    
    func getMockTweets<T: Decodable>(endpoint: String) -> T {
        let mockJsonName = endpoint.contains("page_2_cursor_9912") ? "feed_page2" : "feed_page1"
        let url = Bundle.main.url(forResource: mockJsonName, withExtension: "json")!

        let data = try! Data(contentsOf: url)
        let tweets = try! JSONDecoder().decode(T.self, from: data)
        return tweets
    }
}
