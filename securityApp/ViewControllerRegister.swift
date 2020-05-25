//
//  ViewControllerRegister.swift
//  securityApp
//
//  Created by Miguel Angel Jimenez Melendez on 20/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3

class ViewControllerRegister: UIViewController {
    @IBOutlet weak var txt_email: UITextField!
    
    @IBOutlet weak var txt_sex: UITextField!
    @IBOutlet weak var txt_birthdate: UITextField!
    @IBOutlet weak var txt_username: UITextField!
    
    var users = [Users]()
    let dataJsonUrlclass = JsonClass()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_create_account(_ sender: UIButton) {
        if txt_email.text!.isEmpty || txt_username.text!.isEmpty || txt_birthdate.text!.isEmpty || txt_sex.text!.isEmpty{
            show_alert(Title: "Input validation", Message: "Error missing input data")
            txt_email.becomeFirstResponder()
            return
        }else{
            let email = txt_email.text
            let username = txt_username.text
            let birthdate = txt_birthdate.text
            let sex = txt_sex.text
            let ema = txt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let usr = txt_username.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let bir = txt_birthdate.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let s = txt_sex.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            
            let query = "INSERT INTO users(email, username, birthdate, sex) VALUES(?,?,?,?)"
            if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK{
                show_alert(Title: "Error", Message: "Can't link query")
                return
            }
            if sqlite3_bind_text(stmt, 1, ema.utf8String, -1, nil) != SQLITE_OK{
                show_alert(Title: "Error", Message: "Problem in email")
                return
            }
            if sqlite3_bind_text(stmt, 2, usr.utf8String, -1, nil) != SQLITE_OK{
                show_alert(Title: "Error", Message: "Problem in username")
                return
            }
            if sqlite3_bind_text(stmt, 3, bir.utf8String, -1, nil) != SQLITE_OK{
                show_alert(Title: "Error", Message: "Problem in birthdate")
                return
            }
            if sqlite3_bind_text(stmt, 4, s.utf8String, -1, nil) != SQLITE_OK{
                show_alert(Title: "Error", Message: "Problem in sex")
                return
            }
            if sqlite3_step(stmt) != SQLITE_OK{
                let data_to_send = ["email": email!, "username": username!, "birthdate": birthdate!, "sex": sex!] as NSMutableDictionary
                dataJsonUrlclass.arrayFromJson(url: "WebService/insert.php", data_send: data_to_send){
                    (array_response) in DispatchQueue.main.async {
                        let data_dictionary = array_response?.object(at: 0) as! NSDictionary
                        if let msg = data_dictionary.object(forKey: "message") as! String?{
                            print("Successful \(msg)")
                        }
                    }
                }
                self.performSegue(withIdentifier: "segue_primary", sender: self)
            }
        }
    }
    
    func show_alert(Title: String, Message: String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_primary"{
            _ = segue.destination as! ViewController
        }
    }
}
