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
                if (text.characters.count >= 3) {
                    let urlString = Constants.URLPrefix + text.replacingOccurrences(of: " ", with: "%20") + Constants.URLSuffix
                  getWeatherForRequest(urlString: urlString)
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
        
            self.cityName.on(.next(city))
        
            if let temp = weather?.temp {
                self.temp.on(.next("\(temp)°C"))
            }
            
        }
        
    }
    
    private func getWeatherForRequest(urlString: String) {
        Alamofire.request(urlString).rx.responseJSON()
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { dataResponse in
                  if let data = dataResponse.data {
                    let json = JSON(data)
                    if let error = json["message"].string {
                      self.postError(title: "Error", message: error)
                      return
                    }
                    self.weather = Weather(json: json)
                  }
                },
                onError: { error in
                    print("Got error")
                    let gotError = error as NSError
                    
                    print(gotError.domain)
                  self.postError(title: "\(gotError.code)", message: gotError.domain)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func postError(title: String, message: String) {
      errorAlertController.on(.next(UIAlertController(title: title, message: message, preferredStyle: .alert)))
    }

}
