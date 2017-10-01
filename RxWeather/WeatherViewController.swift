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
              alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
              present(alertController, animated: true, completion: nil)
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
      cityNameTextField.rx.text
        .debounce(0.3, scheduler: MainScheduler.instance)
        .subscribe(onNext: { searchText in
          self.viewModel.searchText = searchText

        })
        .addDisposableTo(disposeBag)

      viewModel.cityName
        .bind(to: cityNameLabel.rx.text)
        .addDisposableTo(disposeBag)
        
      viewModel.temp
        .bind(to: tempLabel.rx.text)
        .addDisposableTo(disposeBag)
        
      viewModel.errorAlertController
        .subscribe(onNext: { alertController in
            self.alertController = alertController
        })
        .addDisposableTo(disposeBag)
    }

}

