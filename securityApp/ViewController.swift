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

    var db: OpaquePointer?
    var stmt: OpaquePointer?
    
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
            show_alert(Title: "Error", Message: "\(errordb)")
            return
        }
        if sqlite3_step(stmt) == SQLITE_ROW{
            let username = String(cString: sqlite3_column_text(stmt, 1))
            show_alert(Title: "Welcome", Message: "\(username)")
            return
        }else{
            self.performSegue(withIdentifier: "segue_register", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_register"{
            _ = segue.destination as! ViewControllerRegister
        }
    }

    
    func show_alert(Title: String, Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

