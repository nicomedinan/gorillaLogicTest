//
//  PostViewController.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import UIKit
import RxSwift

final class PostViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private var starImageViews: [UIImageView]!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Rx
    private var disposeBag = DisposeBag()
    
    // MARK: - Logic
    private var presenter: PostPresentable
    
    init(presenter: PostPresentable) {
        self.presenter = presenter
        let nibName = String(describing: PostViewController.self)
        let bundle = Bundle.main
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setupImage()
        setupStars()
    }
}

// MARK: - Private methods
private extension PostViewController {
    func setupScreen() {
        titleLabel.text = presenter.post.titleText
        descriptionLabel.text = presenter.post.descriptionText
    }
    
    func setupStars() {
        for (i, star) in starImageViews.enumerated() {
            if presenter.post.rating > i {
                star.image = #imageLiteral(resourceName: "filled.png")
            } else {
                star.image = #imageLiteral(resourceName: "star.png")
            }
        }
    }
    
    func setupImage() {
        imageView.downloaded(from: presenter.post.image, contentMode: .scaleAspectFill)
    }
}
