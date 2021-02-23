//
//  PostCell.swift
//  GorillaLogicTest
//
//  Created by Nicolas Medina on 22/02/21.
//

import UIKit

final class PostCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.then {
                $0.text = ""
            }
        }
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
}
