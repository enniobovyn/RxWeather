import UIKit
import RxSwift

class WeatherViewController: UIViewController {

    @IBOutlet private weak var cityNameTextField: UITextField!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    
    private let viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()

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

    private func doBinding() {
        // Binding the UI
        cityNameTextField.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged { $0 == $1 }
            .subscribe(onNext: { self.viewModel.searchText = $0 })
            .addDisposableTo(disposeBag)

        viewModel.cityName
            .bind(to: cityNameLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.temp
            .bind(to: tempLabel.rx.text)
            .addDisposableTo(disposeBag)

        viewModel.errorAlertController
            .subscribe(onNext: { self.alertController = $0 })
            .addDisposableTo(disposeBag)
    }

}
