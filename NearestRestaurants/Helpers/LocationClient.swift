//
//  LocationClient.swift
//  NearestRestaurants
//
//  Created by Anas Alhasani on 11/13/17.
//  Copyright © 2017 Anas Alhasani. All rights reserved.
//

import Foundation
import CoreLocation

class LocationClient: NSObject {
    
    var currentLocation = CLLocation()
    private var locationManager: CLLocationManager!
    
    private lazy var dispatchOnce: () -> Void = {
        NotificationCenter.default.post(
            name: Constant.NotificationCenterKeys.updateLocations,
            object: nil,
            userInfo: nil
        )
        return {}
    }()
    
    class var shared: LocationClient {
        struct Static {
            static let instance = LocationClient()
        }
        return Static.instance
    }
    
    func startUpdatinglocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = LocationClient.shared
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatinglocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
    var currentLatitude: String {
        return String(format: "%f",
                      LocationClient.shared.currentLocation.coordinate.latitude)
    }
    
    var currentLongitude: String {
        return String(format: "%f",
                      LocationClient.shared.currentLocation.coordinate.longitude)
    }
    
}

//MARK: - CLLocationManagerDelegate
extension LocationClient: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        NotificationCenter.default.post(
            name: Constant.NotificationCenterKeys.updateLocations,
            object: nil,
            userInfo: nil
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        dispatchOnce()
    }
}
