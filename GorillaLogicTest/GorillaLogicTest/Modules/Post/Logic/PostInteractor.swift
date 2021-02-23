//
//  PostInteractor.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

protocol PostInteractable {
    var post: Post { get }
}

final class PostInteractor: PostInteractable {

    private(set) var post: Post
    
    init(post: Post) {
        self.post = post
    }
}
