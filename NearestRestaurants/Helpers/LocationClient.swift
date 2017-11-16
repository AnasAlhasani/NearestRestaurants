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
    var locationManager: CLLocationManager?
    
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
    
    
    func setup() {
        locationManager = CLLocationManager()
        locationManager?.delegate = LocationClient.shared
        locationManager?.pausesLocationUpdatesAutomatically = true
        locationManager?.requestWhenInUseAuthorization()
        startUpdatinglocation()
    }
    
    func startUpdatinglocation() {
        guard isAuthorizedWhenInUse else { return }
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatinglocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    
    var isAuthorizedWhenInUse: Bool {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return true
        }else {
            return false
        }
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
        stopUpdatinglocation()
        dispatchOnce()
    }
}
