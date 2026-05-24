//
//  ImageCache.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//

import Foundation
import UIKit

final class ImageCache {

    static let shared = NSCache<NSString, UIImage>()
}

extension UIImageView {

    func loadImage(from urlString: String) {

        if let cached = ImageCache.shared.object(forKey: urlString as NSString) {
            self.image = cached
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in

            guard let data = data,
                  let image = UIImage(data: data) else { return }

            ImageCache.shared.setObject(image,
                                        forKey: urlString as NSString)

            DispatchQueue.main.async {
                self.image = image
            }

        }.resume()
    }
}
