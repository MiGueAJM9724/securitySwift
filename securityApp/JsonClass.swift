//
//  JsonClass.swift
//  securityApp
//
//  Created by Miguel Angel Jimenez Melendez on 20/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import Foundation
import UIKit

class JsonClass: NSObject{
    let urlBase = "http://192.168.8.103/"
    
    func arrayFromJson(url: String, data_send: NSMutableDictionary, comletionHandler: @escaping (NSArray?) -> Void){
        let url = URL(string: "\(urlBase)/\(url)")!
        var request = URLRequest(url: url)
        request.setValue("application/Json; charset=utf-8", forHTTPHeaderField: "Content-type")
        request.setValue("application/Json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: data_send)
        
        let task = URLSession.shared.dataTask(with: request){
            get_data, response, error in if error != nil{
                comletionHandler(nil)
            }else{
                do{
                    print("Get data: \(String(describing: String(data: get_data!, encoding:  .utf8))) - Data send: \(data_send)")
                    if let array = try JSONSerialization.jsonObject(with: get_data!) as? NSArray{
                        comletionHandler(array)
                    }
                }catch let parseError{
                    print("Server error \(String(data: get_data!, encoding:  .utf8)) \(parseError)")
                    comletionHandler(nil)
                }
            }
        }
        task.resume()
    }
}
