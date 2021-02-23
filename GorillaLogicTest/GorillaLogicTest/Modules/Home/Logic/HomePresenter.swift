//
//  HomePresenter.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import Foundation
import RxSwift

enum HomeAction {
    case reload
    case search(keyword: String)
}

protocol HomePresentable: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var reloadDataObservable: Observable<Void> { get }
    var dataZeroObservable: Observable<Bool> { get }
    
    func createViewController() -> UIViewController
    func handle(action: HomeAction)
}

final class HomePresenter: NSObject {
    private let wireframe: HomeRouter
    private let interactor: HomeInteractable
    private let disposeBag = DisposeBag()
    
    init(wireframe: HomeRouter, interactor: HomeInteractor) {
        self.wireframe = wireframe
        self.interactor = interactor
        super.init()
    }
}

extension HomePresenter: HomePresentable {
    
    // MARK: - Protocol
    var reloadDataObservable: Observable<Void> {
        return interactor.reloadDataObservable
    }
    
    var dataZeroObservable: Observable<Bool> {
        return interactor.dataZeroObservable
    }
    
    func handle(action: HomeAction) {
        interactor.handle(action: action)
    }
    
    func createViewController() -> UIViewController {
        return wireframe.createViewController(presenter: self)
    }
    
    // MARK: - UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = interactor.posts[safe: indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
                fatalError("Post or PostCell couldn't be found")
        }
        
        cell.setup(title: post.titleText)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = interactor.posts[safe: indexPath.row] else { return }
        wireframe.performTransition(transition: .presentPostDetail(post: post))
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor.handle(action: .search(keyword: searchText))
    }
}
