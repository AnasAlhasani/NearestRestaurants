//
//  ApiResource.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/13/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

protocol ApiResource {
    
    associatedtype Model
    
    func makeModel(from json: JSON) -> [Model]
}

extension ApiResource {
    
    func getURLFromParameters(_ parameters: [String: Any]) -> URL {
        var components = URLComponents()
        components.scheme = Foursquare.URL.Scheme
        components.host = Foursquare.URL.Host
        components.path = Foursquare.URL.Path
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }

}
