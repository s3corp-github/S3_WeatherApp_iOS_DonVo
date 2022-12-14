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
    var cityName: String!
    private lazy var viewModel: CityViewModelProtocol = CityViewModel()

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.getWeatherDetail(with: WeatherService.init(city: cityName))
    }

    private func bind() {
        viewModel.didGetWeather = { [weak self] weather in
            DispatchQueue.main.async {
                self?.temperatureLabel.text = weather.tempCString
                self?.humidityLabel.text = weather.formatedHumiditySring
                self?.currentWeatherLabel.text = weather.descriptionString
                self?.weatherImg.loadFromUrl(url: weather.weatherIconUrlString)
                self?.navigationItem.title = weather.nameString
            }
        }

        viewModel.didFailWithError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: error.localizedDescription, title: "Back") {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
