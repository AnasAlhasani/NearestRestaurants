//
//  RestaurantInfoCell.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

class RestaurantInfoCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    //MARK: Properties
    var restaurant: Restaurant? {
        didSet {
            if let restaurant = restaurant {
                nameLabel.text = restaurant.name
                addressLabel.text = restaurant.name
                distanceLabel.text = restaurant.distance
            }
        }
    }
    
}
