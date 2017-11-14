//
//  Date.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/14/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation

extension Date {
    
    func getStringDate(withFormat format: Constant.DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
}
