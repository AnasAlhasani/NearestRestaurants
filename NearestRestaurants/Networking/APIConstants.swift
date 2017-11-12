//
//  APIConstants.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation


struct Foursquare {
    
    struct URL {
        static let Scheme = "https"
        static let Host = "api.foursquare.com"
        static let Path = "/v2/search/recommendations"
    }
    
    enum Client: String {
        case ID
        case Secret
        
        var key: String {
            switch self {
            case .ID: return "client_id"
            case .Secret: return "client_secret"
            }
        }
        var value: String {
            switch self {
            case .ID: return "HNLMXI0FSPCSWPPL4TBB0DFLJTWXA5Q4VCIZ0NULY2GHP3R2"
            case .Secret: return "QPMKRWZTQ3NTYHQCHNASVUNOMKEPJDIAOMKIWTOOORANWQKM"
            }
        }
    }
    
    struct SearchKeys {
        static let Location = "ll"
        static let Intent = "intent"
        static let Limit = "limit"
        static let v = "v"
    }
    
}
