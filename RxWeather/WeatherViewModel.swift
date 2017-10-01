import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire
import SwiftyJSON

class WeatherViewModel {

    private struct Constants {
        static let URLPrefix = "http://api.openweathermap.org/data/2.5/weather?q="
        static let URLSuffix = "&units=metric&appid=7b698c5541eae81b147d972c3dbc8b6a"
    }

    let cityName = PublishSubject<String>()
    let temp = PublishSubject<String>()
    let errorAlertController = PublishSubject<UIAlertController>()

    private let disposeBag = DisposeBag()

    var searchText:String? {
        didSet {
            if let text = searchText {
                if text.characters.count >= 3 {
                    if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                        let urlString = Constants.URLPrefix + encodedText + Constants.URLSuffix
                        getWeather(for: urlString)
                    } else {
                        print("Something went wrong with encoding the search text.")
                    }
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
    
    private func getWeather(for urlString: String) {
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
