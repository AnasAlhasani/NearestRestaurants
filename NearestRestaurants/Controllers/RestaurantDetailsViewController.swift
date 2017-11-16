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
    private let annotationIdentifier = "Place"
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
        mapView.delegate = self
        addCurrentLocationButtonItem()
        mapView.addAnnotation(restaurant!)
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
        guard let restaurant = restaurant else { return }
        
        let userLocation = LocationClient.shared.currentLocation
        
        let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        
        let distance = userLocation.distance(from: restaurantLocation)
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2 * distance, 2 * distance)
        
        let adjustRegion = mapView.regionThatFits(region)
        
        mapView.setRegion(adjustRegion, animated:true)

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
            
            guard let latitude = strongSelf.restaurant?.latitude,
                let longitude = strongSelf.restaurant?.longitude else {
                    return
            }
            
            switch app {
                case .appleMaps:
                    UIApplication.openURL([
                        "http://maps.apple.com/maps?saddr=&daddr=\(latitude),\(longitude)"
                    ])
                case .googleMaps:
                    UIApplication.openURL([
                        "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving",
                        "itms-apps://itunes.apple.com/app/id585027354"
                    ])
            }
        }
    }
}

extension RestaurantDetailsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.canShowCallout = false
        annotationView?.image = #imageLiteral(resourceName: "Burger")
        return annotationView
    }
}

