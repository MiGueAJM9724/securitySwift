//
//  ViewControllerMap.swift
//  securityApp
//
//  Created by Miguel Angel Jimenez Melendez on 23/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class ViewControllerMap: UIViewController, CLLocationManagerDelegate{
    
    var location: String = ""
    var latitude: String = ""
    var longitude: String = ""
    
    var Reportes = [Reporte]()
    
    let dataJsonUrlClass = JsonClass()
    let locationManager: CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        Reportes.removeAll()
        
        let data_to_send = ["id": ""] as NSMutableDictionary
        dataJsonUrlClass.arrayFromJson(url: "webservice/getreports.php", data_send: data_to_send) {
          (array_request) in
            DispatchQueue.main.async {
                let cuenta = array_request?.count
                for indice in stride(from: 0, to: cuenta!, by: 1){
                    let report = array_request?.object(at: indice) as! NSDictionary
                    let location = report.object(forKey: "location") as! String?
                    let latitude = report.object(forKey: "latitude") as! String?
                    let longitude = report.object(forKey: "longitud") as! String?
                    let description = report.object(forKey: "description") as! String?
                    let score = report.object(forKey: "score") as! String?
                    self.Reportes.append(Reporte(location: location, latitude: latitude, longitude: longitude, description: description, score: score))
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            location = "\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)"
            latitude = "\(currentLocation.coordinate.longitude)"
            longitude = "\(currentLocation.coordinate.longitude)"
        }
        let camera = GMSCameraPosition.camera(withLatitude: Double(Double(latitude)!), longitude: Double(Double(longitude)!), zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        for report in Reportes{
            let marker = GMSMarker()
            var latitud = report.latitude!
            var longitud = report.longitude!
            var location = report.location!
            var score = report.score!
            
            marker.position = CLLocationCoordinate2D(latitude: Double(Double(latitud)!), longitude: Double(Double(longitud)!))
            marker.title = location
            marker.snippet = score
            marker.map = mapView
            print(marker.position)
        }
    }
    
}
