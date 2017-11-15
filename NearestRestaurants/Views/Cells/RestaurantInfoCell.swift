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
    @IBOutlet private weak var restaurantImageView: UIImageView!
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        restaurantImageView.layer.cornerRadius = restaurantImageView.bounds.height / 2
        restaurantImageView.clipsToBounds = true
    }
    

    //MARK: Properties
    private static let defaultImage = #imageLiteral(resourceName: "RestaurantIcon2")
    
    var restaurant: Restaurant? {
        didSet {
            if let restaurant = restaurant {
                nameLabel.text = restaurant.name
                addressLabel.text = restaurant.category
                distanceLabel.text = restaurant.distanceDescription
            }
        }
    }
    
    var restaurantImage: UIImage? {
        didSet{
            if let restaurantImage = restaurantImage {
                restaurantImageView.image = restaurantImage
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.image = RestaurantInfoCell.defaultImage
    }
}
