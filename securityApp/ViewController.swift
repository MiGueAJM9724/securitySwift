//
//  ViewController.swift
//  securityApp
//
//  Created by Miguel Angel Jimenez Melendez on 20/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    @IBOutlet weak var lb_welcome: UILabel!
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    let dataJsonUrlClass = JsonClass()
    var mail: String = ""
    var Reportes = [Reporte]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteSecurity.sqlite")
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            show_alert(Title: "Error", Message: "The database was not created")
            return
        }
        let table_users = "CREATE TABLE IF NOT EXISTS users(email TEXT PRIMARY KEY, username TEXT, birthdate TEXT, sex TEX)"
        if sqlite3_exec(db, table_users, nil, nil, nil) != SQLITE_OK{
            show_alert(Title: "Error", Message: "The tableUsers was not created")
            return
        }
        let query = "SELECT email, username, birthdate, sex FROM users"
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK{
            let errordb = sqlite3_errmsg(db)
            show_alert(Title: "Error", Message: "\(String(describing: errordb))")
            return
        }
        if sqlite3_step(stmt) == SQLITE_ROW{
            mail = String(cString: sqlite3_column_text(stmt, 0))
            let username = String(cString: sqlite3_column_text(stmt, 1))
            lb_welcome.text = "Welcome \(username)"
            return
        }else{
            self.performSegue(withIdentifier: "segue_register", sender: self)
        }
    }
    
    @IBAction func btn_map(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segue_map", sender: self)
    }
    
    @IBAction func btn_report(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segue_report", sender: self)
    }
    
    @IBAction func btn_list(_ sender: UIButton) {
        Reportes.removeAll()
        
        let data_to_send = ["email": mail] as NSMutableDictionary
        dataJsonUrlClass.arrayFromJson(url: "webservice/getreports.php", data_send: data_to_send){
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
                self.performSegue(withIdentifier: "segue_list", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_register"{
            _ = segue.destination as! ViewControllerRegister
        }
        if segue.identifier == "segue_map"{
            _ = segue.destination as! ViewControllerMap
        }
        if segue.identifier == "segue_report"{
            let x = segue.destination as! ViewControllerReport
            x.mail = mail
            
        }
        if segue.identifier == "segue_list"{
            let seguex = segue.destination as! TableViewControllerList
            seguex.reportes = Reportes
        }
    }

    
    func show_alert(Title: String, Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

