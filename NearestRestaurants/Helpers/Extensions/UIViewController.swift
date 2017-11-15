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
            message: "Sorry, something went wrong , please try again later.",
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
    
    func displayDirectionsAlert(onComplete: @escaping (Constant.NavigationApp) -> Void) {
        
        
        let navigationAlert = UIAlertController(
            title: "Directions",
            message: "Which app do you want to use?",
            preferredStyle: .actionSheet
        )
        
        let appleMapsAction = UIAlertAction(
            title: Constant.NavigationApp.appleMaps.title,
            style: .default) { UIAlertAction in
                onComplete(.appleMaps)
        }
        
        let googleMapsAction = UIAlertAction(
            title: Constant.NavigationApp.googleMaps.title,
            style: .default) { UIAlertAction in
                onComplete(.googleMaps)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        navigationAlert.addAction(appleMapsAction)
        navigationAlert.addAction(googleMapsAction)
        navigationAlert.addAction(cancelAction)
        
        present(navigationAlert, animated: true, completion: nil)
    }
    
    //MARK: Instantiation
    static func instantiate() -> Self {
        return UIStoryboard(storyboard: .main).instantiateViewController()
    }
    
}


