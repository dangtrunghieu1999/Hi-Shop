//
//  LocationManager.swift
//  Tiki
//
//  Created by Bee_MacPro on 11/07/2021.
//

import CoreLocation
import UIKit

let locationManager = LocationManager.shared

class LocationManager {
    
    class var shared: LocationManager {
        struct Static {
            static var instance = LocationManager()
        }
        return Static.instance
    }
    
    private var geocoder = CLGeocoder()
    
    func convertCCLocation(address: String?) -> CLLocation{
        var location = CLLocation()
        if let address = address {
            geocoder.geocodeAddressString(address) {
                placemarks, error in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                location = CLLocation(latitude: lat ?? 0, longitude: lon ?? 0)
            }
        }
        return location
    }
}
