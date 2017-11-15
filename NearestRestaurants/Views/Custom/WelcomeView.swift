//
//  WelcomeView.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/15/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

class WelcomeView: UIView {
    
    //MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    
    //MARK: Properties
    var onButtonTap: (() -> Void)?
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        startButton.layer.cornerRadius = 5
    }

    //Helper method
    func setPermession(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
    
    //MARK: Action
    @IBAction func startButtonTapped(_ sender: UIButton) {
        onButtonTap?()
    }
    
}
