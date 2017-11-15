//
//  RestaurantDetailsViewController.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/12/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var navigationButton: UIButton!
    
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
        navigationController?.navigationBar.topItem?.title = ""
        navigationButton.layer.cornerRadius = 5
        addCurrentLocationButtonItem()
        zoomToCurrentLocation()
        
    }
    
}


//MARK: - Helper methods
private extension RestaurantDetailsViewController {
    
    func addCurrentLocationButtonItem() {
        let button = UIBarButtonItem(
            image: #imageLiteral(resourceName: "CurrentLocation"),
            style: .plain,
            target: self,
            action: #selector(currentLocationTapped)
        )
        navigationItem.rightBarButtonItem = button
    }
    
    func zoomToCurrentLocation() {
        let userLocation = LocationClient.shared.currentLocation

        let center = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}

//MARK: - Actions
private extension RestaurantDetailsViewController {
    
    @objc func currentLocationTapped() {
        zoomToCurrentLocation()
    }
    
    @IBAction func navigationButtonTapped(_ sender: UIButton) {
        displayDirectionsAlert { [weak self] app in
            
            guard let strongSelf = self else { return }

            switch app {
                case .appleMaps: print("")
                case .googleMaps: print("")
            }
        }
    }
}

