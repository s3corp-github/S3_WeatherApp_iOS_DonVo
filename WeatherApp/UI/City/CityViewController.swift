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
        navigationItem.title = cityName
        viewModel.delegate = self
        viewModel.fetchWeather(at: cityName ?? "")
        // Do any additional setup after loading the view.
    }
}

//MARK: - CityViewModelDelegate
extension CityViewController: CityViewModelDelegate {
    func didUpdateWeatherCondition(_ model: CityViewModel, weatherModel: Weather) {
        temperatureLabel.text = weatherModel.tempCString
        humidityLabel.text = weatherModel.formatedHumiditySring
        currentWeatherLabel.text = weatherModel.descriptionString
        weatherImg.LoadFromUrl(url: weatherModel.weatherIconUrlString)
    }

    func didFailWithError(_ model: CityViewModel, error: APIError) {
    }
}
