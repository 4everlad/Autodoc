//
//  AppCoordinator.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 22.01.2023.
//

import Foundation
import UIKit

protocol Coordinator : AnyObject {
    var navigationController : UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navCon: UINavigationController) {
        self.navigationController = navCon
    }
    
    func start() {
        let viewModel = NewsFeedViewModel.init()
        viewModel.coordinator = self
        let viewController = NewsFeedViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
    }
    
    func showNews(with news: NewsItem) {
        let viewModel = NewsViewModel(with: news)
        let viewController = NewsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
