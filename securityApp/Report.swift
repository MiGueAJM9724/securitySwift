//
//  Report.swift
//  securityApp
//
//  Created by Miguel Angel Jimenez Melendez on 26/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import Foundation

class Reporte{
    var location: String?
    var latitude: String?
    var longitude: String?
    var description: String?
    var score: String?
    
    init(location: String?, latitude: String?, longitude: String?, description: String?, score: String?){
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.description = description
        self.score = score
    }
}
