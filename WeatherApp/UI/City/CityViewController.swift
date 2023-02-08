//
//  CityViewController.swift
//  WeatherApp
//
//  Created by don.vo on 11/29/22.
//

import UIKit

class CityViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!

    //MARK: - Properties
    var cityName: String?
    private var viewModel = CityViewModel()

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchWeather(at: cityName ?? "")
    }
}

//MARK: - CityViewModelDelegate
extension CityViewController: CityViewModelDelegate {
    func didUpdateWeatherCondition(_ model: CityViewModel, weatherModel: Weather) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherModel.tempCString
            self.humidityLabel.text = weatherModel.formatedHumiditySring
            self.currentWeatherLabel.text = weatherModel.descriptionString
            self.weatherImg.loadFromUrl(url: weatherModel.weatherIconUrlString)
            self.navigationItem.title = weatherModel.nameString
        }
    }

    func didFailWithError(_ model: CityViewModel, error: APIError) {
        print("789")
        DispatchQueue.main.async {
            self.showErrorAlert(message: error.localizedDescription, title: "Back") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
