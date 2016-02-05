//
//  WeatherViewModel.swift
//  RxWeather
//
//  Created by Ennio Bovyn on 5/02/16.
//  Copyright © 2016 Ennio Bovyn. All rights reserved.
//

import RxCocoa
import RxSwift

import SwiftyJSON

import Alamofire
import RxAlamofire

class WeatherViewModel {
    
    private struct Constants {
        static let URLPrefix = "http://api.openweathermap.org/data/2.5/weather?q="
        static let URLSuffix = "&units=metric&appid=7b698c5541eae81b147d972c3dbc8b6a"
    }
    
    private let disposeBag = DisposeBag()
    
    var errorAlertController = PublishSubject<UIAlertController>()
    
    var cityName = PublishSubject<String>()
    var temp = PublishSubject<String>()
    
    var searchText:String? {
        didSet {
            if let text = searchText {
                if (text.characters.count >= 1) {
                    let urlString = Constants.URLPrefix + text.stringByReplacingOccurrencesOfString(" ", withString: "%20") + Constants.URLSuffix
                    getWeatherForRequest(urlString)
                }
            }
        }
    }
    
    private var weather:Weather? {
        didSet {
            updateModel()
        }
    }
    
    private func updateModel() {
        
        if let city = weather?.cityName {
        
            self.cityName.on(.Next(city))
        
            if let temp = weather?.temp {
                self.temp.on(.Next("\(temp)°C"))
            }
            
        }
        
    }
    
    private func getWeatherForRequest(urlString: String) {
        Alamofire.request(Method.GET, urlString).rx_responseJSON()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { json in
                    let jsonForValidation = JSON(json.1)
                    if let error = jsonForValidation["message"].string {
                        print(error)
                        self.postError("Error", message: error)
                        return
                    }
                    self.weather = Weather(json: json.1)
                    
                },
                onError: { error in
                    print("Got error")
                    let gotError = error as NSError
                    
                    print(gotError.domain)
                    self.postError("\(gotError.code)", message: gotError.domain)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func postError(title: String, message: String) {
        errorAlertController.on(.Next(UIAlertController(title: title, message: message, preferredStyle: .Alert)))
    }

}
