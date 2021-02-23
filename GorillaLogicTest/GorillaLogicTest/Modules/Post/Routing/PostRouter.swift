//
//  PostRouter.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import UIKit

final class PostRouter {
    
    private weak var viewController: PostViewController?
    
    func present(in presentingController: UIViewController, presenter: PostPresentable) {
        guard let navigation = presentingController.navigationController else { return }
        let viewController = PostViewController(presenter: presenter)
        self.viewController = viewController
        navigation.pushViewController(viewController, animated: true)
    }
}

