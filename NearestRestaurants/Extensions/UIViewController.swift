//
//  UIViewController.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

extension UIViewController: StoryboardIdentifiable {
    
    //MARK: ALert
    func displayAlert(onComplete: (() -> Void)?) {
        
        let alert = UIAlertController(
            title: "Info",
            message: "Sorry, the service is currently not available, please try again later.",
            preferredStyle: .alert
        )
        
        let doneButton = UIAlertAction(
            title: "Retry?",
            style: .default) { _ in
                onComplete?()
        }
        
        let cancelButton = UIAlertAction(
            title: "Cancel",
            style: .destructive) { _ in
        }
        
        alert.addAction(cancelButton)
        alert.addAction(doneButton)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Instantiation
    static func instantiate() -> Self {
        return UIStoryboard(storyboard: .main).instantiateViewController()
    }
    
}


