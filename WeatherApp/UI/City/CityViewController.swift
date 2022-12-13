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
        bind()
        viewModel.fetchWeather(at: cityName ?? "")
    }

    private func bind() {
        viewModel.didGetWeather = { [weak self] weather in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.tempCString
                self.humidityLabel.text = weather.formatedHumiditySring
                self.currentWeatherLabel.text = weather.descriptionString
                self.weatherImg.loadFromUrl(url: weather.weatherIconUrlString)
                self.navigationItem.title = weather.nameString
            }
        }

        viewModel.didFailWithError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(message: error.localizedDescription, title: "Back") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
