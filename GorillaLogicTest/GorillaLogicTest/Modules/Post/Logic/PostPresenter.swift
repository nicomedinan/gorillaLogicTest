//
//  PostPresenter.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import Foundation
import RxSwift

protocol PostPresentable {
    var post: Post { get }
    
    func present(in: UIViewController)
}

final class PostPresenter: NSObject {
    private let wireframe: PostRouter
    private let interactor: PostInteractable
    private let disposeBag = DisposeBag()
    
    init(wireframe: PostRouter, interactor: PostInteractable) {
        self.wireframe = wireframe
        self.interactor = interactor
    }
}

extension PostPresenter: PostPresentable {
    
    // MARK: - Protocol
    var post: Post {
        return interactor.post
    }
    
    func present(in viewController: UIViewController) {
        wireframe.present(in: viewController, presenter: self)
    }
}
