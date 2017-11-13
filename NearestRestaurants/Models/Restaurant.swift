//
//  Restaurant.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation

class Restaurant: ApiResource {
    
    //MARK: Constants
    private struct Keys {
        static let reponse = "response"
        static let group = "group"
        static let results = "results"
        static let venue = "venue"
        static let name = "name"
        static let location = "location"
        static let latitude = "lat"
        static let longitude = "lng"
        static let distance = "distance"
    }
    
    //MARK: Properites
    var name = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var distance: String = ""
    
    //MARK: Parser
    func makeModel(from json: JSON) -> [Restaurant] {
        var restaurants: [Restaurant] = []
        
        let response = json[Keys.reponse] as? JSON ?? [:]
        let group = response[Keys.group] as? JSON ?? [:]
        let results = group[Keys.results] as? [JSON] ?? []
        
        for item in results {
            let restaurant = Restaurant()
            
            let venue = item[Keys.venue] as? JSON ?? [:]
            let location = venue[Keys.location] as? JSON ?? [:]
            restaurant.name = venue[Keys.name] as? String ?? "-"
            restaurant.latitude = location[Keys.latitude] as? Double ?? 0
            restaurant.longitude = location[Keys.longitude] as? Double ?? 0
            restaurant.longitude = location[Keys.longitude] as? Double ?? 0
            restaurant.distance = (location[Keys.distance] as? Double ?? 0).stringValue+"m"
            restaurants.append(restaurant)
        }

        return restaurants
    }
    
    
}
