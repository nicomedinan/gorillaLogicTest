//
//  HomeInteractor.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

protocol HomeInteractable {
    var posts: [Post] { get }
    var reloadDataObservable: Observable<Void> { get }
    var dataZeroObservable: Observable<Bool> { get }
    
    func handle(action: HomeAction)
}

final class HomeInteractor {
    
    private(set) var allPosts = [Post]()
    private var searchKeyword = ""
    private var reloadDataSubject = PublishSubject<Void>()
    private var dataZeroSubject = PublishSubject<Bool>()
    
    init() {
        fetchAllPosts()
    }
}

extension HomeInteractor: HomeInteractable {
    
    // MARK: - Protocol
    var reloadDataObservable: Observable<Void> {
        return reloadDataSubject
    }
    
    var dataZeroObservable: Observable<Bool> {
        return dataZeroSubject
    }
    
    var posts: [Post] {
        get {
            if searchKeyword.isEmpty {
                return allPosts
            } else {
                dataZeroSubject.onNext(allPosts.filter({ $0.titleText.lowercased().contains(searchKeyword.lowercased()) }).count == 0)
                return allPosts.filter({ $0.titleText.lowercased().contains(searchKeyword.lowercased()) })
            }
        }
    }
    
    func handle(action: HomeAction) {
        switch action {
        case .reload:
            refreshData()
        case .search(let keyword):
            search(keyword: keyword)
        }
    }
}

// MARK: - Private methods
private extension HomeInteractor {
    func refreshData() {
        allPosts = []
        fetchAllPosts()
    }
    
    func fetchAllPosts() {
        if allPosts.isEmpty {
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
                return
            }
            
            AF.request(url,
                       method: .get,
                       parameters: [:])
                .validate()
                .responseJSON { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        self.allPosts = json.map { (_, data) -> Post in
                            let post = Post()
                            post.titleText = data["title"].stringValue
                            post.descriptionText = data["body"].stringValue
                            return post
                        }
                        self.reloadDataSubject.onNext(())
                    case .failure(let error):
                        print(error)
                    }
            }
        } else {
            self.reloadDataSubject.onNext(())
        }
    }
    
    func search(keyword: String) {
        if keyword.isEmpty {
            dataZeroSubject.onNext(false)
        }
        searchKeyword = keyword
        reloadDataSubject.onNext(())
    }
}
