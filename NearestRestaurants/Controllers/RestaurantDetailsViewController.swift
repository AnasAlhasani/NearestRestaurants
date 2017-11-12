//
//  RestaurantDetailsViewController.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit

class RestaurantDetailsViewController: UIViewController {

    //MARK: Outlets
    
    //MARK: Properties
    var restaurant: Restaurant? {
        didSet{
            if let restaurant = restaurant {
                title = restaurant.name
            }
        }
    }
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }



}
