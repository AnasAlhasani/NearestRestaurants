//
//  CellIdentifiable.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/15/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

protocol CellIdentifiable {
    
    static var cellIdentifier: String { get }
    
}

extension CellIdentifiable where Self: UITableViewCell {
    
    static var cellIdentifier: String {
        
        return String(describing: self)
        
    }
}
