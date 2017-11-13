//
//  Int.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation

extension Int {
    var isSuccessHTTPCode: Bool {
        return 200 <= self && self < 300
    }
}
