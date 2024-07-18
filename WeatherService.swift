//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Kiran Kumar Chaudhary on 2024-07-15.
//

import Foundation

struct WeatherService {
    private let apiKey = "97df990f564a4f5596304321241803"
    private let baseURL = "https://api.weatherapi.com/v1"

    func fetchWeather(for location: String, completion: @escaping (WeatherResponse?) -> Void) {
        guard let url = URL(string: "\(baseURL)/current.json?key=\(apiKey)&q=\(location)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(weatherResponse)
                }
            } catch {
                print("Error decoding weather response: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
}

struct CurrentWeather: Codable {
    let tempC: Double
    let tempF: Double
    let condition: Condition
    
    private enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition
    }
}

struct Condition: Codable {
    let text: String
    let code: Int
}
