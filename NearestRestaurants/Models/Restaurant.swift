//
//  Restaurant.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit
import MapKit

class Restaurant: NSObject, MKAnnotation {

    //MARK: Properites
    private var address = ""
    var name = ""
    var imageURL: URL?
    var category = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var distance: Int = 0
    
    var distanceDescription: String {
        return "\(distance) m \(address)"
    }
 
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
}

//MARK: - Constants
private extension Restaurant {
    
    struct Keys {
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
        static let photo = "photo"
        static let prefix = "prefix"
        static let suffix = "suffix"
    }
}

//MARK: - Parser
extension Restaurant: ApiResource {
    
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
            
            let photo = item[Keys.photo] as? JSON ?? [:]
            let prefix = photo[Keys.prefix] as? String ?? ""
            let suffix = photo[Keys.suffix] as? String ?? ""
            
            restaurant.name = venue[Keys.name] as? String ?? ""
            restaurant.latitude = location[Keys.latitude] as? Double ?? 0
            restaurant.longitude = location[Keys.longitude] as? Double ?? 0
            restaurant.address = location[Keys.address] as? String ?? ""
            restaurant.distance = location[Keys.distance] as? Int ?? 0
            restaurant.category = categories[0][Keys.categoryName] as? String ?? ""
            restaurant.imageURL = URL(string: prefix+"200"+suffix) ?? nil
            
            restaurants.append(restaurant)
        }
        
        return restaurants
    }
}
