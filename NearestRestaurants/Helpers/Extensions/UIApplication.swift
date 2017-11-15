//
//  UIApplication.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/15/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

extension UIApplication {
    class func openURL(_ stringURLs: [String]) {
        let application = UIApplication.shared
        
        for stringURL in stringURLs {
            guard let url = URL(string: stringURL),
                application.canOpenURL(url) else {
                    continue
            }
            application.open(url)
            return
        }
        
    }
}

