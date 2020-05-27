//
//  ViewControllerReport.swift
//  securityApp
//
//  Created by Miguel Angel Jimenez Melendez on 25/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewControllerReport: UIViewController, CLLocationManagerDelegate{
    @IBOutlet weak var txt_score: UITextField!
    @IBOutlet weak var txt_id_report: UITextField!
    
    @IBOutlet weak var txv_description: UITextView!
    @IBOutlet weak var lb_latitude: UILabel!
    @IBOutlet weak var lb_longitude: UILabel!
    @IBOutlet weak var txt_location_name: UITextField!
    
    var here: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var score: Int = 0
    let dataJsonUrlCLass = JsonClass()
    var mail: String = ""
    let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        show_alert(Title: "Caution", Message: "Fill only the id_report field only if you know the id_report to remove")
        txv_description.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            here = "\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)"
            latitude = (currentLocation.coordinate.latitude)
            longitude = (currentLocation.coordinate.longitude)
            lb_latitude.text = "Latitude: \(latitude)"
            lb_longitude.text = "Longitude: \(longitude)"
        }
    }
    
    @IBAction func btn_remove_report(_ sender: UIButton) {
        if txt_id_report.text!.isEmpty{
            txt_id_report.becomeFirstResponder()
        }else{
            let id_report = txt_id_report.text
            
            let data_to_send = ["id_report": id_report] as! NSMutableDictionary
            dataJsonUrlCLass.arrayFromJson(url: "webservice/remove.php", data_send: data_to_send){
                (array_request) in
                DispatchQueue.main.async {
                    let dictionary_data = array_request?.object(at: 0) as! NSDictionary
                    if let msg = dictionary_data.object(forKey: "mesage") as! String?{
                        self.show_alert(Title: "Remove", Message: msg)
                    }
                    self.txt_id_report.text = ""
                }
            }
        }
    }
 
    @IBAction func btn_create_report(_ sender: UIButton) {
        if txv_description.text!.isEmpty{
            show_alert(Title: "Input validate", Message: "Data missing")
            txv_description.becomeFirstResponder()
        }else{
            let location = txt_location_name.text
            let lati = lb_latitude.text
            let longitud = lb_longitude.text
            let descrip = txv_description.text
            let scor = txt_score.text
            let email = mail
           
            let data_to_send = ["location": location, "latitude": latitude, "longitud": longitude, "description": descrip, "score": scor, "email":email] as NSMutableDictionary
            
            dataJsonUrlCLass.arrayFromJson(url: "webservice/insertreport.php", data_send: data_to_send){
                (array_request) in
                DispatchQueue.main.async {
                    
                        self.show_alert(Title: "Saved", Message: "")
                    self.txv_description.text = ""
                    self.txt_location_name.text = ""
                    self.txt_score.text = "0"
                }
            }
        }
    }
    
    func show_alert(Title: String, Message: String){
           let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
