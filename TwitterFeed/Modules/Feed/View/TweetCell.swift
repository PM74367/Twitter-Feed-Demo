//
//  TweetCell.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//

import UIKit

final class TweetCell: UITableViewCell {

    static let reuseIdentifier = "tweetCell"

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let handleLabel = UILabel()
    private let tweetLabel = UILabel()
    private let mediaImageView = UIImageView()

    private let headerStackView = UIStackView()
    private let contentStackView = UIStackView()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(with tweet: Tweet) {

        nameLabel.text = tweet.author.displayName
        handleLabel.text = tweet.author.handle
        tweetLabel.text = tweet.text

        avatarImageView.loadImage(from: tweet.author.avatarUrl)

        if let media = tweet.mediaUrl, !media.isEmpty {

            mediaImageView.loadImage(from: media)
            mediaImageView.isHidden = false

        } else {

            mediaImageView.isHidden = true
        }
    }

    // MARK: - Setup

    private func setupViews() {

        selectionStyle = .none

        // Avatar

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 24

        // Labels

        nameLabel.font = .boldSystemFont(ofSize: 16)

        handleLabel.font = .systemFont(ofSize: 14)
        handleLabel.textColor = .secondaryLabel

        tweetLabel.font = .systemFont(ofSize: 15)
        tweetLabel.numberOfLines = 0

        // Media

        mediaImageView.contentMode = .scaleAspectFill
        mediaImageView.clipsToBounds = true
        mediaImageView.layer.cornerRadius = 12

        // Header Stack

        headerStackView.axis = .horizontal
        headerStackView.spacing = 8
        headerStackView.alignment = .center

        headerStackView.addArrangedSubview(nameLabel)
        headerStackView.addArrangedSubview(handleLabel)

        // Content Stack

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 12

        contentStackView.addArrangedSubview(headerStackView)
        contentStackView.addArrangedSubview(tweetLabel)
        contentStackView.addArrangedSubview(mediaImageView)

        // Main Layout

        contentView.addSubview(avatarImageView)
        contentView.addSubview(contentStackView)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            // Avatar

            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),

            // Stack

            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            // Media Height

            mediaImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.image = nil
        mediaImageView.image = nil
        mediaImageView.isHidden = true
    }
}
