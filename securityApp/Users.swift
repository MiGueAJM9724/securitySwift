//
//  Users.swift
//  securityApp
//
//  Created by Miguel Angel Jimenez Melendez on 20/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import Foundation
class Users{
    var email: String?
    var username: String?
    var birthdate: String?
    var sex: String?
    
    init(email: String?, username: String?, birthdate: String?, sex: String?){
        self.email = email
        self.username = username
        self.birthdate = birthdate
        self.sex = sex
    }
}
