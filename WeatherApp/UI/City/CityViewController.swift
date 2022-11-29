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

    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = cityName
        // Do any additional setup after loading the view.
    }
}
