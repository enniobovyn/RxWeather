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
    
    init(json: AnyObject) {
        let data = JSON(json)
        self.cityName = data["name"].stringValue
        self.temp = data["main"]["temp"].doubleValue
    }
    
}
