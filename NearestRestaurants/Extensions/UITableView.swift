//
//  UITableView.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
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

extension UITableViewCell: CellIdentifiable { }

extension UITableView {
    
    func register<T: UITableViewCell>(_ cell: T.Type) {
        
        let nib  = UINib(nibName: T.cellIdentifier, bundle: nil)
        
        register(nib, forCellReuseIdentifier: T.cellIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            
            fatalError("Could not dequeue cell: \(T.cellIdentifier)")
            
        }
        
        return cell
    }
    
}


