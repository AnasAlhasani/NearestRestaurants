//
//  AppDelegate.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configureNavigationBar()
        
        return true
    }

}

//MARK: - Configuration
private extension AppDelegate {
    
    struct Color {
        static let NavigationBar = UIColor(red: 19/255.0, green: 78/255.0, blue: 137/255.0, alpha: 1.0)
    }
    
    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = Color.NavigationBar
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold) 
        ]
    }
    
}
