//
//  PostModule.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import UIKit

final class PostModule {
    
    var presenter: PostPresentable
    
    init(post: Post) {
        let wireframe = PostRouter()
        let interactor = PostInteractor(post: post)
        self.presenter = PostPresenter(wireframe: wireframe, interactor: interactor)
    }
    
    func present(in viewController: UIViewController) {
        return presenter.present(in: viewController)
    }
}
