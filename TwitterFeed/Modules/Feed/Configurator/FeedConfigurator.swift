//
//  FeedConfigurator.swift
//  TwitterFeed
//
//  Created by Puneet on 22/05/26.
//

import Foundation
import UIKit

class FeedConfigurator {
    static func getFeedViewController() -> UIViewController {
        let view = FeedViewController()
        let interactor = FeedInteractor()
        let presenter = FeedPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        
        return view
    }
}
