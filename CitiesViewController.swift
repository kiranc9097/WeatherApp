//
//  CitiesViewController.swift
//  WeatherApp
//
//  Created by Kiran Kumar Chaudhary on 2024-07-15.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var citiesWeather: [WeatherResponse] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return citiesWeather.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else {
                return UITableViewCell()
            }
            let weather = citiesWeather[indexPath.row]
            cell.cityNameLabel.text = weather.location.name
            cell.temperatureLabel.text = "\(weather.current.tempC)°C"
            cell.weatherConditionLabel.text = weather.current.condition.text
            
            return cell
        }
    }
