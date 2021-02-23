//
//  HomeModule.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import UIKit

final class HomeModule {
    
    private var presenter: HomePresentable
    
    init() {
        let wireframe = HomeRouter()
        let interactor = HomeInteractor()
        self.presenter = HomePresenter(wireframe: wireframe, interactor: interactor)
    }
    
    func createViewController() -> UIViewController {
        return presenter.createViewController()
    }

    // MARK: Static methods
    static func createModule() -> UINavigationController {
        
        let module = HomeModule()
        let viewController = module.createViewController()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
