//
//  Weather.swift
//  RxWeather
//
//  Created by Ennio Bovyn on 5/02/16.
//  Copyright © 2016 Ennio Bovyn. All rights reserved.
//

import SwiftyJSON

class Weather {
    
    var cityName:String?
    var temp:Double?
    
    init(json: JSON) {
        self.cityName = json["name"].stringValue
        self.temp = json["main"]["temp"].doubleValue
    }
    
}
