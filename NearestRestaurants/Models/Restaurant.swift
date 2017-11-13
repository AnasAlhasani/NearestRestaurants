//
//  Restaurant.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

class Restaurant: ApiResource {
    
    //MARK: Constants
    private struct Keys {
        static let reponse = "response"
        static let group = "group"
        static let results = "results"
        static let venue = "venue"
        static let name = "name"
        static let location = "location"
        static let address = "address"
        static let latitude = "lat"
        static let longitude = "lng"
        static let distance = "distance"
        static let categories = "categories"
        static let categoryName = "shortName"
        static let icon = "icon"
        static let prefix = "prefix"
        static let suffix = "suffix"
    }
    
    //MARK: Properites
    private var address = ""
    var name = ""
    var imageURL: URL?
    var image: UIImage = #imageLiteral(resourceName: "RestaurantIcon2")
    var category = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var distance: Int = 0
    
    var distanceDescription: String {
        return "\(distance) m \(address)"
    }
    
    
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
            let categories = venue[Keys.categories] as? [JSON] ?? []
            restaurant.name = venue[Keys.name] as? String ?? ""
            restaurant.latitude = location[Keys.latitude] as? Double ?? 0
            restaurant.longitude = location[Keys.longitude] as? Double ?? 0
            restaurant.address = location[Keys.address] as? String ?? ""
            restaurant.distance = location[Keys.distance] as? Int ?? 0
            restaurant.category = categories[0][Keys.categoryName] as? String ?? ""
            let icon = categories[0][Keys.icon] as? JSON ?? [:]
            let prefix = icon[Keys.prefix] as? String ?? ""
            let suffix = icon[Keys.suffix] as? String ?? ""
            restaurant.imageURL = URL(string: prefix+suffix) ?? nil

            restaurants.append(restaurant)
        }
        
        return restaurants
    }
    
  
    
}
