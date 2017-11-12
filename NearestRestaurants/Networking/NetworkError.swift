//
//  NetworkError.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    
    case forbidden
    case notFound
    case networkProblem(Error)
    case unknown(HTTPURLResponse?)
    case userCancelled
    
    init(error: Error) {
        self = .networkProblem(error)
    }
    
    init(response: URLResponse?) {
        guard let response = response as? HTTPURLResponse else {
            self = .unknown(nil)
            return
        }
        switch response.statusCode {
        case NetworkError.forbidden.statusCode: self = .forbidden
        case NetworkError.notFound.statusCode: self = .notFound
        default: self = .unknown(response)
        }
    }
    
    var statusCode: Int {
        switch self {
        case .forbidden: return 403
        case .notFound: return 404
        case .networkProblem(_): return 10001
        case .unknown(_): return 10002
        case .userCancelled: return 99999
        }
    }
}

