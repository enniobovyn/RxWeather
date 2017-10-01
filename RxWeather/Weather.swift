import SwiftyJSON

class Weather {

    var cityName:String?
    var temp:Double?

    init(json: JSON) {
        cityName = json["name"].stringValue
        temp = json["main"]["temp"].doubleValue
    }

}
