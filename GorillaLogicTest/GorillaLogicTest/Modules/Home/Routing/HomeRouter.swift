//
//  HomeRouter.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import UIKit

enum HomeTransition {
    case presentPostDetail(post: Post)
}

final class HomeRouter: NSObject {
    
    private weak var viewController: HomeViewController?
    
    func performTransition(transition: HomeTransition) {
        switch transition {
        case .presentPostDetail(let post):
            presentPostDetail(post: post)
        }
    }
    
    func createViewController(presenter: HomePresentable) -> UIViewController {
        let viewController = HomeViewController(presenter: presenter)
        self.viewController = viewController
        return viewController
    }
}

// MARK: - Private methods
private extension HomeRouter {
    private func presentPostDetail(post: Post) {
        guard let viewController = viewController else { return }
        let postModule = PostModule(post: post)
        postModule.present(in: viewController)
    }
}
