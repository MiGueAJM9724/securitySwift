//
//  LocationAdmin.swift
//  securityApp
//
//  Created by Jimenez Melendez Miguel Angel on 21/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import CoreLocation

class LocationAdmin: NSObject, CLLocationManagerDelegate{
    var location_manager: CLLocationManager?
    
    override init(){
        super.init()
        
        location_manager = CLLocationManager()
        location_manager?.delegate=self
        location_manager?.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var _latidude = locations[0].coordinate.latitude
        var _longitude = locations[0].coordinate.longitude
    }
}
