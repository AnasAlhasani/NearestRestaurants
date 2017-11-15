//
//  PermissionView.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/15/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

class PermissionView: UIView {
    
    //MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var allowButton: UIButton!
    
    //MARK: Properties
    var onButtonTap: (() -> Void)?
    
    var permission: (title: String, message: String)? {
        didSet {
            if let permission = permission {
                titleLabel.text = permission.title
                messageLabel.text = permission.message
            }
        }
    }
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        allowButton.layer.cornerRadius = 5
    }

    //MARK: Action
    @IBAction func allowButtonTapped(_ sender: UIButton) {
        onButtonTap?()
    }
    
}
