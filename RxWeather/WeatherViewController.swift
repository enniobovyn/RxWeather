//
//  WeatherViewController.swift
//  RxWeather
//
//  Created by Ennio Bovyn on 3/02/16.
//  Copyright © 2016 Ennio Bovyn. All rights reserved.
//

import UIKit

import RxSwift

class WeatherViewController: UIViewController {
    
    private let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var cityNameTextField: UITextField!
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    
    private var alertController: UIAlertController? {
        didSet {
            if let alertController = alertController {
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doBinding()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func doBinding() {
        
        // Binding the UI
        cityNameTextField.rx_text
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribeNext { searchText in
                self.viewModel.searchText = searchText
            }
            .addDisposableTo(disposeBag)
        
        viewModel.cityName
            .bindTo(cityNameLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.temp
            .bindTo(tempLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.errorAlertController.subscribeNext { alertController in
            self.alertController = alertController
        }
        .addDisposableTo(disposeBag)
    }

}

