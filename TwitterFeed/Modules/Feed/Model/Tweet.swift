//
//  Tweet.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//


struct TweetModel: Codable {
    let tweets: [Tweet]
    let nextCursor: String?
}

struct Tweet: Codable {
    let id: String
    let author: Author
    let text: String
    let createdAt: String
    let likeCount: Int
    let retweetCount: Int
    let mediaUrl: String?
}

struct Author: Codable {
    let id: String
    let handle: String
    let displayName: String
    let avatarUrl: String
}

enum FeedState {
    case loading
    case empty
    case error(String)
}
