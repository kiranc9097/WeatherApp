//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kiran Kumar Chaudhary on 2024-07-15.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let weatherService = WeatherService()
    var locationManager: CLLocationManager!
    var isCelsius = true
    var alertController: UIAlertController?
    var citiesWeather: [WeatherResponse] = []
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var symbolImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if let location = searchTextField.text, !location.isEmpty {
            fetchWeather(for: location)
        } else {
            showAlert(title: "Error", message: "Please enter a location to search.")
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func toggleTemperature(_ sender: UISegmentedControl) {
        isCelsius = sender.selectedSegmentIndex == 0
        updateTemperatureLabel()
    }
    
    
    @IBAction func nextViewOpen(_ sender: UIButton) {
        performSegue(withIdentifier: "showCities", sender: self)
    }
    
    func fetchWeather(for location: String) {
        weatherService.fetchWeather(for: location) { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self, let response = response else {
                    self?.showAlert(title: "Error", message: "Failed to fetch weather data.")
                    return
                }
                self.updateUI(with: response)
                self.citiesWeather.append(response)
            }
        }
    }
    
    func updateUI(with response: WeatherResponse) {
        locationLabel.text = response.location.name
        conditionLabel.text = response.current.condition.text
        temperatureLabel.text = "\(response.current.tempC)°C"
        updateSymbolImage(for: response.current.condition.code)
        updateTemperatureLabel()
    }
    
    func updateSymbolImage(for conditionCode: Int) {
        switch conditionCode {
        case 1000:
            symbolImageView.image = UIImage(systemName: "sun.max.fill")
        case 1003:
            symbolImageView.image = UIImage(systemName: "cloud.sun.fill")
        default:
            symbolImageView.image = UIImage(systemName: "questionmark.circle")
        }
    }
    
    func updateTemperatureLabel() {
        if let tempText = temperatureLabel.text, let tempValue = Double(tempText.dropLast(2)) {
            if isCelsius {
                temperatureLabel.text = String(format: "%.1f°C", tempValue)
            } else {
                let fahrenheit = (tempValue * 9/5) + 32
                temperatureLabel.text = String(format: "%.1f°F", fahrenheit)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            fetchWeather(for: "\(latitude),\(longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
        showAlert(title: "Error", message: "Failed to get your location. Please try again.")
    }
    
    func showAlert(title: String, message: String) {
        if alertController != nil {
            alertController?.dismiss(animated: false, completion: nil)
        }
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController?.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController!, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCities" {
            if let destinationVC = segue.destination as? CitiesViewController {
                destinationVC.citiesWeather = citiesWeather
            }
        }
    }
}
